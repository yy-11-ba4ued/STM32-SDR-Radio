/* USER CODE BEGIN Header */
/**
  ******************************************************************************
  * @file    pcm5102.c
  * @brief   PCM5102APWR I2S DAC 驱动 (STM32H750 + SAI1_A + DMA2_Stream6)
  *
  *  功能:
  *    - 初始化 XSMT(PE3)/DMA2/NVIC, 开机自动播放 1kHz 测试音(50% 音量)
  *    - DMA 半传输/完成回调边播边重填(无缝双缓冲), 任意频率缓冲回绕无爆音
  *    - 5 种测试波形: 正弦/方波/三角波/锯齿波/扫频(200-2000Hz)
  *    - USART2(115200 8N1) 命令控制, 供 Python 上位机使用
  *
  *  串口协议 (以 \r 或 \n 结尾, 大小写均可):
  *    H / ?        帮助
  *    I            状态信息
  *    F<freq>      设置频率 Hz (20..20000), 例: F1000
  *    V<vol>       设置音量 0..100 (%), 例: V50
  *    W<wave>      设置波形 0正弦 1方波 2三角 3锯齿 4扫频
  *    P            播放(解除静音并启动 SAI/DMA)
  *    S            停止(静音并停止 SAI/DMA)
  *
  *  音频缓冲位于 AXI SRAM (0x24010000, Screen.sct RW_AUDIO 区域), DMA2 可访问;
  *  DTCM(0x20000000) 为 CPU 私有, DMA 无法访问, 勿将缓冲放那里。
  ******************************************************************************
  */
/* USER CODE END Header */
/* Includes ------------------------------------------------------------------*/
#include "pcm5102.h"
#include "am_demod.h"
#include <string.h>

/* USER CODE BEGIN Includes */

/* USER CODE END Includes */

/* Private typedef -----------------------------------------------------------*/
/* USER CODE BEGIN PTD */

/* USER CODE END PTD */

/* Private define ------------------------------------------------------------*/
/* USER CODE BEGIN PD */

#define SAI_AUDIO       hsai_BlockA1         /* SAI1 Block A 句柄 */

/* 正弦查找表规模: 512 点覆盖一个完整周期 (索引 = 相位高 9 位) */
#define SIN_LUT_SIZE    512U

/* 相位累加器 Q16.16: 每采样增量 = freq/fs * 2^16 */
#define PHASE_INC(f)    ((uint32_t)(((uint64_t)(f) << 16) / PCM5102_FS))

/* 串口接收环形缓冲 */

/* USER CODE END PD */

/* Private macro -------------------------------------------------------------*/
/* USER CODE BEGIN PM */

/* USER CODE END PM */

/* Private variables ---------------------------------------------------------*/
/* USER CODE BEGIN PV */

/* ============ 音频缓冲: 必须位于 DMA 可访问的 AXI SRAM ============
 * 段 .audio_buf 由散列文件 Screen.sct 的 RW_AUDIO 区域(0x24010000, UNINIT)指定,
 * 保证 DMA2 可访问且与 CPU 堆栈/普通变量互不干扰。 */
__attribute__((section(".audio_buf"), aligned(32)))
uint16_t s_audio_buf[PCM5102_BUF_SAMPLES];

/* SAI1_A TX DMA 句柄 (DMA2_Stream6, 官方 SAI_AudioPlay 示例同款配置) */
DMA_HandleTypeDef hdma_sai1_a;

/* 波形合成状态 */
static const int16_t s_sin_lut[SIN_LUT_SIZE] = {
      0,   402,   804,  1206,  1608,  2009,  2410,  2811,
   3212,  3612,  4011,  4410,  4808,  5205,  5602,  5998,
   6393,  6786,  7179,  7571,  7962,  8351,  8739,  9126,
   9512,  9896, 10278, 10659, 11039, 11417, 11793, 12167,
  12539, 12910, 13279, 13645, 14010, 14372, 14732, 15090,
  15446, 15800, 16151, 16499, 16846, 17189, 17530, 17869,
  18204, 18537, 18868, 19195, 19519, 19841, 20159, 20475,
  20787, 21096, 21403, 21705, 22005, 22301, 22594, 22884,
  23170, 23452, 23731, 24007, 24279, 24547, 24811, 25072,
  25329, 25582, 25832, 26077, 26319, 26556, 26790, 27019,
  27245, 27466, 27683, 27896, 28105, 28310, 28510, 28706,
  28898, 29085, 29268, 29447, 29621, 29791, 29956, 30117,
  30273, 30424, 30571, 30714, 30852, 30985, 31113, 31237,
  31356, 31470, 31580, 31685, 31785, 31880, 31971, 32057,
  32137, 32213, 32285, 32351, 32412, 32469, 32521, 32567,
  32609, 32646, 32678, 32705, 32728, 32745, 32757, 32765,
  32767, 32765, 32757, 32745, 32728, 32705, 32678, 32646,
  32609, 32567, 32521, 32469, 32412, 32351, 32285, 32213,
  32137, 32057, 31971, 31880, 31785, 31685, 31580, 31470,
  31356, 31237, 31113, 30985, 30852, 30714, 30571, 30424,
  30273, 30117, 29956, 29791, 29621, 29447, 29268, 29085,
  28898, 28706, 28510, 28310, 28105, 27896, 27683, 27466,
  27245, 27019, 26790, 26556, 26319, 26077, 25832, 25582,
  25329, 25072, 24811, 24547, 24279, 24007, 23731, 23452,
  23170, 22884, 22594, 22301, 22005, 21705, 21403, 21096,
  20787, 20475, 20159, 19841, 19519, 19195, 18868, 18537,
  18204, 17869, 17530, 17189, 16846, 16499, 16151, 15800,
  15446, 15090, 14732, 14372, 14010, 13645, 13279, 12910,
  12539, 12167, 11793, 11417, 11039, 10659, 10278,  9896,
   9512,  9126,  8739,  8351,  7962,  7571,  7179,  6786,
   6393,  5998,  5602,  5205,  4808,  4410,  4011,  3612,
   3212,  2811,  2410,  2009,  1608,  1206,   804,   402,
      0,  -402,  -804, -1206, -1608, -2009, -2410, -2811,
  -3212, -3612, -4011, -4410, -4808, -5205, -5602, -5998,
  -6393, -6786, -7179, -7571, -7962, -8351, -8739, -9126,
  -9512, -9896, -10278, -10659, -11039, -11417, -11793, -12167,
 -12539, -12910, -13279, -13645, -14010, -14372, -14732, -15090,
 -15446, -15800, -16151, -16499, -16846, -17189, -17530, -17869,
 -18204, -18537, -18868, -19195, -19519, -19841, -20159, -20475,
 -20787, -21096, -21403, -21705, -22005, -22301, -22594, -22884,
 -23170, -23452, -23731, -24007, -24279, -24547, -24811, -25072,
 -25329, -25582, -25832, -26077, -26319, -26556, -26790, -27019,
 -27245, -27466, -27683, -27896, -28105, -28310, -28510, -28706,
 -28898, -29085, -29268, -29447, -29621, -29791, -29956, -30117,
 -30273, -30424, -30571, -30714, -30852, -30985, -31113, -31237,
 -31356, -31470, -31580, -31685, -31785, -31880, -31971, -32057,
 -32137, -32213, -32285, -32351, -32412, -32469, -32521, -32567,
 -32609, -32646, -32678, -32705, -32728, -32745, -32757, -32765,
 -32767, -32765, -32757, -32745, -32728, -32705, -32678, -32646,
 -32609, -32567, -32521, -32469, -32412, -32351, -32285, -32213,
 -32137, -32057, -31971, -31880, -31785, -31685, -31580, -31470,
 -31356, -31237, -31113, -30985, -30852, -30714, -30571, -30424,
 -30273, -30117, -29956, -29791, -29621, -29447, -29268, -29085,
 -28898, -28706, -28510, -28310, -28105, -27896, -27683, -27466,
 -27245, -27019, -26790, -26556, -26319, -26077, -25832, -25582,
 -25329, -25072, -24811, -24547, -24279, -24007, -23731, -23452,
 -23170, -22884, -22594, -22301, -22005, -21705, -21403, -21096,
 -20787, -20475, -20159, -19841, -19519, -19195, -18868, -18537,
 -18204, -17869, -17530, -17189, -16846, -16499, -16151, -15800,
 -15446, -15090, -14732, -14372, -14010, -13645, -13279, -12910,
 -12539, -12167, -11793, -11417, -11039, -10659, -10278,  -9896,
  -9512,  -9126,  -8739,  -8351,  -7962,  -7571,  -7179,  -6786,
  -6393,  -5998,  -5602,  -5205,  -4808,  -4410,  -4011,  -3612,
  -3212,  -2811,  -2410,  -2009,  -1608,  -1206,   -804,   -402,
};

/* 合成参数 (主循环/命令修改, DMA 循环播放读取的是缓冲, 无竞争) */
static uint32_t s_phase = 0;             /* 相位累加器 Q16.16 */
static uint32_t s_freq_hz = 1000;        /* 当前频率 */
static uint8_t  s_vol_pct = 50;          /* 音量 0..100 */
static PCM5102_Wave_t s_wave = PCM5102_WAVE_SINE;
static volatile uint8_t s_playing = 0;
static volatile uint8_t s_demod_mode = 0;  /* 1=output demodulated audio, 0=test tone */   /* DMA 播放中 */
static volatile uint8_t s_fill_half0 = 0;  /* 主循环需重填前半缓冲 */
static volatile uint8_t s_fill_half1 = 0;  /* 主循环需重填后半缓冲 */
static uint32_t s_sweep_f = 200;         /* 扫频当前频率 */

/* USER CODE END PV */

/* Private function prototypes -----------------------------------------------*/
/* USER CODE BEGIN PFP */
static void     pcm_xsmt_init(void);
static void     pcm_dma_init(void);
static int16_t  pcm_gen_sample(uint32_t ph, int32_t amp);
static void     pcm_audio_gen_half(uint16_t half);
static void     pcm_audio_gen(void);
static void     pcm_play_start(void);
static void     pcm_apply(void);

/* USER CODE END PFP */

/* Private user code ---------------------------------------------------------*/
/* USER CODE BEGIN 0 */

/* ======================= 底层初始化 ======================= */

/* XSMT(PE3) 输出, 初始为低=静音 */
static void pcm_xsmt_init(void)
{
  GPIO_InitTypeDef g = {0};

  __HAL_RCC_GPIOE_CLK_ENABLE();
  g.Pin   = PCM5102_XSMT_PIN;
  g.Mode  = GPIO_MODE_OUTPUT_PP;
  g.Pull  = GPIO_NOPULL;
  g.Speed = GPIO_SPEED_FREQ_LOW;
  HAL_GPIO_Init(PCM5102_XSMT_PORT, &g);
  HAL_GPIO_WritePin(PCM5102_XSMT_PORT, PCM5102_XSMT_PIN, GPIO_PIN_RESET); /* 静音 */
}

/* DMA2_Stream6 <-> SAI1_A TX (16bit 数据, 循环模式) */
static void pcm_dma_init(void)
{
  __HAL_RCC_DMA2_CLK_ENABLE();

  hdma_sai1_a.Instance                 = DMA2_Stream6;
  hdma_sai1_a.Init.Request             = DMA_REQUEST_SAI1_A;
  hdma_sai1_a.Init.Direction           = DMA_MEMORY_TO_PERIPH;
  hdma_sai1_a.Init.PeriphInc           = DMA_PINC_DISABLE;
  hdma_sai1_a.Init.MemInc              = DMA_MINC_ENABLE;
  hdma_sai1_a.Init.PeriphDataAlignment = DMA_PDATAALIGN_HALFWORD;
  hdma_sai1_a.Init.MemDataAlignment    = DMA_MDATAALIGN_HALFWORD;
  hdma_sai1_a.Init.Mode                = DMA_CIRCULAR;
  hdma_sai1_a.Init.Priority            = DMA_PRIORITY_HIGH;
  hdma_sai1_a.Init.FIFOMode            = DMA_FIFOMODE_ENABLE;
  hdma_sai1_a.Init.FIFOThreshold       = DMA_FIFO_THRESHOLD_FULL;
  hdma_sai1_a.Init.MemBurst            = DMA_MBURST_SINGLE;
  hdma_sai1_a.Init.PeriphBurst         = DMA_PBURST_SINGLE;

  HAL_DMA_Init(&hdma_sai1_a);
  __HAL_LINKDMA(&SAI_AUDIO, hdmatx, hdma_sai1_a);

  HAL_NVIC_SetPriority(SAI1_IRQn,        5, 0);
  HAL_NVIC_SetPriority(DMA2_Stream6_IRQn, 5, 0);
  HAL_NVIC_EnableIRQ(SAI1_IRQn);
  HAL_NVIC_EnableIRQ(DMA2_Stream6_IRQn);
  /* NOTE: USART2 is polled in TIM2 ISR by modulator, do NOT enable USART2 IRQ */
}

/* ======================= 波形合成 ======================= */

/* 生成一个样本: ph 为 Q16.16 相位, amp 为幅度(0..32767) */
static int16_t pcm_gen_sample(uint32_t ph, int32_t amp)
{
  int32_t x;

  switch (s_wave)
  {
    case PCM5102_WAVE_SINE:
      return (int16_t)(((int32_t)s_sin_lut[(ph >> 7) & (SIN_LUT_SIZE - 1)] * amp) >> 15);

    case PCM5102_WAVE_SQUARE:
      return (int16_t)(((ph & 0x8000UL) == 0UL) ? amp : -amp);

    case PCM5102_WAVE_TRIANGLE:
      x = (int32_t)(ph & 0xFFFFUL);
      if (x >= 0x8000) x = 0xFFFF - x;            /* 0..32767 三角 */
      return (int16_t)((x * amp) >> 15);

    case PCM5102_WAVE_SAW:
      x = (int32_t)(ph & 0xFFFFUL) - 32768;       /* -32768..32767 */
      return (int16_t)((x * amp) >> 15);

    case PCM5102_WAVE_SWEEP:
    default:
      return (int16_t)(((int32_t)s_sin_lut[(ph >> 7) & (SIN_LUT_SIZE - 1)] * amp) >> 15);
  }
}

/* 重新合成半个环形缓冲 (half=0/1, 相位连续)。
 * 由 DMA 半传输/传输完成回调持续调用, 实现"边播边填"双缓冲:
 * 任意频率下缓冲回绕处波形均无缝, 无周期咔哒声。 */
static void pcm_audio_gen_half(uint16_t half)
{
  uint32_t i, ph = s_phase, inc;
  uint32_t n = PCM5102_FRAME_SAMPLES / 2U;
  int32_t  amp = ((int32_t)s_vol_pct * 32767) / 100;
  uint16_t *p = &s_audio_buf[(uint32_t)half * n * 2U];

  if (s_wave == PCM5102_WAVE_SWEEP)
  {
    s_freq_hz = s_sweep_f;
    s_sweep_f = (s_sweep_f >= 1975U) ? 200U : s_sweep_f + 25U;
  }
  inc = PHASE_INC(s_freq_hz);

  if (s_demod_mode)
  {
    for (i = 0; i < n; i++)
    {
      int16_t s;
      if (!am_demod_read(&s)) s = 0;
      p[i * 2U]     = (uint16_t)s;
      p[i * 2U + 1U] = (uint16_t)s;
    }
  }
  else
  {
    /* Test tone disabled - output silence when not in demod mode */
    memset(p, 0, n * 2U * sizeof(uint16_t));
  }
  /* D-Cache写回内存: TIM2高频中断会替换Cache行, DMA必须读到新数据 */
  SCB_CleanDCache_by_Addr((uint32_t *)p, (int32_t)(n * 2U * sizeof(uint16_t)));
}

/* 重新合成整个环形缓冲 (初始化/参数变更时使用) */
static void pcm_audio_gen(void)
{
  pcm_audio_gen_half(0);
  pcm_audio_gen_half(1);
}

/* ======================= 播放控制 ======================= */

static void pcm_play_start(void)
{
  if (s_playing) return;

  /* Size = 16bit 半字数量(与 DMA 半字宽度一致), 循环 DMA 自动回绕 */
  if (HAL_SAI_Transmit_DMA(&SAI_AUDIO, (uint8_t *)s_audio_buf, PCM5102_BUF_SAMPLES) == HAL_OK)
  {
    s_playing = 1;
  }
}

static void pcm_apply(void)
{
  uint8_t was = s_playing;
  if (was)
  {
    HAL_SAI_DMAStop(&SAI_AUDIO);   /* 停止后状态回 READY, 可安全重启 */
    s_playing = 0;
  }
  pcm_audio_gen();
  if (was) pcm_play_start();
}

/* ======================= 串口协议 ======================= */

/* 从环形缓冲取完整一行并处理 */
/* USER CODE END 0 */

/* ======================= 对外接口 ======================= */

/**
  * @brief  初始化 PCM5102: XSMT GPIO、DMA2、NVIC、波形缓冲, 并开始播放 1kHz 测试音
  * @note   需在 MX_SAI1_Init() 之后调用
  */
void PCM5102_Init(void)
{
  pcm_xsmt_init();        /* XSMT 低 = 静音 */
  pcm_dma_init();         /* DMA2_Stream6 + NVIC */
  pcm_audio_gen();        /* 生成 1kHz 正弦缓冲 (准备好, 但不播放) */
  /* 注意: 不启动 SAI/DMA, 不解除静音 — 由上位机 P 命令控制 */
}

/**
  * @brief  周期任务: 解析 USART2 命令 (在主循环调用, 非阻塞)
  */
void PCM5102_Task(void)
{
  /* 在主循环调用: 重填DMA已播完的半缓冲, 并做D-Cache写回.
     不在DMA中断里做填充/Cache清理, 避免占用AXI总线影响TIM2的SSB调制. */
  if (s_fill_half0) { s_fill_half0 = 0; pcm_audio_gen_half(0); }
  if (s_fill_half1) { s_fill_half1 = 0; pcm_audio_gen_half(1); }
}

int PCM5102_SetFrequency(uint32_t hz)
{
  if (hz < 20) hz = 20;
  if (hz > 20000) hz = 20000;
  if (s_wave == PCM5102_WAVE_SWEEP) s_wave = PCM5102_WAVE_SINE;
  s_freq_hz = hz;
  pcm_apply();
  return 0;
}

int PCM5102_SetVolume(uint8_t pct)
{
  if (pct > 100) pct = 100;
  s_vol_pct = pct;
  pcm_apply();
  return 0;
}

int PCM5102_SetWave(PCM5102_Wave_t w)
{
  if ((uint32_t)w > (uint32_t)PCM5102_WAVE_SWEEP) return -1;
  s_wave = w;
  pcm_apply();
  return 0;
}

void PCM5102_Mute(void)
{
  HAL_GPIO_WritePin(PCM5102_XSMT_PORT, PCM5102_XSMT_PIN, GPIO_PIN_RESET);
}

void PCM5102_Unmute(void)
{
  HAL_GPIO_WritePin(PCM5102_XSMT_PORT, PCM5102_XSMT_PIN, GPIO_PIN_SET);
}

void PCM5102_SetDemodMode(uint8_t en)
{
  s_demod_mode = en ? 1 : 0;
  if (en) {
    am_demod_enable(1);
  } else {
    am_demod_enable(0);
    memset(s_audio_buf, 0, sizeof(s_audio_buf));
    SCB_CleanDCache_by_Addr((uint32_t *)s_audio_buf, (int32_t)sizeof(s_audio_buf));
  }
}

uint8_t PCM5102_GetDemodMode(void)
{
  return s_demod_mode;
}

void PCM5102_Play(void)
{
  pcm_play_start();
  PCM5102_Unmute();
}

void PCM5102_Stop(void)
{
  PCM5102_Mute();
  if (s_playing) { HAL_SAI_DMAStop(&SAI_AUDIO); s_playing = 0; }
}

uint32_t PCM5102_GetFreq(void)      { return s_freq_hz; }
uint8_t  PCM5102_GetVolume(void)    { return s_vol_pct; }
PCM5102_Wave_t PCM5102_GetWave(void){ return s_wave; }
uint8_t  PCM5102_IsPlaying(void)    { return s_playing; }

/**
  * @brief  SAI TX DMA 半传输完成回调 (HAL 弱函数覆盖):
  *         前半缓冲刚播完, DMA 正播放后半, 趁机重填前半 → 无缝双缓冲
  */
void HAL_SAI_TxHalfCpltCallback(SAI_HandleTypeDef *hsai)
{
  if (hsai->Instance == SAI1_Block_A)
  {
    pcm_audio_gen_half(0);  /* 前半刚播完, 立即重填前半 */
  }
}

/**
  * @brief  SAI TX DMA 传输完成回调 (HAL 弱函数覆盖):
  *         后半缓冲刚播完, 重填后半, 与半传输回调交替形成持续无缝输出
  */
void HAL_SAI_TxCpltCallback(SAI_HandleTypeDef *hsai)
{
  if (hsai->Instance == SAI1_Block_A)
  {
    pcm_audio_gen_half(1);  /* 后半刚播完, 立即重填后半 */
  }
}

/* USER CODE BEGIN 1 */

/* USER CODE END 1 */
