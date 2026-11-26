#ifndef __SI5351_H
#define __SI5351_H

#include <stdint.h>

uint8_t si5351_init(void);
void si5351_set_lo(uint32_t tuned_hz);

#endif
