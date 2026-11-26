/**
  ******************************************************************************
  * @file    am_demod.h
  * @brief   Multi-mode demodulator: AM / FM / USB / LSB / CW with AGC
  *
 *  Input:  2.4MHz ADC1 stream, DDC-decimated to 600kHz inside the ISR
 *  Output: 48kHz audio samples (mono, int16)
 *
 *  Common front-end (600kHz, all inside the TIM3 ISR):
 *      DDC (NCO) -> IF channel LPF -> 12.5x decimation
 *  The channel LPF must sit *before* the decimation: at 600kHz the output
 *  only keeps +-24kHz, so anything left unfiltered above that folds straight
 *  into the audio band (this was why one station showed up on many
 *  frequencies).  Butterworth order 4 (SSB/AM/CW) / 6 (FM) gives 60..95dB
 *  at the first alias frequency.
 *
 *  Mode-specific back-end (at 48kHz):
 *    AM  : envelope detection + DC removal + AGC
 *    FM  : quadrature discriminator + de-emphasis + AGC
 *    USB : 127-tap Hilbert phasing detector (I - H(Q)) + AGC
 *    LSB : 127-tap Hilbert phasing detector (I + H(Q)) + AGC
 *    CW  : 1.2kHz beat shift + DC removal + AGC
  ******************************************************************************
  */
#ifndef __AM_DEMOD_H
#define __AM_DEMOD_H

#ifdef __cplusplus
extern "C" {
#endif

#include <stdint.h>

/* Demodulator input sample rate (the TIM3 read rate, not the ADC rate).
 * v71: TIM3 runs at 240MHz/368 = 652173.9Hz so that it is *exactly*
 * ADC_rate/4 -- the ADC free-runs at 60MHz/23 = 2608695.7Hz with the new
 * 8.5-cycle sample time.  The previous 600kHz TIM3 read a 3.75MHz ADC
 * stream at a 6.25:1 ratio, so each picked sample was quantised to the ADC
 * grid and up to half an ADC sample (+-22deg at 465kHz) of phase jitter
 * went into every mode. */
#define DEMOD_INPUT_FS     652174U

/* Output sample rate (matches PCM5102) */
#define DEMOD_OUTPUT_FS    48000U

/* Decimation factor = 1.2M / 48k = 25 */

/* Audio output ring buffer size (power of 2).
   Keep small to minimize latency: 2048 @48kHz = ~43ms */
#define DEMOD_AUDIO_BUF    4096U  /* v59b: 2048->4096 (42.7ms->85ms), 加大缓冲平滑调度抖动 */
#define DEMOD_AUDIO_MASK   (DEMOD_AUDIO_BUF - 1U)

/* CW beat frequency offset (Hz) - produces audible tone */
#define DEMOD_CW_BFO       700U

/* Demodulation modes */
typedef enum {
    DEMOD_MODE_AM  = 0,
    DEMOD_MODE_FM  = 1,
    DEMOD_MODE_USB = 2,
    DEMOD_MODE_LSB = 3,
    DEMOD_MODE_CW  = 4
} demod_mode_t;

/* ------------------------ API ------------------------ */

/**
 * @brief  Initialize demodulator state and set default carrier frequency.
 */
void am_demod_init(void);

/**
 * @brief  Set demodulation carrier frequency (Hz).
 * @param  hz  Carrier frequency, e.g. 465000
 */
void am_demod_set_freq(uint32_t hz);

/**
 * @brief  Get current demodulation carrier frequency.
 */
uint32_t am_demod_get_freq(void);

/**
 * @brief  Set demodulation mode (AM/FM/USB/LSB/CW).
 * @param  mode  demod_mode_t
 */
void am_demod_set_mode(demod_mode_t mode);

/**
 * @brief  Get current demodulation mode.
 */
demod_mode_t am_demod_get_mode(void);

/**
 * @brief  Enable/disable demodulator.
 * @param  en  1=enable, 0=disable (output silence)
 */
void am_demod_enable(uint8_t en);

/**
 * @brief  Get demodulator enable state.
 */
uint8_t am_demod_is_enabled(void);

/**
 * @brief  ISR-side: DDC + anti-alias LPF + decimation (1.2MHz -> 48kHz).
 *         Lightweight, runs in TIM2 ISR. Decimated I/Q samples queued internally.
 * @param  sample  16-bit signed ADC sample (centered at 0)
 */
void am_demod_input(int16_t sample);

/**
 * @brief  Main-loop-side: process one queued 48kHz I/Q sample through
 *         high-order filters, mixer, AGC, and output ring buffer.
 *         Call repeatedly in main loop to drain the 48kHz queue.
 * @return 1 if a sample was processed, 0 if queue empty
 */
uint8_t am_demod_poll(void);

/**
 * @brief  Read one demodulated audio sample from ring buffer (48kHz).
 * @param  out  Pointer to store the sample
 * @return 1 if sample available, 0 if buffer empty
 */
uint8_t am_demod_read(int16_t *out);

/**
 * @brief  Get current AGC gain (for debug/monitoring).
 */
int32_t am_demod_get_agc_gain(void);

/**
 * @brief  Set additional audio output gain (after AGC).
 * @param  gain  gain factor, e.g. 1.0 = 0dB, 10.0 = 20dB, 31.6 = 30dB
 */
void am_demod_set_audio_gain(float gain);

/**
 * @brief  Enable/disable 50Hz high-pass filter to remove power-line hum
 *         and low-frequency rumble (18Hz etc).
 * @param  en  1=enable, 0=disable
 */
void am_demod_set_hpf50(uint8_t en);

/*
 * Lightweight audio-domain noise reduction.
 * en: 0/1, level: 1..3
 */
void am_demod_set_nr(uint8_t en, uint8_t level);

/**
 * @brief  Get current signal envelope (for debug/monitoring).
 */
int32_t am_demod_get_envelope(void);

#ifdef __cplusplus
}
#endif

#endif /* __AM_DEMOD_H */
