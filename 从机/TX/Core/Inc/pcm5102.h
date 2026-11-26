/* USER CODE BEGIN Header */
/**
  ******************************************************************************
  * @file    pcm5102.h
  * @brief   PCM5102APWR I2S DAC 驱动 (STM32H750 + SAI1_A)
  *
  *  硬件连接 (已验证与 CubeMX/ST 官方引脚数据一致):
  *    PCM5102 XSMT(17) -> PE3  (GPIO 输出, 高=解除静音)
  *    PCM5102 FMT (16)  -> GND  (I2S 标准格式)
  *    PCM5102 LRCK(15)  -> PE4  (SAI1_FS_A)
  *    PCM5102 DIN (14)  -> PE6  (SAI1_SD_A)
  *    PCM5102 BCK (13)  -> PE5  (SAI1_SCK_A)
  *    PCM5102 SCK (12)  -> GND  (内部 PLL 自动检测, 无需外部 MCLK)
  *    PC9 (I2S_CKIN)    <- 12.288MHz 有源晶振 (SAI1 内核时钟, 256x48k)
  *
  *  采样参数: 48kHz / 16bit / 立体声 / I2S 标准 (2 槽 x 16bit, 帧长 32bit)
  *            BCK=1.536MHz, MCLK 输出关闭(不需要)
  *
  *  播放方式: SAI1_A 主机发送 + DMA2_Stream6 循环 DMA (无 CPU 占用)
  *            音频缓冲位于 AXI SRAM (0x24000000), DMA 可访问
  ******************************************************************************
  * @attention
  *  驱动内部自行完成: XSMT GPIO、DMA2 配置、NVIC、波形合成。
  *  若日后用 CubeMX 重新生成代码, 已在 .ioc 中同步 PE3/DMA2_Stream6/NVIC 配置。
  ******************************************************************************
  */
/* USER CODE END Header */
#ifndef __PCM5102_H__
#define __PCM5102_H__

#ifdef __cplusplus
extern "C" {
#endif

#include "main.h"
#include "sai.h"

/* ------------------------ 硬件资源定义 ------------------------ */
#define PCM5102_XSMT_PORT    GPIOE
#define PCM5102_XSMT_PIN     GPIO_PIN_3        /* PE3: 软静音控制, 高=正常/低=静音 */

/* ------------------------ 音频参数 ------------------------ */
#define PCM5102_FS           48000U            /* 采样率 Hz (由 12.288MHz 精确产生) */
#define PCM5102_FRAME_SAMPLES 1024U            /* 每声道样本数(缓冲循环周期 ~21ms, 低延迟) */
#define PCM5102_BUF_SAMPLES  (PCM5102_FRAME_SAMPLES * 2U)   /* 交织: L,R,L,R... */

/* ------------------------ 波形类型 ------------------------ */
typedef enum {
  PCM5102_WAVE_SINE     = 0,   /* 正弦波 */
  PCM5102_WAVE_SQUARE   = 1,   /* 方波   */
  PCM5102_WAVE_TRIANGLE = 2,   /* 三角波 */
  PCM5102_WAVE_SAW      = 3,   /* 锯齿波 */
  PCM5102_WAVE_SWEEP    = 4    /* 扫频 200->2000Hz, 步进25Hz/半缓冲(~3s 周期) */
} PCM5102_Wave_t;

/* DMA 句柄 (DMA2_Stream6, 供 stm32h7xx_it.c 中断使用) */
extern DMA_HandleTypeDef hdma_sai1_a;

/* ------------------------ 驱动接口 ------------------------ */
void    PCM5102_Init(void);            /* 初始化并开始播放 1kHz 测试音 */
void    PCM5102_Task(void);            /* 周期调用: 处理 USART2 命令 */
int     PCM5102_SetFrequency(uint32_t hz);   /* 20..20000 Hz, 返回 0 成功 */
int     PCM5102_SetVolume(uint8_t pct);      /* 0..100, 返回 0 成功 */
int     PCM5102_SetWave(PCM5102_Wave_t w);   /* 返回 0 成功 */
void    PCM5102_Mute(void);            /* XSMT 拉低(软静音) */
void    PCM5102_Unmute(void);          /* XSMT 拉高(解除静音) */
void    PCM5102_Play(void);            /* 启动 SAI/DMA 播放 */
void    PCM5102_Stop(void);            /* 停止播放并静音 */
void    PCM5102_SetDemodMode(uint8_t en);  /* 1=输出解调音频, 0=测试音 */
uint8_t PCM5102_GetDemodMode(void);

/* v22.1: 原供 LCD 显示读取，LCD 驱动已删除，留给其他上位机/显示使用 */
uint32_t PCM5102_GetFreq(void);
uint8_t  PCM5102_GetVolume(void);
PCM5102_Wave_t PCM5102_GetWave(void);
uint8_t  PCM5102_IsPlaying(void);

/* USER CODE BEGIN Prototypes */

/* USER CODE END Prototypes */

#ifdef __cplusplus
}
#endif

#endif /* __PCM5102_H__ */
