/**
  ******************************************************************************
  * @file    am_demod.c
  * @brief   Multi-mode demodulator: AM / FM / USB / LSB / CW with AGC
  *
  *  - 6th-order channel + 4th-order audio Butterworth filters (float biquad, H7 FPU)
  *  - 3-stage anti-alias LPF at 1.2MHz before 25x decimation
  *  - ISR: DDC + anti-alias + decimation
  *  - Main loop: channel(IF) filter -> demod/discriminator -> audio shaping -> AGC
  *  - AM +-4.5kHz, FM +-25kHz, SSB 300-3000Hz, CW 1.2kHz (GB/ITU channel plan)
  ******************************************************************************
  */

#include "am_demod.h"
#include "stm32h7xx_hal.h"   /* __disable_irq / __enable_irq for the ISR filter swap */
#include <string.h>
#include <math.h>

#define SIN_LUT_SIZE   256U
#define SIN_LUT_MASK   (SIN_LUT_SIZE - 1U)

static const int16_t sin_lut[SIN_LUT_SIZE] = {
       0,   804,  1608,  2411,  3212,  4011,  4808,  5602,
    6393,  7180,  7962,  8740,  9512, 10279, 11039, 11793,
   12540, 13279, 14010, 14732, 15446, 16151, 16846, 17530,
   18204, 18868, 19519, 20159, 20787, 21403, 22006, 22595,
   23170, 23731, 24279, 24811, 25329, 25832, 26319, 26790,
   27245, 27683, 28106, 28510, 28898, 29268, 29621, 29956,
   30273, 30572, 30853, 31115, 31359, 31585, 31791, 31979,
   32148, 32298, 32429, 32541, 32635, 32709, 32765, 32767,
   32767, 32767, 32765, 32709, 32635, 32541, 32429, 32298,
   32148, 31979, 31791, 31585, 31359, 31115, 30853, 30572,
   30273, 29956, 29621, 29268, 28898, 28510, 28106, 27683,
   27245, 26790, 26319, 25832, 25329, 24811, 24279, 23731,
   23170, 22595, 22006, 21403, 20787, 20159, 19519, 18868,
   18204, 17530, 16846, 16151, 15446, 14732, 14010, 13279,
   12540, 11793, 11039, 10279,  9512,  8740,  7962,  7180,
    6393,  5602,  4808,  4011,  3212,  2411,  1608,   804,
       0,  -804, -1608, -2411, -3212, -4011, -4808, -5602,
   -6393, -7180, -7962, -8740, -9512,-10279,-11039,-11793,
  -12540,-13279,-14010,-14732,-15446,-16151,-16846,-17530,
  -18204,-18868,-19519,-20159,-20787,-21403,-22006,-22595,
  -23170,-23731,-24279,-24811,-25329,-25832,-26319,-26790,
  -27245,-27683,-28106,-28510,-28898,-29268,-29621,-29956,
  -30273,-30572,-30853,-31115,-31359,-31585,-31791,-31979,
  -32148,-32298,-32429,-32541,-32635,-32709,-32765,-32767,
  -32767,-32767,-32765,-32709,-32635,-32541,-32429,-32298,
  -32148,-31979,-31791,-31585,-31359,-31115,-30853,-30572,
  -30273,-29956,-29621,-29268,-28898,-28510,-28106,-27683,
  -27245,-26790,-26319,-25832,-25329,-24811,-24279,-23731,
  -23170,-22595,-22006,-21403,-20787,-20159,-19519,-18868,
  -18204,-17530,-16846,-16151,-15446,-14732,-14010,-13279,
  -12540,-11793,-11039,-10279, -9512, -8740, -7962, -7180,
   -6393, -5602, -4808, -4011, -3212, -2411, -1608,  -804
};

#define SSB_BW_HZ       3000U
#define CW_BEAT_HZ      600U
#define CW_SHIFT_HZ     1200U

/* ------------------------ Float Biquad (Direct Form I) ---------------------- */
typedef struct {
    float b0, b1, b2, a1, a2;
    float x1, x2, y1, y2;
} Biquad;

static inline float biquad_process(Biquad *f, float x)
{
    float y = f->b0*x + f->b1*f->x1 + f->b2*f->x2 - f->a1*f->y1 - f->a2*f->y2;
    f->x2 = f->x1; f->x1 = x;
    f->y2 = f->y1; f->y1 = y;
    return y;
}

static inline void biquad_reset(Biquad *f) { f->x1=f->x2=f->y1=f->y2=0.0f; }

/* ------------------------------------------------------------------------
 * v71: IF channel filters, run at 600kHz BEFORE the 12.5x decimation.
 *
 * Previously the narrow filters ran at 48kHz, i.e. *after* decimation, so
 * every signal sitting a multiple of 48kHz away from the tuned frequency
 * folded into the audio band and the same station could be heard on many
 * frequencies.  These Butterworth sections sit in front of the decimator.
 *
 *   mode   order  -3dB   first alias   attenuation
 *   SSB      4   3.2kHz     43.5kHz      -91dB
 *   AM       4   4.5kHz     43.5kHz      -79dB
 *   CW       4   0.8kHz     43.5kHz     -139dB
 *   FM       4   8.5kHz     39.5kHz      -53dB
 * ---------------------------------------------------------------------- */
static const Biquad if_lpf_ssb[2] = {
    {5.4248636210e-08f,1.0849727242e-07f,5.4248636210e-08f,-1.9436965820f,9.4462064874e-01f,0,0,0,0},
    {1.0f,2.0f,1.0f,-1.9757436105f,9.7668291297e-01f,0,0,0,0},
};

static const Biquad if_lpf_am[2] = {
    {2.0876862910e-07f,4.1753725819e-07f,2.0876862910e-07f,-1.9211936226f,9.2300054416e-01f,0,0,0,0},
    {1.0f,2.0f,1.0f,-1.9655212740f,9.6736988660e-01f,0,0,0,0},
};

static const Biquad if_lpf_cw[2] = {
    {2.1834382519e-10f,4.3668765038e-10f,2.1834382519e-10f,-1.9858004769f,9.8585946020e-01f,0,0,0,0},
    {1.0f,2.0f,1.0f,-1.9940592085f,9.9411843715e-01f,0,0,0,0},
};

#define IF_FILT_FM_SECTIONS 2
static const Biquad if_lpf_fm[IF_FILT_FM_SECTIONS] = {
    {2.5311034258e-06f,5.0622068516e-06f,2.5311034258e-06f,-1.8532429748f,8.5947441225e-01f,0,0,0,0},
    {1.0f,2.0f,1.0f,-1.9327948626f,9.3929378927e-01f,0,0,0,0},
};

#define IF_FILT_MAX_SECTIONS 2

static const Biquad hpf300_af[2] = {
    {9.4998178264e-01f,-1.8999635653f,9.4998178264e-01f,-1.9285084851f,9.2999644240e-01f,0,0,0,0},
    {1.0f,-2.0f,1.0f,-1.9688774974f,9.7039660176e-01f,0,0,0,0},
};

static const Biquad lpf4k5_af[2] = {
    {3.8695183185e-03f,7.7390366370e-03f,3.8695183185e-03f,-1.0988972700f,3.2163250912e-01f,0,0,0,0},
    {1.0f,2.0f,1.0f,-1.3713746551f,6.4933827386e-01f,0,0,0,0},
};

static const Biquad lpf3k_af[2] = {
    {9.3349861295e-04f,1.8669972259e-03f,9.3349861295e-04f,-1.3651172372f,4.7759225007e-01f,0,0,0,0},
    {1.0f,2.0f,1.0f,-1.6117270965f,7.4452083821e-01f,0,0,0,0},
};

/* v71: Weaver single-sideband detector, replacing the old Hilbert phasing
 * network.  The 63-tap Hilbert this replaces only managed about 7dB of
 * sideband rejection measured end to end (the group delay of a Hilbert FIR
 * eats most of the accuracy at 300Hz, where a 63-tap design has barely one
 * cycle of resolution), which is why both sidebands came through on SSB.
 *
 * Weaver: shift the complex baseband down by the band centre (1650Hz) so the
 * wanted sideband lands inside +-1350Hz and the unwanted one outside
 * +-1950Hz, low-pass I and Q with one real filter, shift back and take the
 * real part.  An order-7 elliptic low-pass gives 70dB of sideband rejection
 * for 4 biquads on each of I and Q -- two orders of magnitude cheaper than
 * the ~511-tap Hilbert that would be needed for the same figure. */
#define WV_SHIFT_HZ   1650U
#define WV_SECTIONS   4
static const Biquad wv_lpf[WV_SECTIONS] = {
    {2.2943281095e-04f,2.2943281095e-04f,0.0f,-9.4193219938e-01f,0.0f,0,0,0,0},
    {1.0f,-1.7572260443f,1.0f,-1.8980629633f,9.1008891484e-01f,0,0,0,0},
    {1.0f,-1.9083876637f,1.0f,-1.9251544059f,9.5225171870e-01f,0,0,0,0},
    {1.0f,-1.9330592721f,1.0f,-1.9499708078f,9.8607444476e-01f,0,0,0,0},
};

#define DTCM /* v22.1: .dtcmram section removed (scatter file never defined it; buffers landed in AXI SRAM); linker places them now */
#define AF_FILT_PER_CH 2

static uint8_t      DTCM s_enabled = 0;
static demod_mode_t DTCM s_mode = DEMOD_MODE_AM;
static uint32_t     DTCM s_carrier_hz = 465000U;
static uint32_t     DTCM s_nco_phase = 0;
static uint32_t     DTCM s_nco_inc = 0;

/* v71: 600kHz IF channel filter, applied in the TIM3 ISR *before* the
 * 12.5x decimation to 48kHz. */
static Biquad       DTCM s_if_i[IF_FILT_MAX_SECTIONS];
static Biquad       DTCM s_if_q[IF_FILT_MAX_SECTIONS];
static uint8_t      DTCM s_if_filter_count = 0;

/* v71: slow servo removing the residual ADC baseline offset before the DDC.
 * main.c already subtracts the nominal midscale, but the measured idle
 * baseline sits near 1706 rather than 2048, i.e. about -5472 counts after
 * the shift; an off-centre baseline clips one half of a strong signal
 * asymmetrically, which is exactly how even-order harmonics appear. */
static float        DTCM s_adc_dc = 0.0f;

static int32_t      DTCM s_envelope = 0;
static uint32_t     DTCM s_decim_acc = 0;

/* FM discriminator state (at 48kHz, after decimation) */
static float        DTCM s_fm_i_prev=0, s_fm_q_prev=0;

/* 48kHz audio shaping filters */
static Biquad       DTCM s_i_hpf[AF_FILT_PER_CH]; /* audio HPF 300Hz (FM/SSB/CW) */
static Biquad       DTCM s_af_lpf[AF_FILT_PER_CH];/* audio LPF       (AM 4k5 / FM 3k / SSB 3k) */
static uint8_t      DTCM s_hpf_filter_count = 0;
static uint8_t      DTCM s_af_filter_count = 0;

/* Second NCO for SSB/CW shift-back */
static uint32_t     DTCM s_nco2_phase = 0;
static uint32_t     DTCM s_nco2_inc = 0;
static int8_t       DTCM s_nco2_dir = 0;  /* +1: I*c-Q*s, -1: I*c+Q*s */

/* v71: Weaver sideband selector - real low-pass pair plus its own NCO. */
static Biquad       DTCM s_wv_i[WV_SECTIONS];
static Biquad       DTCM s_wv_q[WV_SECTIONS];
static uint8_t      DTCM s_wv_sections = 0;
static uint32_t     DTCM s_wv_phase = 0;
static uint32_t     DTCM s_wv_inc = 0;

/* DC removal (1st-order HPF ~2Hz) */
static float        DTCM s_dc = 0.0f;

/* AGC */
static float        DTCM s_agc_gain = 1.0f;
static float        DTCM s_env_peak = 0.0f;

/* v69: separate detector and gain loop time constants.  The old
 * instantaneous peak detector released in about 52ms and the gain
 * recovery ran in about 8ms, which tracked speech syllables and made
 * the audio pump at roughly 2Hz. */
#define AGC_ENV_ATTACK    0.0040f
#define AGC_ENV_RELEASE   0.00008f
#define AGC_GAIN_ATTACK   0.0060f
#define AGC_GAIN_RELEASE  0.00012f
#define AGC_TARGET         4000.0f
#define AGC_MAX_GAIN        512.0f
#define AGC_MIN_GAIN         0.10f

/* Additional user audio gain and 50Hz HPF */
static float        DTCM s_audio_gain = 0.1f;  /* v70: default -20dB */
static float        DTCM s_mode_gain = 1.0f;   /* per-mode output preset */
static float        DTCM s_mode_ramp = 1.0f;   /* anti-pop ramp on mode change */
static float        DTCM s_retune_ramp = 1.0f; /* anti-click ramp on retune */
static uint8_t      DTCM s_hpf50_en = 0;
static Biquad       DTCM s_hpf50;  /* 2nd-order Butterworth HPF 50Hz */

/* Lightweight time-domain noise reduction. */
static uint8_t      DTCM s_nr_en = 0;
static uint8_t      DTCM s_nr_level = 1;
static float        DTCM s_nr_env = 0.0f;
static float        DTCM s_nr_floor = 0.0f;
static float        DTCM s_nr_gain = 1.0f;
static float        DTCM s_nr_lpf = 0.0f;

/* 48kHz I/Q queue between ISR and main loop */
#define IQ_QUEUE_SIZE 1024
#define IQ_QUEUE_MASK (IQ_QUEUE_SIZE - 1)
typedef struct { int32_t i, q, env; } iq_sample_t;
static iq_sample_t  DTCM s_iq_queue[IQ_QUEUE_SIZE];
static volatile uint16_t s_iq_wp = 0;
static uint16_t     s_iq_rp = 0;

/* Audio output ring buffer */
static int16_t      s_audio_buf[DEMOD_AUDIO_BUF];
static volatile uint16_t s_audio_wp = 0;
static uint16_t     s_audio_rp = 0;

static inline int16_t lut_sin(uint32_t p) { return sin_lut[(p>>8)&SIN_LUT_MASK]; }
static inline int16_t lut_cos(uint32_t p) { return lut_sin(p+0x4000U); }

static inline int32_t fast_envelope(int32_t i, int32_t q)
{
    int32_t ai=i<0?-i:i, aq=q<0?-q:q;
    int32_t mx=ai>aq?ai:aq, mn=ai>aq?aq:ai;
    return mx+(mn>>1);
}

static uint32_t compute_nco_freq(uint32_t carrier, demod_mode_t mode)
{
    switch (mode) {
        case DEMOD_MODE_USB:
        case DEMOD_MODE_LSB: return carrier;
        case DEMOD_MODE_CW:  return carrier - CW_BEAT_HZ;
        default:             return carrier;
    }
}

static void copy_filters(Biquad *dst, const Biquad *src, int n)
{
    for (int k = 0; k < n; k++) {
        dst[k].b0=src[k].b0; dst[k].b1=src[k].b1; dst[k].b2=src[k].b2;
        dst[k].a1=src[k].a1; dst[k].a2=src[k].a2;
        biquad_reset(&dst[k]);
    }
}

static void init_hpf50(void)
{
    /* 2nd-order Butterworth HPF 50Hz @48kHz */
    s_hpf50.b0 = 0.995383f; s_hpf50.b1 = -1.990766f; s_hpf50.b2 = 0.995383f;
    s_hpf50.a1 = -1.990747f; s_hpf50.a2 = 0.990754f;
    biquad_reset(&s_hpf50);
}

static void setup_filters(demod_mode_t mode)
{
    s_hpf_filter_count = 0;
    s_af_filter_count = 0;
    s_mode_gain = (mode == DEMOD_MODE_FM) ? 0.35f
                : (mode == DEMOD_MODE_CW) ? 0.80f : 1.00f;

    const Biquad *if_src = if_lpf_am;
    uint8_t if_n = 2U;

    switch (mode) {
        case DEMOD_MODE_AM:
            if_src = if_lpf_am; if_n = 2U;
            copy_filters(s_af_lpf, lpf4k5_af, AF_FILT_PER_CH);
            s_af_filter_count = AF_FILT_PER_CH;
            break;
        case DEMOD_MODE_FM:
            if_src = if_lpf_fm; if_n = IF_FILT_FM_SECTIONS;
            /* audio: 300Hz-3kHz voice band, 4th-order both ends. */
            copy_filters(s_i_hpf, hpf300_af, AF_FILT_PER_CH);
            copy_filters(s_af_lpf, lpf3k_af, AF_FILT_PER_CH);
            s_hpf_filter_count = AF_FILT_PER_CH;
            s_af_filter_count = AF_FILT_PER_CH;
            break;
        case DEMOD_MODE_USB:
        case DEMOD_MODE_LSB:
            if_src = if_lpf_ssb; if_n = 2U;
            copy_filters(s_wv_i, wv_lpf, WV_SECTIONS);
            copy_filters(s_wv_q, wv_lpf, WV_SECTIONS);
            s_wv_sections = WV_SECTIONS;
            s_wv_phase = 0;
            copy_filters(s_i_hpf, hpf300_af, AF_FILT_PER_CH);
            copy_filters(s_af_lpf, lpf3k_af, AF_FILT_PER_CH);
            s_hpf_filter_count = AF_FILT_PER_CH;
            s_af_filter_count = AF_FILT_PER_CH;
            break;
        case DEMOD_MODE_CW:
            if_src = if_lpf_cw; if_n = 2U;
            copy_filters(s_i_hpf, hpf300_af, AF_FILT_PER_CH);
            s_hpf_filter_count = AF_FILT_PER_CH;
            break;
    }

    /* The IF filter section state is read by the TIM3 ISR every sample, so
     * swap the coefficients with interrupts masked: a torn float pair would
     * momentarily destabilise the biquad. */
    __disable_irq();
    copy_filters(s_if_i, if_src, if_n);
    copy_filters(s_if_q, if_src, if_n);
    s_if_filter_count = if_n;
    __enable_irq();
}

/* ------------------------ Public API ------------------------ */

void am_demod_init(void)
{
    s_enabled=0; s_mode=DEMOD_MODE_AM; s_nco_phase=0;
    s_carrier_hz=0U;          /* force the first am_demod_set_freq() to compute NCO */
    s_adc_dc=0.0f;
    s_envelope=0; s_decim_acc=0;
    s_fm_i_prev=s_fm_q_prev=0;
    s_nco2_phase=0; s_nco2_inc=0; s_nco2_dir=0;
    s_dc=0.0f; s_agc_gain=1.0f; s_env_peak=0.0f;
    s_mode_gain=1.0f; s_mode_ramp=0.0f; s_retune_ramp=1.0f;
    s_nr_en=0; s_nr_level=1; s_nr_env=0.0f; s_nr_floor=1.0f; s_nr_gain=1.0f; s_nr_lpf=0.0f;
    s_audio_wp=s_audio_rp=0; s_iq_wp=s_iq_rp=0;
    memset(s_audio_buf,0,sizeof(s_audio_buf));
    setup_filters(s_mode);
    init_hpf50();
    am_demod_set_freq(465000U);
    s_retune_ramp = 1.0f;
}

static void recompute_nco(void)
{
    uint32_t actual = compute_nco_freq(s_carrier_hz, s_mode);
    s_nco_inc = (uint32_t)(((uint64_t)actual << 16) / DEMOD_INPUT_FS);

    /* Weaver local oscillator: fixed 1650Hz on the *output* rate. */
    s_wv_inc = (uint32_t)(((uint64_t)WV_SHIFT_HZ << 16) / DEMOD_OUTPUT_FS);

    if (s_mode == DEMOD_MODE_CW) {
        s_nco2_inc = (uint32_t)(((uint64_t)CW_SHIFT_HZ << 16) / DEMOD_OUTPUT_FS);
        s_nco2_dir = +1;
    } else {
        s_nco2_inc = 0; s_nco2_dir = 0;
    }
}

void am_demod_set_freq(uint32_t hz)
{
    if (hz == s_carrier_hz) return;
    s_carrier_hz = hz;
    recompute_nco();
    /* A retune steps the NCO phase instantly; ramp the output back up over
     * ~7ms so scrolling the tuning knob does not click. */
    s_retune_ramp = 0.0f;
}

uint32_t am_demod_get_freq(void) { return s_carrier_hz; }

void am_demod_set_mode(demod_mode_t mode)
{
    if (mode > DEMOD_MODE_CW) mode = DEMOD_MODE_AM;
    if (mode == s_mode) return;
    s_mode = mode;
    setup_filters(mode);
    recompute_nco();
    s_dc=0.0f; s_nco2_phase=0;
    s_fm_i_prev=s_fm_q_prev=0;
    s_agc_gain=1.0f; s_env_peak=0.0f;
    s_nr_env=0.0f; s_nr_floor=1.0f; s_nr_gain=1.0f; s_nr_lpf=0.0f;
    s_mode_ramp=0.0f;
}

demod_mode_t am_demod_get_mode(void) { return s_mode; }

void am_demod_enable(uint8_t en)
{
    s_enabled = en;
    if (en) {
        s_nco_phase=0; s_decim_acc=0;
        s_adc_dc=0.0f;
        s_dc=0.0f; s_env_peak=0.0f; s_agc_gain=1.0f; s_nco2_phase=0;
        s_fm_i_prev=s_fm_q_prev=0;
        s_nr_env=0.0f; s_nr_floor=1.0f; s_nr_gain=1.0f; s_nr_lpf=0.0f;
        s_mode_ramp=0.0f; s_retune_ramp=0.0f;
        s_iq_wp=s_iq_rp=0;
        setup_filters(s_mode);
    }
}

uint8_t am_demod_is_enabled(void) { return s_enabled; }

void am_demod_input(int16_t sample)
{
    if (!s_enabled) return;

    /* v71: slow DC servo.  The measured idle baseline is ~1706 rather than
     * 2048, so a strong signal that swings symmetrically about the real
     * baseline is clipped on one side only -- the classic source of even
     * order harmonics.  Time constant ~1.5Hz at 600kHz. */
    float xin = (float)sample - s_adc_dc;
    s_adc_dc += xin * (1.0f / 65536.0f);

    /* DDC */
    int16_t c = lut_cos(s_nco_phase);
    int16_t s = lut_sin(s_nco_phase);
    s_nco_phase += s_nco_inc;
    int32_t xi = (int32_t)xin;
    int32_t i = (xi * (int32_t)c) >> 15;
    int32_t q = (xi * (int32_t)s) >> 15;

    /* v71: IF channel filter runs here, at 600kHz, *before* the decimation.
     * This is the RF/IF selectivity that stops out-of-band signals folding
     * onto the tuned frequency. */
    float fi = (float)i, fq = (float)q;
    uint8_t n = s_if_filter_count;
    for (uint8_t k = 0; k < n; k++) {
        fi = biquad_process(&s_if_i[k], fi);
        fq = biquad_process(&s_if_q[k], fq);
    }

    /* v23.2: skip envelope in FM mode - not used by the FM poll path,
       saves ~10 cycles in the hot ISR. */
    if (s_mode != DEMOD_MODE_FM)
        s_envelope = fast_envelope((int32_t)fi, (int32_t)fq);

    /* Fractional 600kHz -> 48kHz decimation (alternating 12/13 samples),
     * queue for main loop. */
    s_decim_acc += DEMOD_OUTPUT_FS;
    if (s_decim_acc < DEMOD_INPUT_FS) return;
    s_decim_acc -= DEMOD_INPUT_FS;

    uint16_t wp = (s_iq_wp + 1) & IQ_QUEUE_MASK;
    if (wp != s_iq_rp) {
        s_iq_queue[s_iq_wp].i = (int32_t)fi;
        s_iq_queue[s_iq_wp].q = (int32_t)fq;
        s_iq_queue[s_iq_wp].env = s_envelope;
        s_iq_wp = wp;
    }
}

uint8_t am_demod_poll(void)
{
    if (s_iq_rp == s_iq_wp) return 0;
    iq_sample_t smp = s_iq_queue[s_iq_rp];
    s_iq_rp = (s_iq_rp + 1) & IQ_QUEUE_MASK;

    float raw_audio;

    switch (s_mode) {
        case DEMOD_MODE_AM: {
            /* v71: IF +-4.5kHz selectivity is already applied at 600kHz in
             * the ISR; only the audio shaper runs here. */
            float xi = (float)smp.i, xq = (float)smp.q;
            float env = sqrtf(xi*xi + xq*xq);
            /* audio shaping 4.5kHz LPF */
            for (int k=0;k<s_af_filter_count;k++) env = biquad_process(&s_af_lpf[k], env);
            raw_audio = env;
            break;
        }
        case DEMOD_MODE_FM: {
            /* Discriminate after 25x decimation. NFM deviation is far below
             * the 24kHz Nyquist limit, and this removes a 1.2MHz divide from
             * the TIM2 ISR. Scale 2000 preserves the old 50000@1.2MHz slope. */
            float xi = (float)smp.i, xq = (float)smp.q;
            float mag2 = xi*xi + xq*xq;
            float disc = 0.0f;
            if (mag2 > 64.0f) {
                disc = (s_fm_i_prev * xq - s_fm_q_prev * xi) / mag2;
                s_fm_i_prev = xi;
                s_fm_q_prev = xq;
            } else {
                s_fm_i_prev = 0.0f;
                s_fm_q_prev = 0.0f;
            }
            float x = disc * 2000.0f;
            /* audio shaping 3kHz LPF + 300Hz HPF */
            for (int k=0;k<s_af_filter_count;k++) x = biquad_process(&s_af_lpf[k], x);
            for (int k=0;k<s_hpf_filter_count;k++) x = biquad_process(&s_i_hpf[k], x);
            raw_audio = x;
            break;
        }
        case DEMOD_MODE_USB:
        case DEMOD_MODE_LSB: {
            /* v71: IF +-3.2kHz selectivity already applied at the DDC rate.
             * Weaver detector: shift down, real low-pass on I and Q, shift
             * back, take the real part.  The wanted sideband sits inside
             * +-1350Hz after the shift and the unwanted one outside
             * +-1950Hz, which the elliptic low-pass separates by ~70dB. */
            /* The DDC computes q = x*sin(wt), i.e. z = i + jq = x*e^{+jwt},
             * while the textbook convention (and the Weaver derivation
             * above) assumes z = x*e^{-jwt}.  Conjugating here (q -> -q)
             * puts the maths back in the standard sense; without it USB and
             * LSB come out swapped.  CW below is left alone: it was verified
             * against the hardware with the existing convention. */
            float xi = (float)smp.i, xq = -(float)smp.q;
            /* The shift direction selects the sideband: shifting the
             * baseband DOWN puts the upper sideband inside +-1350Hz and the
             * lower one outside +-1950Hz; shifting UP does the reverse. */
            float sw = (float)lut_sin(s_wv_phase) / 32768.0f;
            float cw = (float)lut_cos(s_wv_phase) / 32768.0f;
            if (s_mode != DEMOD_MODE_USB) sw = -sw;
            s_wv_phase += s_wv_inc;
            float si = xi*cw + xq*sw;   /* z * exp(-j*2pi*1650*t) */
            float sq = xq*cw - xi*sw;
            for (uint8_t k = 0; k < s_wv_sections; k++) {
                si = biquad_process(&s_wv_i[k], si);
                sq = biquad_process(&s_wv_q[k], sq);
            }
            float mixed = si*cw - sq*sw; /* Re{ (si+j*sq) * exp(+j...) } */
            for (int k=0;k<s_hpf_filter_count;k++) mixed = biquad_process(&s_i_hpf[k], mixed);
            for (int k=0;k<s_af_filter_count;k++) mixed = biquad_process(&s_af_lpf[k], mixed);
            raw_audio = mixed;
            break;
        }
        case DEMOD_MODE_CW: {
            /* v71: IF +-0.8kHz selectivity already applied at 600kHz. */
            float xi = (float)smp.i, xq = (float)smp.q;
            float c2 = (float)lut_cos(s_nco2_phase) / 32768.0f;
            float s2 = (float)lut_sin(s_nco2_phase) / 32768.0f;
            s_nco2_phase += s_nco2_inc;
            float mixed = xi*c2 - xq*s2;  /* exp(+j*1.2k), carrier -> 600Hz */
            for (int k=0;k<s_hpf_filter_count;k++) mixed = biquad_process(&s_i_hpf[k], mixed);
            raw_audio = mixed;
            break;
        }
        default:
            raw_audio = (float)smp.env;
            break;
    }

    /* DC removal (1st-order HPF, ~2Hz) */
    s_dc += (raw_audio - s_dc) * 0.0005f;
    float audio_ac = raw_audio - s_dc;

    /* AGC: smooth the rectified audio first, then move gain with a fast
     * attack and slow release.  The detector release is intentionally
     * slower than speech syllables so the gain no longer follows the
     * audio envelope. */
    float level = audio_ac < 0 ? -audio_ac : audio_ac;
    s_env_peak += (level - s_env_peak) *
                  ((level > s_env_peak) ? AGC_ENV_ATTACK : AGC_ENV_RELEASE);

    float desired = (s_env_peak > 2.0f) ? (AGC_TARGET / s_env_peak) : AGC_MAX_GAIN;
    if (desired > AGC_MAX_GAIN) desired = AGC_MAX_GAIN;
    if (desired < AGC_MIN_GAIN) desired = AGC_MIN_GAIN;

    if (desired < s_agc_gain * 0.95f)
        s_agc_gain += (desired - s_agc_gain) * AGC_GAIN_ATTACK;
    else if (desired > s_agc_gain * 1.08f)
        s_agc_gain += (desired - s_agc_gain) * AGC_GAIN_RELEASE;

    float out = audio_ac * s_agc_gain * s_mode_gain;

    /* User audio gain (post-AGC volume, 0.1x-10x = -20..+20dB) */
    out *= s_audio_gain;

    /* v70: slow noise-floor tracking + soft downward expander.
     * The old fast 0.01/0.002 gain slew followed speech syllables and
     * caused audible level pumping, especially at NR levels 2 and 3. */
    if (s_nr_en) {
        float mag = out < 0.0f ? -out : out;
        s_nr_env += (mag - s_nr_env) * (mag > s_nr_env ? 0.020f : 0.0005f);

        float floor_alpha = (mag < s_nr_floor * 1.5f) ? 0.00004f : 0.000001f;
        s_nr_floor += (mag - s_nr_floor) * floor_alpha;
        if (s_nr_floor < 1.0f) s_nr_floor = 1.0f;

        float mult = (s_nr_level == 1) ? 2.0f
                   : (s_nr_level == 2) ? 3.0f : 4.5f;
        float min_gain = (s_nr_level == 1) ? 0.65f
                       : (s_nr_level == 2) ? 0.50f : 0.35f;
        float snr = s_nr_env / (s_nr_floor * mult);
        float target = (snr >= 1.0f) ? 1.0f
                     : (min_gain + (1.0f - min_gain) * snr);
        s_nr_gain += (target - s_nr_gain) *
                     ((target > s_nr_gain) ? 0.0015f : 0.00035f);
        out *= s_nr_gain;
        float alpha = (s_nr_level == 1) ? 0.18f
                    : (s_nr_level == 2) ? 0.22f : 0.28f;
        s_nr_lpf += (out - s_nr_lpf) * alpha;
        out = s_nr_lpf;
    }

    /* 50Hz HPF */
    if (s_hpf50_en) out = biquad_process(&s_hpf50, out);

    /* v70: short anti-pop ramp after DEMOD/MODE changes. */
    if (s_mode_ramp < 1.0f) {
        s_mode_ramp += (1.0f / 480.0f);
        if (s_mode_ramp > 1.0f) s_mode_ramp = 1.0f;
    }
    out *= s_mode_ramp;

    /* v71: brief mute/unmute around a retune so stepping the NCO phase does
     * not click.  7ms is short enough to feel instant. */
    if (s_retune_ramp < 1.0f) {
        s_retune_ramp += (1.0f / 336.0f);
        if (s_retune_ramp > 1.0f) s_retune_ramp = 1.0f;
    }
    out *= s_retune_ramp;

    if (out > 32000.0f) out = 32000.0f;
    if (out < -32000.0f) out = -32000.0f;

    s_audio_buf[s_audio_wp] = (int16_t)out;
    s_audio_wp = (s_audio_wp + 1) & DEMOD_AUDIO_MASK;
    return 1;
}

uint8_t am_demod_read(int16_t *out)
{
    if (s_audio_rp == s_audio_wp) return 0;
    *out = s_audio_buf[s_audio_rp];
    s_audio_rp = (s_audio_rp + 1) & DEMOD_AUDIO_MASK;
    return 1;
}

int32_t am_demod_get_agc_gain(void) { return (int32_t)(s_agc_gain * 256.0f); }

void am_demod_set_audio_gain(float gain)
{
    if (gain < 0.01f) gain = 0.01f;
    /* v23.3: max 20x (+26dB) so the host slider can drive the output
       ~2x louder than before (output clamps at +-32000). */
    if (gain > 20.0f) gain = 20.0f;
    s_audio_gain = gain;
}

void am_demod_set_hpf50(uint8_t en)
{
    s_hpf50_en = en ? 1 : 0;
    if (en) biquad_reset(&s_hpf50);
}

void am_demod_set_nr(uint8_t en, uint8_t level)
{
    if (level < 1U) level = 1U;
    if (level > 3U) level = 3U;
    s_nr_en = en ? 1U : 0U;
    s_nr_level = level;
    s_nr_env = 0.0f;
    s_nr_floor = 1.0f;
    s_nr_gain = 1.0f;
    s_nr_lpf = 0.0f;
}

int32_t am_demod_get_envelope(void) { return s_envelope; }
