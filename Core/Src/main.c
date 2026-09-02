/* main_v5.c - DSB-SC (I/Q) modulator, 465kHz carrier, 2.4MHz sample rate
 *          4096-point Sin LUT  +  USART2 ??????? (???)
 *
 *          PA4 = I-path: band-pass(audio)*cos   PA5 = Q-path: hilbert(audio)*sin
 *          Matched LP-shift phase splitter (I/Q noise balanced), boxcar-32
 *          decimation 2.4MHz->75kHz.  RF sideband: LSB.
 *
 *  =====================================================================
 *  v5 ???? (?? ISR ??: ????? ~347kHz):
 *    v4 ? ISR ???????? 200/?? (480MHz/2.4MHz), ?????
 *    ?? ~1.79MHz -> ?? 465k ??? ~347k, ?????
 *    ??? ISR ??? 200 ???? (???? ~174 ??, ?? ~13%),
 *    ??:
 *      1) splitter ???? 4 ? (??????/??/??)
 *      2) dec_buf ?? 3 ????? (768): ??????? [125,510]/
 *         [0,385] ???????, ??????, 8 ??? LDRSH
 *      3) ??????? int32 (?????, ?????)
 *      4) 4 ?????? __SSAT ???? (???)
 *      5) isr_rx_poll ???? O2, ????? ~5 ??
 *      6) ????: ISR ???????/??/???? (? vsnprintf,
 *         ? double ???; PHASE/TONE ??? 64 ???, ??? -> ??),
 *         ?????????? flush_reply()
 *      7) ?? DWT ????: INFO ??? MAXISR (?? ISR ???),
 *         ???????????? (? ~200; ???? MAXISR ???
 *         ?????, ????)?ISR_TIMING_MEASURE=0 ????
 *    ??? v4 ??: USART2 ??? TIM2 ISR ?, ???, ??????
 *  =====================================================================
 *  v6 ???? (v5 ?? MAXISR ?? 200: ?? 394kHz -> ????? 2.03MHz):
 *    v5 ?? ISR ~236 ??/?? (????), ?????:
 *      1) SLICE=4 -> 1: ???? ISR ?? 1 ? MAC (128 ISR/?), ???
 *         75kHz -> 18.75kHz (?? 0-3k, Nyquist 9.375k ??), ?????????
 *      2) split_wp ??????????, ?????????
 *      3) ??/??/??? I/Q ?????? (recompute_gains), ????
 *         ISR ?? i_audio_dac_run/q_audio_dac_run, ??? ISR ?????
 *      4) DAC ?????: dac = DC + (dac_run*cos)>>15, ??? ISR ? *AMP>>15
 *      5) 4 ? DAC ????? __USAT(,12) ???
 *      6) ????? MODE=1 ????, ????
 *    ??? v5 ?????MAXISR ????? ~160-190?
 *  =====================================================================
 *  v8 ???? (?????? Flash ??):
 *    1) ????????????????? (LSB/USB), ????????,
 *       ??? LSB ?????SIDE ?? (0=LSB 1=USB) ???:
 *         - ?? Q ???? (I·cos+Q·sin=LSB; I·cos-Q·sin=USB)
 *         - ??????????? (IGAIN/PHASE/QUAD/IDC/QDC/AGAIN)
 *       ????????????????? (????, ?????)?
 *       ??????????????? CFG_LSB_DEFAULT / CFG_USB_DEFAULT?
 *    2) ?? v7 ? Flash ????? (???????? Bank ??????,
 *       ?????????)?????????
 *    3) STREAM ????????? I/Q ????? (? 128 ISR ??,
 *       ?? 18.75kHz, ?????), stream_decim ???? (?? 1)?
 *    ??: SIDE <0|1> ???????????; STAT ?? SIDE= ???
 *  =====================================================================
 *  v10 ?????? (????):
 *    1) MODE ??: 6=CW 7=NFM 8=AM (???, DAC1=DAC2 ????????)
 *       - CW : ????, ???? TX ??? PC13 ??????
 *       - NFM: ±25kHz ??, ?? 6kHz ?????????
 *       - AM : ±6kHz ??, 100% ????, ????
 *    2) 6kHz 2?IIR?? (Q14??, 75kHz ?? 32 ISR ??) ? NFM/AM ?
 *    3) ???????: nfm_inc_run/am_env_run ? 75kHz ??????,
 *       ???? ISR ??, ?????
 *    4) PC13 ?? (??, ?????) ?? CW ??
 *    ??: TX <0|1> ?? CW ??; STAT ?? TX=; MODE 0-8?
 *  =====================================================================
 * v20 ????: RX/TX ????????
 *    RX 1: ???????? (DAC ??, ???? DSP), ADC1 ????,
 *          ???? 1.2MHz, ?? 2048 ??? AA 5A, ???????+??
 *    RX 0: ????, tx_dsp_reset ?????? DSP
 *    ?????????, ????????????
 *  =====================================================================
 */

#include "main.h"
#include "stm32h7xx_hal.h"
#include "stm32h7xx_hal_tim.h"
#include "stm32h7xx_hal_dac.h"
#include "stm32h7xx_hal_adc.h"
#include "stm32h7xx_hal_uart.h"
#include <math.h>
#include <stdio.h>
#include <string.h>
#include <stdarg.h>

#ifndef M_PI
#define M_PI 3.141592653589793f
#endif

/* ========== Handlers ========== */
static DAC_HandleTypeDef hdac1;
static TIM_HandleTypeDef htim2;
static ADC_HandleTypeDef hadc3;
static ADC_HandleTypeDef hadc1;
static UART_HandleTypeDef huart2;

#define LED_PIN      GPIO_PIN_1
#define LED_PORT     GPIOC
#define LED_TOGGLE   HAL_GPIO_TogglePin(LED_PORT, LED_PIN)

/* ========== Config ========== */
#define CARRIER_FREQ       465000.0f
#define DC_OFFSET          2048
#define AMPLITUDE          2000        /* DAC ?? */

#define I_PATH_GAIN        32767       /* I ????? (Q15) */
#define Q_PATH_GAIN        32767

#define SAMPLE_RATE        2400000.0f
#define AUDIO_GAIN         64
#define MUTE_THRESHOLD     0
#define USART2_BAUDRATE    921600      /* ?????????? */

/* ===== ISR ???? (DWT ????) =====
 * 1: ??"??????"?????, INFO ??? MAXISR?
 *    2.4MHz@480MHz -> ?? ~200; ??? 200 ?? ISR ???
 * ??????? 0 ??????? */
#define ISR_TIMING_MEASURE   1
#define _DWT_CYCCNT   (*(volatile uint32_t *)0xE0001004UL)
#define _DWT_CTRL     (*(volatile uint32_t *)0xE0001000UL)
#define _DEMCR        (*(volatile uint32_t *)0xE000EDFCUL)
static volatile uint32_t g_prev_isr = 0;
static volatile uint8_t  g_prev_isr_ok = 0;
static volatile uint32_t g_max_isr_cyc = 0;
#define LUT_SIZE           4096
#define LUT_MASK           (LUT_SIZE - 1)
#define STARTUP_DURATION   1.0f
#define STARTUP_COUNT      ((uint32_t)(SAMPLE_RATE * STARTUP_DURATION))
#define CARRIER_PHASE_INC  832149914U

/* ========== ?? + ?????? ========== */
#define DEC_FACTOR         32
#define DEC_TAPS           256
#define DEC_HALF           (DEC_TAPS / 2)
#define DEC_MASK           (DEC_TAPS - 1)
#define SLICE              1   /* v6: ? ISR 1 ? MAC, ?? 128 ISR -> 18.75kHz I/Q ?? (?? 0-3k ??) */
#define SPLIT_FS           75000.0f
#define SPLIT_F0           1650.0f
#define SPLIT_FCLP         1350.0f

/* ========== ??????? (DTCMRAM) ========== */
static int16_t g_q15[DEC_HALF]       __attribute__((section(".dtcmram")));
static int16_t h_q15[DEC_HALF]       __attribute__((section(".dtcmram")));
/* dec_buf: 3 ????? (768) —— ??? 0..255 ????? +256/+512,
 * ???????? [125,510] ? [0,385] ????????????/???
 * ??????????? 3 ?????? */
static int16_t dec_buf[3 * DEC_TAPS] __attribute__((section(".dtcmram")));
static int32_t boxcar_buf[DEC_FACTOR] __attribute__((section(".dtcmram")));
static uint8_t  boxcar_idx = 0;
static int32_t  boxcar_sum = 0;
static uint16_t dec_wp = 0;
static uint16_t pair_idx = 0;
static uint16_t split_wp = 0;          /* v6: ???????????? */
static int64_t  i_acc = 0, q_acc = 0;
static int16_t  i_audio_cur = 0;
static int16_t  q_audio_cur = 0;
/* v6: ??/??/??? I/Q ??????, ???? ISR ??? (??? ISR ????) */
static int32_t  i_audio_g_run = 0;
static int32_t  q_audio_g_run = 0;
static int32_t  i_audio_dac_run = 0;
static int32_t  q_audio_dac_run = 0;
static uint8_t   side_run = 0;            /* 0=LSB 1=USB */

/* ========== v8: LSB/USB ????? (????, ?????????) ==========
 * ??????????? I/Q ???? (QUAD/PHASE/IGAIN ??)?
 * SIDE=0(LSB) ? CFG_LSB_DEFAULT; SIDE=1(USB) ? CFG_USB_DEFAULT?
 * PHASE ??: 0.001°, ?? 14700 = 14.700°?QUAD: Q15?
 * ???? cfg_lsb/cfg_usb ?????? (???????, ???????),
 * ???????????; ??????????????? */
typedef struct {
    int32_t  igain;
    int32_t  qgain;
    uint32_t phase_off32;
    int16_t  quad;
    int16_t  idc;
    int16_t  qdc;
    uint32_t again;
} iq_cfg_t;

#define PHASE_TO_OFF32(d)  ((uint32_t)(((uint64_t)(d) << 32) / 360000ULL))

/* ??? LSB: ???? (PHASE=0°, QUAD=-8127, IGAIN=12976) -- ????????? */
static const iq_cfg_t CFG_LSB_DEFAULT = {
    12976, 38862, PHASE_TO_OFF32(0), -8127, 0, 0, 100 };
/* ??? USB: ???? (PHASE=0°, QUAD=6487, IGAIN=10944) -- ????????? */
static const iq_cfg_t CFG_USB_DEFAULT = {
    10944, 32767, PHASE_TO_OFF32(0), 6487, 0, 0, 64 };

static iq_cfg_t cfg_lsb;   /* ??? LSB ?? (??=??, ??????) */
static iq_cfg_t cfg_usb;   /* ??? USB ?? */
static uint32_t dc_q16 = (2048U << 16);
static uint32_t dec_sample_cnt = 0;

/* ========== ?? ========== */
static int16_t sin_table_q15[LUT_SIZE] __attribute__((section(".dtcmram")));
static int16_t cos_table_q15[LUT_SIZE] __attribute__((section(".dtcmram")));
static float trigger_freq = 0.0f;
static uint32_t carrier_phase = 0;
volatile uint32_t sys_tick = 0;
volatile uint32_t int_count = 0;
static uint8_t modulation_enabled = 0;

volatile int32_t  debug_ac_i = 0;
volatile int16_t  debug_audio_q15 = 0;
volatile int16_t  debug_i_audio = 0;
volatile int16_t  debug_q_audio = 0;

/* ========================================================================
 * USART2 ???? (????????, ISR ?????)
 * ======================================================================== */
volatile int32_t  i_gain_run   = I_PATH_GAIN;
volatile int32_t  q_gain_run   = Q_PATH_GAIN;
volatile uint32_t phase_off32  = 0;
volatile int16_t  quad_q15     = 0;
volatile int16_t  idc_trim     = 0;
volatile int16_t  qdc_trim     = 0;
volatile int32_t  audio_gain_run = AUDIO_GAIN;
volatile uint8_t  mode_run     = 0;
volatile uint16_t tone_freq    = 1000;
volatile uint8_t  stream_en    = 0;
volatile uint16_t stream_decim = 1;

static uint32_t tone_phase = 0;
static uint32_t tone_inc   = 0;
static uint32_t stream_cnt = 0;

/* ========== v10: ????? (CW/NFM/AM) ========== */
/* NFM ??: ±25kHz ??????? = 25000/2.4M*2^32 = 44739242?
 * ? int32 ?? y*1365 (= y*44739242>>15), ?? -0.024% (25k ? 6Hz) */
#define NFM_DEV_Q15_APPROX  1365
#define AM_CARRIER     1000         /* AM ???? (DAC ?, 100% ?? env 0..2000) */
/* 4? Butterworth 6kHz LPF (fs=75kHz), ?? biquad ?? Q14, int32 ???
 * ?? v10 ? 2 ? (12dB/oct), 4 ? 24dB/oct ? FM ????????:
 *   12kHz: 2?-13.4dB -> 4?-26.4dB; 18kHz: -22.6 -> -45.1dB
 * v12: int64->int32 (?0??49.7M ?1??173.5M << 2^31),
 *      ?? 128 ?? ISR ??, ?? STREAM ????????? */
#define LP1_B0 37      /* ?0 Q14 */
#define LP1_B1 73
#define LP1_B2 37
#define LP1_A1 19871
#define LP1_A2 -6292
#define LP2_B0 16384   /* ?1 Q14 (????? 1.0) */
#define LP2_B1 32768
#define LP2_B2 16384
#define LP2_A1 24245
#define LP2_A2 -11283
volatile uint8_t  tx_cmd  = 0;      /* ??? TX ?? */
volatile uint8_t  tx_pc13 = 0;      /* PC13 ?? (1=??) */
volatile uint8_t  tx_sw   = 0;      /* CW ?????? (? PC13) */
static int32_t  l1_x1=0, l1_x2=0, l1_y1=0, l1_y2=0;   /* biquad ?0 */
static int32_t  l2_x1=0, l2_x2=0, l2_y1=0, l2_y2=0;   /* biquad ?1 */
static uint32_t nfm_inc_run = CARRIER_PHASE_INC;
static int32_t  am_env_run  = AM_CARRIER;
static int32_t  lpf_audio_run = 0;   /* 6k ????? (NFM/AM ?????) */

/* ??????? */
#define STREAM_BUF   2048
#define STREAM_MASK  (STREAM_BUF - 1)
#define STREAM_PKT   32
static int16_t stream_buf[STREAM_BUF] __attribute__((section(".dtcmram")));
static volatile uint16_t stream_wp = 0;
static uint16_t stream_rp = 0;
static uint8_t  stream_seq = 0;
/* ========== v20: RX/TX ???? + ?????? ==========
 * RX 1: ???????? (DAC ??, ???? DSP),
 *       ADC1(IN3??) ????, ???? 1.2MHz,
 *       ??? RX_FRAME_N=2048 ? (1.7ms ?) ?? AA 5A ?,
 *       ????????? + ?? (465k±100k)
 * RX 0: ????, ?????? DSP ?? (tx_dsp_reset)
 * ????????? -> ????, ??????????? */
#define RX_FRAME_N   2048
static int16_t rx_buf[RX_FRAME_N] __attribute__((section(".dtcmram")));
static volatile uint8_t  rx_mode = 0;      /* 0=TX 1=RX */
static volatile uint32_t rx_wp = 0;
static volatile uint8_t  rx_ready = 0;     /* ???? */
static volatile uint8_t  rx_acquire = 1;   /* ???? */
static volatile uint8_t  rx_div = 0;       /* ?????? */
static uint8_t  rx_seq = 0;
static uint8_t  rx_tx_active = 0;          /* ?????? */
static uint32_t rx_tx_pos = 0;

/* ========== Prototypes ========== */
static void init_sin_table(void);
static void init_iq_splitter(void);
static void MX_USART2_UART_Init(void);
static void MX_DAC1_Init(void);
static void MX_TIM2_Init(void);
static void MX_ADC3_Init(void);
static void MX_ADC1_Init(void);
static void MX_GPIO_Init(void);
static void uart2_puts(const char *s);
static void uart2_tx(const uint8_t *buf, uint16_t len);
static void isr_rx_poll(void);       /* ? TIM2 ISR ??? */
static void isr_parse(char *line);
static void flush_reply(void);       /* ???: ?? ISR ????? */
static void recompute_gains(void);
static void tx_dsp_reset(void);   /* v20 */
static void apply_cfg(const iq_cfg_t *c);
static iq_cfg_t *cur_cfg(void);

#ifndef __SSAT
static inline int32_t __SSAT(int32_t x, uint32_t sat);   /* ???? (???) */
#endif
#ifndef __USAT
static inline uint32_t __USAT(int32_t x, uint32_t sat);   /* ???? (???) */
#endif

/* ---- v8: ???????????????? ----
 * (???? i_gain_run ?, ????????) */
static void apply_cfg(const iq_cfg_t *c)
{
    i_gain_run     = c->igain;
    q_gain_run     = c->qgain;
    phase_off32    = c->phase_off32;
    quad_q15       = c->quad;
    idc_trim       = c->idc;
    qdc_trim       = c->qdc;
    audio_gain_run = c->again;
    recompute_gains();
}

/* ---- v8: ?????????? (???????) ---- */
static iq_cfg_t *cur_cfg(void)
{
    return side_run ? &cfg_usb : &cfg_lsb;
}

/* ---- v6: I/Q ????????, ?????????? ----
 * ???? ISR ??????; ???????? ISR ???
 * v7: USB ?? Q ?? dac ?? (I·cos+Q·sin=LSB; I·cos-Q·sin=USB)? */
static void recompute_gains(void)
{
    int32_t is, qs;
    switch (mode_run)
    {
        case 0:
        case 4:  is = i_audio_cur; qs = q_audio_cur; break; /* 4=??: tone ?????? */
        case 2:  is = i_audio_cur; qs = 0;           break;
        case 3:  is = 0;           qs = q_audio_cur; break;
        default: is = 0;           qs = 0;           break;
    }
    i_audio_g_run = ((int32_t)__SSAT(is + idc_trim, 16) * i_gain_run) >> 15;
    q_audio_g_run = ((int32_t)__SSAT(qs + qdc_trim + (((int32_t)quad_q15 * is) >> 15), 16) * q_gain_run) >> 15;
    i_audio_dac_run = (i_audio_g_run * AMPLITUDE) >> 15;
    q_audio_dac_run = (q_audio_g_run * AMPLITUDE) >> 15;
    if (side_run) q_audio_dac_run = -q_audio_dac_run;   /* USB ?? Q ?? */
}
static void drain_stream(void);
void SystemClock_Config(void);
void Error_Handler(void);

/* ========== Sin/Cos LUT (Q15) ========== */
static void init_sin_table(void)
{
    for (int i = 0; i < LUT_SIZE; i++) {
        sin_table_q15[i] = (int16_t)(sinf(2.0f * M_PI * i / LUT_SIZE) * 32767.0f);
        cos_table_q15[i] = (int16_t)(cosf(2.0f * M_PI * i / LUT_SIZE) * 32767.0f);
    }
}

/* ========== ???????? ========== */
static void init_iq_splitter(void)
{
    const double fs   = SPLIT_FS;
    const double f0   = SPLIT_F0;
    const double fclp = SPLIT_FCLP;
    const int    N    = DEC_TAPS;
    const double mid  = (double)(N - 1) / 2.0;
    const double wc   = 2.0 * M_PI * fclp / fs;
    const double th0  = 2.0 * M_PI * f0 / fs;
    static double gd[DEC_TAPS], hd[DEC_TAPS];

    for (int n = 0; n < N; n++)
    {
        double x = (double)n - mid;
        double win = 0.54 - 0.46 * cos(2.0 * M_PI * n / (N - 1));
        double sinc = (fabs(x) < 1e-12) ? (wc / M_PI) : (sin(wc * x) / (M_PI * x));
        double pn = sinc * win;
        gd[n] = 2.0 * pn * cos(th0 * x);
        hd[n] = 2.0 * pn * sin(th0 * x);
    }

    double Gr = 0.0, Gi = 0.0;
    for (int n = 0; n < N; n++)
    {
        double x = (double)n - mid;
        double ph = -2.0 * M_PI * f0 * x / fs;
        Gr += gd[n] * cos(ph);
        Gi += gd[n] * sin(ph);
    }
    double G0 = sqrt(Gr * Gr + Gi * Gi);
    double scale = (G0 > 1e-12) ? (1.0 / G0) : 1.0;

    for (int n = 0; n < DEC_HALF; n++)
    {
        double cg = gd[n] * scale;
        double ch = hd[n] * scale;
        if (cg >  1.0) cg =  1.0;
        if (cg < -1.0) cg = -1.0;
        if (ch >  1.0) ch =  1.0;
        if (ch < -1.0) ch = -1.0;
        g_q15[n] = (int16_t)(cg * 32767.0);
        h_q15[n] = (int16_t)(ch * 32767.0);
    }

    memset(dec_buf, 0, sizeof(dec_buf));
    memset(boxcar_buf, 0, sizeof(boxcar_buf));
    boxcar_sum = 0; boxcar_idx = 0;
    dec_wp = 0; pair_idx = 0; split_wp = 0;
    i_acc = 0; q_acc = 0;
    i_audio_cur = 0; q_audio_cur = 0;
    i_audio_g_run = 0; q_audio_g_run = 0;
    i_audio_dac_run = 0; q_audio_dac_run = 0;
    dec_sample_cnt = 0;
    memset(stream_buf, 0, sizeof(stream_buf));
    stream_wp = 0; stream_rp = 0; stream_seq = 0;
    tone_phase = 0;
    tone_inc = (uint32_t)((double)tone_freq / (double)SPLIT_FS * 4294967296.0);
}

/* ========================================================================
 * USART2 (????, ?????)
 * ======================================================================== */
static void MX_USART2_UART_Init(void)
{
    __HAL_RCC_USART2_CLK_ENABLE();
    __HAL_RCC_GPIOA_CLK_ENABLE();
    GPIO_InitTypeDef g = {0};
    g.Pin = GPIO_PIN_2 | GPIO_PIN_3;   /* USART2_TX=PA2, USART2_RX=PA3 */
    g.Mode = GPIO_MODE_AF_PP;
    g.Pull = GPIO_NOPULL;
    g.Speed = GPIO_SPEED_FREQ_HIGH;
    g.Alternate = GPIO_AF7_USART2;
    HAL_GPIO_Init(GPIOA, &g);

    huart2.Instance = USART2;
    huart2.Init.BaudRate = USART2_BAUDRATE;
    huart2.Init.WordLength = UART_WORDLENGTH_8B;
    huart2.Init.StopBits = UART_STOPBITS_1;
    huart2.Init.Parity = UART_PARITY_NONE;
    huart2.Init.Mode = UART_MODE_TX_RX;
    huart2.Init.HwFlowCtl = UART_HWCONTROL_NONE;
    huart2.Init.OverSampling = UART_OVERSAMPLING_16;
    huart2.Init.OneBitSampling = UART_ONE_BIT_SAMPLE_DISABLE;
    if (HAL_UART_Init(&huart2) != HAL_OK) Error_Handler();

    /* ???: ???? USART2 ??, ?? CubeMX ?? IRQHandler ?? */
    HAL_NVIC_DisableIRQ(USART2_IRQn);
}

/* ---- ??????? (TXE ????, ??? HAL ???) ---- */
static void uart2_tx(const uint8_t *buf, uint16_t len)
{
    for (uint16_t i = 0; i < len; i++)
    {
        uint32_t guard = 200000;
        while (!(USART2->ISR & USART_ISR_TXE_TXFNF) && --guard) {}
        USART2->TDR = buf[i];
    }
}

static void uart2_puts(const char *s)
{
    uart2_tx((const uint8_t*)s, (uint16_t)strlen(s));
}

static void uart2_printf(const char *fmt, ...)
{
    char buf[96];
    va_list ap;
    va_start(ap, fmt);
    int n = vsnprintf(buf, sizeof(buf), fmt, ap);
    va_end(ap);
    if (n > 0) uart2_tx((const uint8_t*)buf, (uint16_t)n);
}

/* ========================================================================
 * USART2 RX: ? TIM2 ISR ??? (?????????)
 * ======================================================================== */
#define RX_LINE_MAX 48
static char rx_line[RX_LINE_MAX];
static uint8_t rx_len = 0;
static volatile uint32_t rx_bytes = 0;
static volatile uint32_t rx_ore   = 0;
static volatile uint32_t rx_lines = 0;

/* ---- ISR->??? ????: ISR ?????/??, ??????? ----
 * ?? ISR ????? vsnprintf / ???, ??????? */
#define RPL_NONE  0
#define RPL_OK    1
#define RPL_STAT  2
#define RPL_HELP  3
#define RPL_ERR   4
enum { RC_NONE, RC_IGAIN, RC_QGAIN, RC_PHASE, RC_QUAD, RC_IDC, RC_QDC,
       RC_AGAIN, RC_MODE, RC_TONE, RC_STREAM, RC_SIDE, RC_TX, RC_RX, RC_STAT, RC_HELP };
static volatile uint8_t rpl_kind = RPL_NONE;
static volatile uint8_t rpl_cmd  = RC_NONE;
static volatile int32_t rpl_val  = 0;    /* ??? */
static volatile int32_t rpl_val2 = 0;    /* ??? (STREAM decim) */
static char rpl_badcmd[12];              /* ERR ???? */

/* ---- ???? (ARM ???? SSAT ???; ????????) ---- */
#ifndef __SSAT
static inline int32_t __SSAT(int32_t x, uint32_t sat)
{
    int64_t hi = ((int64_t)1 << (sat - 1)) - 1;   /* 2^(sat-1)-1 */
    int64_t lo = -((int64_t)1 << (sat - 1));      /* -2^(sat-1) */
    if (x > hi) return (int32_t)hi;
    if (x < lo) return (int32_t)lo;
    return x;
}
#endif

/* ---- ??????? (ARM ???? USAT ???) ---- */
#ifndef __USAT
static inline uint32_t __USAT(int32_t x, uint32_t sat)
{
    uint32_t hi = (1u << sat) - 1u;   /* 2^sat - 1 */
    if (x < 0) return 0;
    if ((uint32_t)x > hi) return hi;
    return (uint32_t)x;
}
#endif

/* ---- ISR ?: ????? ---- */
__attribute__((optimize("O2"), hot))
static void isr_rx_poll(void)
{
    if (USART2->ISR & USART_ISR_ORE) { rx_ore++; USART2->ICR = USART_ICR_ORECF; }
    while (USART2->ISR & USART_ISR_RXNE_RXFNE)
    {
        uint8_t b = (uint8_t)(USART2->RDR & 0xFF);
        rx_bytes++;
        if (b == '\n' || b == '\r')
        {
            if (rx_len)
            {
                rx_lines++;
                rx_line[rx_len] = 0;
                isr_parse(rx_line);
                rx_len = 0;
            }
        }
        else if (rx_len < RX_LINE_MAX - 1)
        {
            rx_line[rx_len++] = (char)b;
        }
    }
}

static void isr_parse(char *line)
{
    char cmd[12] = {0};
    int  i = 0, n = 0, a = 0, b = 0, neg = 0, has_b = 0;

    while (line[i] == ' ' || line[i] == '\t') i++;
    while (line[i] && line[i] != ' ' && line[i] != '\t' && n < 11)
    {
        char c = line[i];
        if (c >= 'a' && c <= 'z') c -= 32;
        cmd[n++] = c; i++;
    }
    while (line[i] == ' ' || line[i] == '\t') i++;
    if (line[i] == '-') { neg = 1; i++; }
    while (line[i] >= '0' && line[i] <= '9') { a = a * 10 + (line[i] - '0'); i++; }
    if (neg) a = -a;
    while (line[i] == ' ' || line[i] == '\t') i++;
    if (line[i] >= '0' && line[i] <= '9')
    {
        has_b = 1;
        while (line[i] >= '0' && line[i] <= '9') { b = b * 10 + (line[i] - '0'); i++; }
    }
    if (n == 0) return;

    if (!strcmp(cmd, "IGAIN")) {
        i_gain_run = (a < 0) ? 0 : (a > 65535) ? 65535 : a;
        cur_cfg()->igain = i_gain_run; recompute_gains();
        rpl_kind = RPL_OK; rpl_cmd = RC_IGAIN; rpl_val = i_gain_run;
    }
    else if (!strcmp(cmd, "QGAIN")) {
        q_gain_run = (a < 0) ? 0 : (a > 65535) ? 65535 : a;
        cur_cfg()->qgain = q_gain_run; recompute_gains();
        rpl_kind = RPL_OK; rpl_cmd = RC_QGAIN; rpl_val = q_gain_run;
    }
    else if (!strcmp(cmd, "PHASE")) {
        if (a < 0) a = 0;
        if (a > 360000) a = 360000;
        phase_off32 = (uint32_t)(((uint64_t)a << 32) / 360000ULL); /* ???, ???->?? */
        cur_cfg()->phase_off32 = phase_off32;
        rpl_kind = RPL_OK; rpl_cmd = RC_PHASE; rpl_val = a;
    }
    else if (!strcmp(cmd, "QUAD")) {
        quad_q15 = (int16_t)((a < -32768) ? -32768 : (a > 32767) ? 32767 : a);
        cur_cfg()->quad = quad_q15; recompute_gains();
        rpl_kind = RPL_OK; rpl_cmd = RC_QUAD; rpl_val = quad_q15;
    }
    else if (!strcmp(cmd, "IDC")) {
        idc_trim = (int16_t)((a < -1024) ? -1024 : (a > 1024) ? 1024 : a);
        cur_cfg()->idc = idc_trim; recompute_gains();
        rpl_kind = RPL_OK; rpl_cmd = RC_IDC; rpl_val = idc_trim;
    }
    else if (!strcmp(cmd, "QDC")) {
        qdc_trim = (int16_t)((a < -1024) ? -1024 : (a > 1024) ? 1024 : a);
        cur_cfg()->qdc = qdc_trim; recompute_gains();
        rpl_kind = RPL_OK; rpl_cmd = RC_QDC; rpl_val = qdc_trim;
    }
    else if (!strcmp(cmd, "AGAIN")) {
        audio_gain_run = (a < 0) ? 0 : (a > 1024) ? 1024 : a;
        cur_cfg()->again = audio_gain_run;
        rpl_kind = RPL_OK; rpl_cmd = RC_AGAIN; rpl_val = audio_gain_run;
    }
    else if (!strcmp(cmd, "MODE")) {
        mode_run = (uint8_t)((a < 0) ? 0 : (a > 8) ? 8 : a);
        recompute_gains();
        rpl_kind = RPL_OK; rpl_cmd = RC_MODE; rpl_val = mode_run;
    }
    else if (!strcmp(cmd, "TONE")) {
        tone_freq = (uint16_t)((a < 100) ? 100 : (a > 3000) ? 3000 : a);
        tone_inc  = (uint32_t)(((uint64_t)tone_freq << 32) / 75000ULL); /* ??? */
        tone_phase = 0;
        rpl_kind = RPL_OK; rpl_cmd = RC_TONE; rpl_val = tone_freq;
    }
    else if (!strcmp(cmd, "STREAM")) {
        if (rx_mode) stream_en = 0;      /* v20: RX ??????? */
        else stream_en = (a != 0);
        if (has_b && b >= 1 && b <= 64) stream_decim = (uint16_t)b;
        stream_wp = 0; stream_rp = 0; stream_seq = 0; stream_cnt = 0;
        rpl_kind = RPL_OK; rpl_cmd = RC_STREAM; rpl_val = stream_en; rpl_val2 = stream_decim;
    }
    else if (!strcmp(cmd, "SIDE")) {
        side_run = (a != 0);
        apply_cfg(cur_cfg());   /* ?????????? (? Q ??) */
        rpl_kind = RPL_OK; rpl_cmd = RC_SIDE; rpl_val = side_run;
    }
    else if (!strcmp(cmd, "TX")) {
        tx_cmd = (a != 0);
        rpl_kind = RPL_OK; rpl_cmd = RC_TX; rpl_val = tx_cmd;
    }
    else if (!strcmp(cmd, "RX")) {
        if (a != 0) {
            /* ???: ?????, ????? */
            rx_mode = 1;
            stream_en = 0;                 /* ???? */
            rx_wp = 0; rx_ready = 0; rx_acquire = 1; rx_div = 0;
            rx_tx_active = 0;
            DAC1->DHR12R1 = (uint16_t)DC_OFFSET;
            DAC1->DHR12R2 = (uint16_t)DC_OFFSET;
            if (HAL_ADC_Start(&hadc1) != HAL_OK) Error_Handler();   /* v20.1: ????? ADC1 */
        } else {
            /* ???: ?????? DSP */
            HAL_ADC_Stop(&hadc1);          /* v20.1: ? ADC1, TRGO ????? DAC */
            rx_mode = 0;
            tx_dsp_reset();
        }
        rpl_kind = RPL_OK; rpl_cmd = RC_RX; rpl_val = rx_mode;
    }
    else if (!strcmp(cmd, "STAT") || !strcmp(cmd, "GET")) {
        rpl_kind = RPL_STAT; rpl_cmd = RC_STAT;
    }
    else if (!strcmp(cmd, "HELP")) {
        rpl_kind = RPL_HELP; rpl_cmd = RC_HELP;
    }
    else {
        rpl_kind = RPL_ERR; rpl_cmd = RC_NONE;
        strncpy(rpl_badcmd, cmd, 11); rpl_badcmd[11] = 0;
    }
}

/* ---- ???: ?? ISR ????? (???????) ---- */
static const char *rc_name(uint8_t rc)
{
    switch (rc) {
        case RC_IGAIN:   return "IGAIN";
        case RC_QGAIN:   return "QGAIN";
        case RC_PHASE:   return "PHASE";
        case RC_QUAD:    return "QUAD";
        case RC_IDC:     return "IDC";
        case RC_QDC:     return "QDC";
        case RC_AGAIN:   return "AGAIN";
        case RC_MODE:    return "MODE";
        case RC_TONE:    return "TONE";
        case RC_STREAM:  return "STREAM";
        case RC_SIDE:    return "SIDE";
        case RC_TX:      return "TX";
        case RC_RX:      return "RX";
        default:         return "?";
    }
}

/* ---- ???: ?????? ISR ??? (??????, ????) ---- */
static void flush_reply(void)
{
    if (rpl_kind == RPL_NONE) return;
    char buf[110];
    __disable_irq();
    uint8_t k = rpl_kind, rc = rpl_cmd;
    int32_t v = rpl_val, v2 = rpl_val2;
    char bad[12]; memcpy(bad, rpl_badcmd, 12);
    rpl_kind = RPL_NONE;
    __enable_irq();

    int n = 0;
    if (k == RPL_OK) {
        if (rc == RC_STREAM)
            n = snprintf(buf, sizeof buf, "OK STREAM=%ld DECIM=%ld\n", (long)v, (long)v2);
        else
            n = snprintf(buf, sizeof buf, "OK %s=%ld\n", rc_name(rc), (long)v);
    }
    else if (k == RPL_STAT) {
        n = snprintf(buf, sizeof buf,
            "STAT IGAIN=%ld QGAIN=%ld PHASE=%ld QUAD=%d IDC=%d QDC=%d "
            "AGAIN=%ld MODE=%d TONE=%u STREAM=%d DECIM=%u SIDE=%d TX=%d\n",
            (long)i_gain_run, (long)q_gain_run,
            (long)(((((uint64_t)phase_off32 * 360000ULL) + (1ULL << 31)) >> 32)),
            (int)quad_q15, (int)idc_trim, (int)qdc_trim,
            (long)audio_gain_run, (int)mode_run, (unsigned)tone_freq,
            stream_en, (unsigned)stream_decim, side_run, (int)tx_cmd);
    }
    else if (k == RPL_HELP) {
        n = snprintf(buf, sizeof buf,
            "IGAIN QGAIN PHASE QUAD IDC QDC AGAIN MODE(0-8) TONE STREAM SIDE TX STAT HELP\n"
            "MODE: 0SSB 1CAR 2I 3Q 4TONE 5MUTE 6CW 7NFM 8AM\n");
    }
    else if (k == RPL_ERR) {
        n = snprintf(buf, sizeof buf, "ERR UNKNOWN:%s\n", bad);
    }
    if (n > 0) uart2_tx((const uint8_t*)buf, (uint16_t)n);
}

/* ---- v20: ????? (AA 5A ?, RX_FRAME_N x int16, ????) ---- */
static void drain_rx(void)
{
    if (!rx_tx_active)
    {
        if (!rx_ready) return;
        rx_ready = 0;
        rx_tx_pos = 0;
        rx_tx_active = 1;
        uint8_t hdr[5];
        hdr[0] = 0xAA; hdr[1] = 0x5A;
        hdr[2] = rx_seq++;
        hdr[3] = (uint8_t)(RX_FRAME_N & 0xFF);
        hdr[4] = (uint8_t)((RX_FRAME_N >> 8) & 0xFF);
        uart2_tx(hdr, 5);
    }
    const uint8_t *p = (const uint8_t*)rx_buf;
    uint32_t data_len = 2u * RX_FRAME_N;
    uint32_t remain = data_len - rx_tx_pos;
    if (remain > 512u) remain = 512u;
    if (remain)
    {
        uart2_tx(p + rx_tx_pos, (uint16_t)remain);
        rx_tx_pos += remain;
    }
    if (rx_tx_pos >= data_len)
    {
        rx_tx_active = 0;
        rx_acquire = 1;    /* ??????????? */
    }
}

/* ---- v20: RX ?? TX ??????? DSP ?? ----
 * ???????????, ????????/???? */
static void tx_dsp_reset(void)
{
    init_iq_splitter();      /* ?????/???/?/???? */
    l1_x1=l1_x2=l1_y1=l1_y2=0;
    l2_x1=l2_x2=l2_y1=l2_y2=0;
    lpf_audio_run = 0;
    nfm_inc_run = CARRIER_PHASE_INC;
    am_env_run = AM_CARRIER;
    carrier_phase = 0;
    modulation_enabled = (sys_tick >= STARTUP_COUNT);
    dc_q16 = (2048U << 16);
    stream_cnt = 0;
    apply_cfg(cur_cfg());    /* ?????????? */
}

/* ---- ????? (???????) ---- */
static void drain_stream(void)
{
    uint8_t pkt[4 + 4 * STREAM_PKT];
    while (stream_en)
    {
        uint16_t wp = stream_wp;
        uint16_t avail = (uint16_t)((wp - stream_rp) & STREAM_MASK);
        if (avail < (uint16_t)(2 * STREAM_PKT)) break;

        pkt[0] = 0xAA; pkt[1] = 0x55;
        pkt[2] = stream_seq++;
        pkt[3] = STREAM_PKT;
        for (int i = 0; i < STREAM_PKT; i++)
        {
            uint16_t iv = (uint16_t)stream_buf[stream_rp];
            uint16_t qv = (uint16_t)stream_buf[stream_rp + 1];
            pkt[4 + 4*i + 0] = (uint8_t)(iv & 0xFF);
            pkt[4 + 4*i + 1] = (uint8_t)((iv >> 8) & 0xFF);
            pkt[4 + 4*i + 2] = (uint8_t)(qv & 0xFF);
            pkt[4 + 4*i + 3] = (uint8_t)((qv >> 8) & 0xFF);
            stream_rp = (stream_rp + 2) & STREAM_MASK;
        }
        uart2_tx(pkt, 4 + 4 * STREAM_PKT);
    }
}

/* ---- ???? (?????, ? 2s; ????????) ---- */
static void send_info(void)
{
    static uint32_t last = 0;
    if (sys_tick - last < (2u * (uint32_t)SAMPLE_RATE)) return;
    last = sys_tick;
    if (stream_en) return;
    uint32_t uptime = sys_tick / (uint32_t)SAMPLE_RATE;
    uart2_printf("INFO Up=%us I=%d Q=%d M=%d MOD=%u RXB=%lu RXL=%lu MAXISR=%lu\n",
        uptime, (int)debug_i_audio, (int)debug_q_audio,
        (int)mode_run, (unsigned)modulation_enabled,
        (unsigned long)rx_bytes, (unsigned long)rx_lines,
        (unsigned long)g_max_isr_cyc);
}

/* ================================================================
 * TIM2 direct IRQ @2.4MHz
 * ================================================================ */
/* ================================================================
 * TIM2 direct IRQ @2.4MHz  (v5: ????, ?? ISR < 200 ??)
 * ????: DWT ????, ??"???????????"????,
 *           ???? ~200 (2.4MHz@480MHz); ? >200 ?? ISR ??????
 * ================================================================ */
__attribute__((optimize("O2"), hot))
void TIM2_IRQHandler(void)
{
#if ISR_TIMING_MEASURE
    uint32_t _now = _DWT_CYCCNT;
    uint32_t _dt  = _now - g_prev_isr;
    g_prev_isr    = _now;
    if (g_prev_isr_ok && _dt > g_max_isr_cyc) g_max_isr_cyc = _dt;
    g_prev_isr_ok = 1;
#endif

    TIM2->SR = ~TIM_SR_UIF;
    int_count++;
    sys_tick++;

    if (rx_mode)
    {
        /* ===== v20 RX ??: ????????, ??? ===== */
        if (rx_acquire)
        {
            if ((rx_div++ & 1) == 0)   /* ???? -> 1.2MHz */
            {
                rx_buf[rx_wp++] = (int16_t)(ADC1->DR & 0xFFFF);
                if (rx_wp >= RX_FRAME_N)
                {
                    rx_wp = 0;
                    rx_acquire = 0;
                    rx_ready = 1;
                }
            }
        }
        /* DAC ?? (??????) */
        DAC1->DHR12R1 = (uint16_t)DC_OFFSET;
        DAC1->DHR12R2 = (uint16_t)DC_OFFSET;
        isr_rx_poll();
        return;
    }

    modulation_enabled = (sys_tick >= STARTUP_COUNT);

    /* --- 1. boxcar-32 ???? --- */
    {
        uint32_t raw = (uint32_t)(ADC3->DR & 0xFFFF);
        int32_t bprev = boxcar_buf[boxcar_idx];
        boxcar_buf[boxcar_idx] = (int32_t)raw;
        boxcar_idx = (boxcar_idx + 1) & (DEC_FACTOR - 1);
        boxcar_sum += (int32_t)raw - bprev;
    }

    /* --- 2. ???? (75kHz) --- */
    if (++dec_sample_cnt >= DEC_FACTOR)
    {
        dec_sample_cnt = 0;
        int16_t audio;
        if (mode_run == 4)
        {
            tone_phase += tone_inc;
            audio = (int16_t)sin_table_q15[(tone_phase >> 20) & LUT_MASK];
            debug_audio_q15 = audio;
        }
        else
        {
            int32_t dec = boxcar_sum >> 5;
            dc_q16 = dc_q16 - (dc_q16 >> 10) + ((uint32_t)dec << 6);
            int32_t ac = dec - (int32_t)(dc_q16 >> 16);
            if (ac > -MUTE_THRESHOLD && ac < MUTE_THRESHOLD)
            {
                audio = 0;
            }
            else
            {
                int32_t q = ac * audio_gain_run;
                if (q >  32767) q =  32767;
                if (q < -32768) q = -32768;
                audio = (int16_t)q;
            }
            debug_ac_i = ac;
            debug_audio_q15 = audio;
        }
        dec_buf[dec_wp] = audio;
        dec_buf[dec_wp + DEC_TAPS] = audio;
        dec_buf[dec_wp + 2 * DEC_TAPS] = audio;
        dec_wp = (dec_wp + 1) & DEC_MASK;

        /* --- v11: 6kHz 4?IIR?? (?? biquad Q14, int32 ??, ? NFM/AM) ---
         * v14: ? MODE 7/8 (NFM/AM) ??! SSB/??/CW/??/??????,
         *      ? SSB ? 128 ?? ISR ???? ~44 ?? (?? 200-119=81)?
         *      ?????????, ?? NFM/AM ????? */
        if (mode_run == 7 || mode_run == 8)
        {
            int32_t acc1 = (int32_t)LP1_B0 * audio + (int32_t)LP1_B1 * l1_x1
                         + (int32_t)LP1_B2 * l1_x2 + (int32_t)LP1_A1 * l1_y1
                         + (int32_t)LP1_A2 * l1_y2;
            int32_t y1 = acc1 >> 14;
            if (y1 >  32767) y1 =  32767;
            if (y1 < -32768) y1 = -32768;
            l1_x2 = l1_x1; l1_x1 = audio;
            l1_y2 = l1_y1; l1_y1 = y1;
            int32_t acc2 = (int32_t)LP2_B0 * y1 + (int32_t)LP2_B1 * l2_x1
                         + (int32_t)LP2_B2 * l2_x2 + (int32_t)LP2_A1 * l2_y1
                         + (int32_t)LP2_A2 * l2_y2;
            int32_t y = acc2 >> 14;
            if (y >  32767) y =  32767;
            if (y < -32768) y = -32768;
            l2_x2 = l2_x1; l2_x1 = y1;
            l2_y2 = l2_y1; l2_y1 = y;
            lpf_audio_run = y;                 /* NFM/AM ???? */
            /* NFM: ???? = ???? + ??(±25k), int32 ?? y*1365 */
            nfm_inc_run = (uint32_t)(CARRIER_PHASE_INC + y * NFM_DEV_Q15_APPROX);
            /* AM: ?? = ????*(1 + ??/??) (100% -> env 0..2000) */
            am_env_run  = AM_CARRIER + ((y * AM_CARRIER) >> 15);
        }
    }

    /* --- 3. ?????: SLICE=1 ? ISR 1 ? MAC ---
     * ?? 128 ISR -> ??? 18.75kHz (?? 0-3k, Nyquist 9.375k ??)?
     * split_wp ????????, ?????????? */
    {
        uint16_t n0 = pair_idx;              /* 0..127 */
        uint16_t lo0 = (uint16_t)(split_wp + 255 - n0);
        uint16_t hi0 = (uint16_t)(split_wp + n0);
        int32_t xp0 = dec_buf[lo0];
        int32_t xm0 = dec_buf[hi0];
        i_acc += (int64_t)((int32_t)g_q15[n0] * (xp0 + xm0));
        q_acc += (int64_t)((int32_t)h_q15[n0] * (xp0 - xm0));
        if (++pair_idx >= DEC_HALF)
        {
            pair_idx = 0;
            split_wp = dec_wp;               /* ????????? */
            i_audio_cur = (int16_t)(i_acc >> 15);
            q_audio_cur = (int16_t)(q_acc >> 15);
            i_acc = 0; q_acc = 0;
            recompute_gains();               /* ? 128 ISR ??, ?? <1 ?? */
            /* v13: STREAM ??????? (18.75kHz ??, ?????)?
             * ??????????, ?????????????????:
             *   ??/CW  -> ?? (?????? 465k ???)
             *   NFM/AM   -> 6k ????? (465k±6k ???)
             *   SSB/?? -> I/Q ??? (?????)
             *   ??     -> 0 (???, ????) */
            if (stream_en && (++stream_cnt >= stream_decim))
            {
                stream_cnt = 0;
                int32_t si, sq;
                switch (mode_run)
                {
                    case 1:  si = AMPLITUDE; sq = 0; break;              /* ??? */
                    case 6:  si = tx_sw ? AMPLITUDE : 0; sq = 0; break;  /* CW */
                    case 7:                                               /* NFM */
                    case 8:  si = lpf_audio_run; sq = 0; break;          /* AM */
                    case 5:  si = 0; sq = 0; break;                      /* ?? */
                    default: si = i_audio_g_run; sq = q_audio_g_run; break;
                }
                stream_buf[stream_wp]   = (int16_t)__SSAT(si, 16);
                stream_buf[stream_wp+1] = (int16_t)__SSAT(sq, 16);
                stream_wp = (stream_wp + 2) & STREAM_MASK;
            }
            /* v14: debug ????????, ? 128 ?? ISR ? (?? ISR 2 ? volatile ?) */
            debug_i_audio = i_audio_cur;
            debug_q_audio = q_audio_cur;
        }
    }

    /* --- 4. ?? (????? ISR ??; ??/??/???? recompute_gains ???) --- */
    uint32_t inc = (mode_run == 7) ? nfm_inc_run : CARRIER_PHASE_INC;  /* NFM ????? */
    carrier_phase += inc;
    uint32_t pidx = (carrier_phase >> 20) & LUT_MASK;
    int16_t cosv = cos_table_q15[pidx];

    if (mode_run == 6)
    {
        /* CW: ????, tx_sw=1 ?? / 0 ?? */
        uint16_t v = (uint16_t)__USAT(DC_OFFSET + (tx_sw ? (((int32_t)cosv * AMPLITUDE) >> 15) : 0), 12);
        DAC1->DHR12R1 = v;
        DAC1->DHR12R2 = v;
    }
    else if (mode_run == 8)
    {
        /* AM: 100% ??????, DAC1=DAC2 ???? */
        int32_t m = (am_env_run * cosv) >> 15;
        uint16_t v = (uint16_t)__USAT(DC_OFFSET + m, 12);
        DAC1->DHR12R1 = v;
        DAC1->DHR12R2 = v;
    }
    else if (!modulation_enabled || mode_run == 1 || mode_run == 7)
    {
        /* ?? 1s ??? / MODE=1 ??? / NFM(??????) */
        DAC1->DHR12R1 = (uint16_t)__USAT(DC_OFFSET + (((int32_t)cosv * AMPLITUDE) >> 15), 12);
        DAC1->DHR12R2 = (uint16_t)__USAT(DC_OFFSET + (((int32_t)cosv * AMPLITUDE) >> 15), 12);
    }
    else
    {
        uint32_t q_phase = carrier_phase + phase_off32;
        uint32_t qpidx = (q_phase >> 20) & LUT_MASK;
        int16_t sinv = sin_table_q15[qpidx];

        /* m = dac_run * carrier, |dac_run|<=4000, |carrier|<=32767 -> |?|<=1.31e8 int32 ?? */
        int32_t m1 = i_audio_dac_run * cosv;
        int32_t m2 = q_audio_dac_run * sinv;
        DAC1->DHR12R1 = (uint16_t)__USAT(DC_OFFSET + (m1 >> 15), 12);
        DAC1->DHR12R2 = (uint16_t)__USAT(DC_OFFSET + (m2 >> 15), 12);
    }

    /* USART2 ??: ?? ISR ??, ??????????????? */
    isr_rx_poll();
}

/* ========== main ========== */
int main(void)
{
    HAL_Init();
    SCB_EnableICache();
    SCB_EnableDCache();
    SystemClock_Config();
    MX_GPIO_Init();
    MX_DAC1_Init();
    MX_ADC3_Init();
    MX_ADC1_Init();
    MX_USART2_UART_Init();
    init_iq_splitter();
    /* v8: ??? LSB/USB ??? (???? LSB), SIDE ???????? */
    cfg_lsb = CFG_LSB_DEFAULT;
    cfg_usb = CFG_USB_DEFAULT;
    side_run = 0;
    apply_cfg(&cfg_lsb);
#if ISR_TIMING_MEASURE
    _DEMCR |= (1UL << 24);        /* TRCENA */
    _DWT_CTRL = 0;
    _DWT_CYCCNT = 0;
    _DWT_CTRL |= 1UL;             /* CYCCNTENA */
#endif
    MX_TIM2_Init();

    uint32_t pclk1 = HAL_RCC_GetPCLK1Freq();
    __HAL_TIM_SET_PRESCALER(&htim2, 0);
    __HAL_TIM_SET_AUTORELOAD(&htim2, 99);
    __HAL_TIM_SET_COUNTER(&htim2, 0);
    trigger_freq = (float)pclk1 / 100.0f;

    uart2_printf("PCLK1=%luHz Fs=%.0fHz USART2=%lu single-port RX-in-ISR\n",
        (unsigned long)pclk1, trigger_freq, (unsigned long)USART2_BAUDRATE);
    uart2_puts("HELLO SSB-IQ-TUNER v8\n");
    uart2_puts("USART2 cmd: STAT/HELP SIDE TX (send HELP to list)\n");
    /* v20.2: ??????????, ??????????? */
    uart2_printf("BOOT-LSB IGAIN=%ld QGAIN=%ld PHASE=%ld QUAD=%d IDC=%d QDC=%d AGAIN=%ld\n",
        (long)cfg_lsb.igain, (long)cfg_lsb.qgain,
        (long)(((((uint64_t)cfg_lsb.phase_off32 * 360000ULL) + (1ULL << 31)) >> 32)),
        (int)cfg_lsb.quad, (int)cfg_lsb.idc, (int)cfg_lsb.qdc, (long)cfg_lsb.again);
    uart2_printf("BOOT-USB IGAIN=%ld QGAIN=%ld PHASE=%ld QUAD=%d IDC=%d QDC=%d AGAIN=%ld\n",
        (long)cfg_usb.igain, (long)cfg_usb.qgain,
        (long)(((((uint64_t)cfg_usb.phase_off32 * 360000ULL) + (1ULL << 31)) >> 32)),
        (int)cfg_usb.quad, (int)cfg_usb.idc, (int)cfg_usb.qdc, (long)cfg_usb.again);

    init_sin_table();
    carrier_phase = 0;
    HAL_TIM_Base_Start_IT(&htim2);

    uint32_t last_rep = 0;
    while (1)
    {
        flush_reply();     /* ?? ISR ????? */
        if (rx_mode)
        {
            drain_rx();          /* v20: ????? */
            tx_sw = 0;           /* ??????? */
        }
        else
        {
            drain_stream();
            send_info();
            /* v10: PC13 ???? (??) -> CW ?? */
            tx_pc13 = (HAL_GPIO_ReadPin(GPIOC, GPIO_PIN_13) == GPIO_PIN_RESET) ? 1 : 0;
            tx_sw = (tx_cmd || tx_pc13) ? 1 : 0;
        }
        if (sys_tick - last_rep >= (uint32_t)SAMPLE_RATE)
        {
            last_rep = sys_tick;
            LED_TOGGLE;
        }
    }
}

/* ========== DAC1: TIM2 TRGO trigger, output buffer disable ========== */
static void MX_DAC1_Init(void)
{
    __HAL_RCC_DAC12_CLK_ENABLE();
    __HAL_RCC_GPIOA_CLK_ENABLE();
    GPIO_InitTypeDef g = {0};
    g.Pin = GPIO_PIN_4 | GPIO_PIN_5;
    g.Mode = GPIO_MODE_ANALOG;
    g.Pull = GPIO_NOPULL;
    HAL_GPIO_Init(GPIOA, &g);
    DAC_ChannelConfTypeDef s = {0};
    s.DAC_Trigger = DAC_TRIGGER_T2_TRGO;
    s.DAC_OutputBuffer = DAC_OUTPUTBUFFER_DISABLE;
    s.DAC_SampleAndHold = DAC_SAMPLEANDHOLD_DISABLE;
    s.DAC_ConnectOnChipPeripheral = DAC_CHIPCONNECT_DISABLE;
    s.DAC_UserTrimming = DAC_TRIMMING_FACTORY;
    hdac1.Instance = DAC1;
    if (HAL_DAC_Init(&hdac1) != HAL_OK) Error_Handler();
    if (HAL_DAC_ConfigChannel(&hdac1, &s, DAC_CHANNEL_1) != HAL_OK) Error_Handler();
    if (HAL_DAC_ConfigChannel(&hdac1, &s, DAC_CHANNEL_2) != HAL_OK) Error_Handler();
    if (HAL_DAC_Start(&hdac1, DAC_CHANNEL_1) != HAL_OK) Error_Handler();
    if (HAL_DAC_Start(&hdac1, DAC_CHANNEL_2) != HAL_OK) Error_Handler();
}

/* ========== TIM2 ========== */
static void MX_TIM2_Init(void)
{
    __HAL_RCC_TIM2_CLK_ENABLE();
    htim2.Instance = TIM2;
    htim2.Init.Prescaler = 0;
    htim2.Init.CounterMode = TIM_COUNTERMODE_UP;
    htim2.Init.Period = 99;
    htim2.Init.ClockDivision = TIM_CLOCKDIVISION_DIV1;
    htim2.Init.AutoReloadPreload = TIM_AUTORELOAD_PRELOAD_DISABLE;
    if (HAL_TIM_Base_Init(&htim2) != HAL_OK) Error_Handler();
    TIM_ClockConfigTypeDef sclk = {0};
    sclk.ClockSource = TIM_CLOCKSOURCE_INTERNAL;
    if (HAL_TIM_ConfigClockSource(&htim2, &sclk) != HAL_OK) Error_Handler();
    TIM_MasterConfigTypeDef sm = {0};
    sm.MasterOutputTrigger = TIM_TRGO_UPDATE;
    sm.MasterSlaveMode = TIM_MASTERSLAVEMODE_DISABLE;
    if (HAL_TIMEx_MasterConfigSynchronization(&htim2, &sm) != HAL_OK) Error_Handler();
    HAL_NVIC_SetPriority(TIM2_IRQn, 0, 0);
    HAL_NVIC_EnableIRQ(TIM2_IRQn);
}

/* ========== ADC1: IN3 ?? (PA6=INP/PA7=INN), 12bit, TIM2 TRGO ?? ==========
 * ? DAC ?? TIM2 TRGO (2.4MHz), ?????????????
 * ????: Vref ??? ±Vref/2, ?? 0~4095, ?? 2048 (0V ??)? */
static void MX_ADC1_Init(void)
{
    __HAL_RCC_ADC12_CLK_ENABLE();
    __HAL_RCC_GPIOA_CLK_ENABLE();
    GPIO_InitTypeDef g = {0};
    g.Pin = GPIO_PIN_6 | GPIO_PIN_7;
    g.Mode = GPIO_MODE_ANALOG;
    g.Pull = GPIO_NOPULL;
    HAL_GPIO_Init(GPIOA, &g);
    hadc1.Instance = ADC1;
    hadc1.Init.ClockPrescaler = ADC_CLOCK_SYNC_PCLK_DIV4;
    hadc1.Init.Resolution = ADC_RESOLUTION_12B;
    hadc1.Init.ScanConvMode = DISABLE;
    hadc1.Init.ContinuousConvMode = DISABLE;
    hadc1.Init.DiscontinuousConvMode = DISABLE;
    hadc1.Init.ExternalTrigConvEdge = ADC_EXTERNALTRIGCONVEDGE_RISING;
    hadc1.Init.ExternalTrigConv = ADC_EXTERNALTRIG_T2_TRGO;  /* v21: ???? (????) */
    hadc1.Init.NbrOfConversion = 1;
    hadc1.Init.EOCSelection = ADC_EOC_SINGLE_CONV;
    hadc1.Init.LowPowerAutoWait = DISABLE;
    hadc1.Init.Overrun = ADC_OVR_DATA_OVERWRITTEN;
    hadc1.Init.OversamplingMode = DISABLE;
    if (HAL_ADC_Init(&hadc1) != HAL_OK) Error_Handler();
    ADC_ChannelConfTypeDef s = {0};
    s.Channel = ADC_CHANNEL_3;
    s.Rank = ADC_REGULAR_RANK_1;
    s.SamplingTime = ADC_SAMPLETIME_1CYCLE_5;
    s.SingleDiff = ADC_DIFFERENTIAL_ENDED;
    s.OffsetNumber = ADC_OFFSET_NONE;
    s.Offset = 0;
    if (HAL_ADC_ConfigChannel(&hadc1, &s) != HAL_OK) Error_Handler();
    if (HAL_ADCEx_Calibration_Start(&hadc1, ADC_CALIB_OFFSET, ADC_DIFFERENTIAL_ENDED) != HAL_OK) Error_Handler();
    /* v20.1: ??????? ADC1!
     * TX ??? ADC1 ???? (TIM2 TRGO ??? DAC1, ? v5/18_ ??????),
     * ?? ADC1 ??????? TRGO ????? DAC ??/?????
     * ???(RX 1)? HAL_ADC_Start ??, ???(RX 0)? HAL_ADC_Stop ??? */
}

/* ========== ADC3: SYNC PCLK/4=30MHz, 1.5cyc ========== */
static void MX_ADC3_Init(void)
{
    __HAL_RCC_ADC3_CLK_ENABLE();
    __HAL_RCC_GPIOC_CLK_ENABLE();
    GPIO_InitTypeDef g = {0};
    g.Pin = GPIO_PIN_3;
    g.Mode = GPIO_MODE_ANALOG;
    g.Pull = GPIO_NOPULL;
    HAL_GPIO_Init(GPIOC, &g);
    hadc3.Instance = ADC3;
    hadc3.Init.ClockPrescaler = ADC_CLOCK_SYNC_PCLK_DIV4;
    hadc3.Init.Resolution = ADC_RESOLUTION_10B;
    hadc3.Init.ScanConvMode = DISABLE;
    hadc3.Init.ContinuousConvMode = ENABLE;
    hadc3.Init.DiscontinuousConvMode = DISABLE;
    hadc3.Init.ExternalTrigConvEdge = ADC_EXTERNALTRIGCONVEDGE_NONE;
    hadc3.Init.ExternalTrigConv = ADC_SOFTWARE_START;
    hadc3.Init.NbrOfConversion = 1;
    hadc3.Init.EOCSelection = ADC_EOC_SINGLE_CONV;
    hadc3.Init.LowPowerAutoWait = DISABLE;
    hadc3.Init.Overrun = ADC_OVR_DATA_OVERWRITTEN;
    hadc3.Init.OversamplingMode = DISABLE;
    if (HAL_ADC_Init(&hadc3) != HAL_OK) Error_Handler();
    ADC_ChannelConfTypeDef s = {0};
    s.Channel = ADC_CHANNEL_1;
    s.Rank = ADC_REGULAR_RANK_1;
    s.SamplingTime = ADC_SAMPLETIME_1CYCLE_5;
    s.SingleDiff = ADC_SINGLE_ENDED;
    s.OffsetNumber = ADC_OFFSET_NONE;
    s.Offset = 0;
    if (HAL_ADC_ConfigChannel(&hadc3, &s) != HAL_OK) Error_Handler();
    if (HAL_ADCEx_Calibration_Start(&hadc3, ADC_CALIB_OFFSET, ADC_SINGLE_ENDED) != HAL_OK) Error_Handler();
    if (HAL_ADC_Start(&hadc3) != HAL_OK) Error_Handler();
}

/* ========== GPIO ========== */
static void MX_GPIO_Init(void)
{
    __HAL_RCC_GPIOC_CLK_ENABLE();
    GPIO_InitTypeDef g = {0};
    g.Pin = LED_PIN;
    g.Mode = GPIO_MODE_OUTPUT_PP;
    g.Pull = GPIO_PULLUP;
    g.Speed = GPIO_SPEED_FREQ_HIGH;
    HAL_GPIO_Init(LED_PORT, &g);
    /* v10: PC13 CW ????, ??, ??=???=?? */
    g.Pin = GPIO_PIN_13;
    g.Mode = GPIO_MODE_INPUT;
    g.Pull = GPIO_PULLUP;
    g.Speed = GPIO_SPEED_FREQ_LOW;
    HAL_GPIO_Init(GPIOC, &g);
}

/* ========== SystemClock (APB1 DIV1 -> PCLK1=240MHz, TIM2=240MHz) ========== */
void SystemClock_Config(void)
{
    RCC_OscInitTypeDef o = {0};
    RCC_ClkInitTypeDef c = {0};
    HAL_PWREx_ConfigSupply(PWR_LDO_SUPPLY);
    __HAL_PWR_VOLTAGESCALING_CONFIG(PWR_REGULATOR_VOLTAGE_SCALE0);
    while (!__HAL_PWR_GET_FLAG(PWR_FLAG_VOSRDY)) {}
    o.OscillatorType = RCC_OSCILLATORTYPE_HSE;
    o.HSEState = RCC_HSE_ON;
    o.PLL.PLLState = RCC_PLL_ON;
    o.PLL.PLLSource = RCC_PLLSOURCE_HSE;
    o.PLL.PLLM = 5;
    o.PLL.PLLN = 192;
    o.PLL.PLLP = 2;
    o.PLL.PLLQ = 2;
    o.PLL.PLLR = 2;
    if (HAL_RCC_OscConfig(&o) != HAL_OK) Error_Handler();
    c.ClockType = RCC_CLOCKTYPE_HCLK | RCC_CLOCKTYPE_SYSCLK
                 | RCC_CLOCKTYPE_PCLK1 | RCC_CLOCKTYPE_PCLK2
                 | RCC_CLOCKTYPE_D3PCLK1 | RCC_CLOCKTYPE_D1PCLK1;
    c.SYSCLKSource = RCC_SYSCLKSOURCE_PLLCLK;
    c.SYSCLKDivider = RCC_SYSCLK_DIV1;
    c.AHBCLKDivider = RCC_HCLK_DIV2;
    c.APB3CLKDivider = RCC_APB3_DIV2;
    c.APB1CLKDivider = RCC_APB1_DIV1;
    c.APB2CLKDivider = RCC_APB2_DIV2;
    c.APB4CLKDivider = RCC_APB4_DIV2;
    if (HAL_RCC_ClockConfig(&c, FLASH_LATENCY_4) != HAL_OK) Error_Handler();
}

void Error_Handler(void)
{
    while (1)
    {
        HAL_GPIO_TogglePin(LED_PORT, LED_PIN);
        HAL_Delay(50);
    }
}
