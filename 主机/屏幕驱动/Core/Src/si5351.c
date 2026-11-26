#include "si5351.h"
#include "main.h"

#define SI5351_ADDR              0x60U
#define SI5351_REG_OUT_ENABLE    3U
#define SI5351_REG_CLK0_CTRL     16U
#define SI5351_REG_CLK1_CTRL     17U
#define SI5351_REG_CLK2_CTRL     18U
#define SI5351_REG_SPREAD        149U
#define SI5351_REG_PLL_RESET     177U
#define SI5351_REG_XTAL_LOAD     183U

#define SI5351_PLL_A             0U
#define SI5351_PLL_B             1U
#define SI5351_XTAL_HZ           25000000UL
#define SI5351_FIXED_CLK0_HZ     10235000UL
#define SI5351_IF_HZ             10700000L

static uint8_t g_si5351_ok = 0;
static uint32_t g_si5351_actual_clk0 = 0;
static uint32_t g_si5351_actual_clk1 = 0;

static void si5351_pins_init(void)
{
    GPIO_InitTypeDef gpio = {0};
    __HAL_RCC_GPIOB_CLK_ENABLE();
    gpio.Pin = GPIO_PIN_6 | GPIO_PIN_7;
    gpio.Mode = GPIO_MODE_OUTPUT_OD;
    gpio.Pull = GPIO_PULLUP;
    gpio.Speed = GPIO_SPEED_FREQ_HIGH;
    HAL_GPIO_Init(GPIOB, &gpio);
    HAL_GPIO_WritePin(GPIOB, GPIO_PIN_6 | GPIO_PIN_7, GPIO_PIN_SET);
}

static inline void i2c_delay(void)
{
    for (volatile uint32_t i = 0; i < 180U; i++) __NOP();
}

static inline void scl_set(uint8_t high)
{
    HAL_GPIO_WritePin(GPIOB, GPIO_PIN_6, high ? GPIO_PIN_SET : GPIO_PIN_RESET);
}

static inline void sda_set(uint8_t high)
{
    HAL_GPIO_WritePin(GPIOB, GPIO_PIN_7, high ? GPIO_PIN_SET : GPIO_PIN_RESET);
}

static void i2c_start(void)
{
    sda_set(1); scl_set(1); i2c_delay();
    sda_set(0); i2c_delay();
    scl_set(0); i2c_delay();
}

static void i2c_stop(void)
{
    sda_set(0); i2c_delay();
    scl_set(1); i2c_delay();
    sda_set(1); i2c_delay();
}

static uint8_t i2c_write_byte(uint8_t value)
{
    uint8_t ack;
    for (uint8_t mask = 0x80U; mask; mask >>= 1) {
        sda_set((value & mask) ? 1 : 0);
        i2c_delay();
        scl_set(1); i2c_delay();
        scl_set(0); i2c_delay();
    }
    sda_set(1); i2c_delay();
    scl_set(1); i2c_delay();
    ack = (HAL_GPIO_ReadPin(GPIOB, GPIO_PIN_7) == GPIO_PIN_RESET) ? 1U : 0U;
    scl_set(0); i2c_delay();
    return ack;
}

static uint8_t si5351_write_reg(uint8_t reg, uint8_t value)
{
    uint8_t ack = 1U;
    i2c_start();
    ack &= i2c_write_byte((uint8_t)(SI5351_ADDR << 1));
    ack &= i2c_write_byte(reg);
    ack &= i2c_write_byte(value);
    i2c_stop();
    return ack;
}

static void si5351_write_param_block(uint8_t base, uint32_t p1, uint32_t p2, uint32_t p3)
{
    si5351_write_reg(base + 0U, (uint8_t)((p3 >> 8) & 0xFFU));
    si5351_write_reg(base + 1U, (uint8_t)(p3 & 0xFFU));
    si5351_write_reg(base + 2U, (uint8_t)((p1 >> 16) & 0x03U));
    si5351_write_reg(base + 3U, (uint8_t)((p1 >> 8) & 0xFFU));
    si5351_write_reg(base + 4U, (uint8_t)(p1 & 0xFFU));
    si5351_write_reg(base + 5U, (uint8_t)(((p3 >> 16) & 0x0FU) | ((p2 >> 16) & 0x0FU)));
    si5351_write_reg(base + 6U, (uint8_t)((p2 >> 8) & 0xFFU));
    si5351_write_reg(base + 7U, (uint8_t)(p2 & 0xFFU));
}

static void si5351_setup_pll(uint8_t pll, uint32_t mult, uint32_t num, uint32_t denom)
{
    uint32_t p1, p2, p3;
    if (num == 0U) {
        p1 = 128U * mult - 512U;
        p2 = 0U;
        p3 = denom;
    } else {
        uint64_t q = ((uint64_t)128U * num) / denom;
        p1 = (uint32_t)(128U * mult + q - 512U);
        p2 = (uint32_t)((uint64_t)128U * num - (uint64_t)denom * q);
        p3 = denom;
    }
    si5351_write_param_block(pll == SI5351_PLL_A ? 26U : 34U, p1, p2, p3);
    si5351_write_reg(SI5351_REG_PLL_RESET, pll == SI5351_PLL_A ? 0x80U : 0x20U);
}

static void si5351_setup_multisynth(uint8_t output, uint8_t pll,
                                    uint32_t div, uint32_t num, uint32_t denom,
                                    uint32_t rdiv)
{
    uint32_t p1, p2, p3;
    if (num == 0U) {
        p1 = 128U * div - 512U;
        p2 = 0U;
        p3 = denom;
    } else {
        uint64_t q = ((uint64_t)128U * num) / denom;
        p1 = (uint32_t)(128U * div + q - 512U);
        p2 = (uint32_t)((uint64_t)128U * num - (uint64_t)denom * q);
        p3 = denom;
    }

    uint8_t base = (uint8_t)(42U + output * 8U);
    si5351_write_reg(base + 0U, (uint8_t)((p3 >> 8) & 0xFFU));
    si5351_write_reg(base + 1U, (uint8_t)(p3 & 0xFFU));
    si5351_write_reg(base + 2U, (uint8_t)(((rdiv & 0x07U) << 4) | ((p1 >> 16) & 0x03U)));
    si5351_write_reg(base + 3U, (uint8_t)((p1 >> 8) & 0xFFU));
    si5351_write_reg(base + 4U, (uint8_t)(p1 & 0xFFU));
    si5351_write_reg(base + 5U, (uint8_t)(((p3 >> 16) & 0x0FU) | ((p2 >> 16) & 0x0FU)));
    si5351_write_reg(base + 6U, (uint8_t)((p2 >> 8) & 0xFFU));
    si5351_write_reg(base + 7U, (uint8_t)(p2 & 0xFFU));

    uint8_t ctrl = (uint8_t)(0x0FU | (pll == SI5351_PLL_B ? 0x20U : 0U) |
                             (num == 0U ? 0x40U : 0U));
    si5351_write_reg((uint8_t)(SI5351_REG_CLK0_CTRL + output), ctrl);
}

static uint8_t si5351_set_output(uint8_t output, uint8_t pll, uint32_t freq_hz)
{
    if (freq_hz < 8000U || freq_hz > 150000000U) return 0U;

    uint32_t f_ms = freq_hz;
    uint32_t rdiv = 0U;
    while (f_ms < 600000U && rdiv < 7U) {
        f_ms <<= 1;
        rdiv++;
    }

    uint32_t div = 900000000UL / f_ms;
    if (div > 1800U) div = 1800U;
    div &= ~1UL;
    if (div < 6U) div = 6U;

    uint32_t vco = f_ms * div;
    if (vco > 900000000UL) {
        while (vco > 900000000UL && div > 6U) {
            div -= 2U;
            vco = f_ms * div;
        }
    }
    if (vco < 600000000UL) return 0U;

    const uint32_t denom = 0xFFFFFUL;
    uint32_t mult = vco / SI5351_XTAL_HZ;
    uint32_t rem = vco % SI5351_XTAL_HZ;
    uint32_t num = (uint32_t)(((uint64_t)rem * denom) / SI5351_XTAL_HZ);
    if (mult < 15U || mult > 90U) return 0U;

    si5351_setup_pll(pll, mult, num, denom);
    si5351_setup_multisynth(output, pll, div, 0U, 1U, rdiv);
    if (output == 0U) g_si5351_actual_clk0 = freq_hz;
    else g_si5351_actual_clk1 = freq_hz;
    return 1U;
}

uint8_t si5351_init(void)
{
    si5351_pins_init();
    g_si5351_ok = 1U;
    g_si5351_ok &= si5351_write_reg(SI5351_REG_OUT_ENABLE, 0xFFU);
    si5351_write_reg(SI5351_REG_CLK0_CTRL, 0x80U);
    si5351_write_reg(SI5351_REG_CLK1_CTRL, 0x80U);
    si5351_write_reg(SI5351_REG_CLK2_CTRL, 0x80U);
    si5351_write_reg(SI5351_REG_XTAL_LOAD, 0xC0U); /* 10 pF */
    si5351_write_reg(SI5351_REG_SPREAD, 0x00U);

    g_si5351_ok &= si5351_set_output(0U, SI5351_PLL_A, SI5351_FIXED_CLK0_HZ);
    g_si5351_ok &= si5351_set_output(1U, SI5351_PLL_B, SI5351_FIXED_CLK0_HZ);
    si5351_write_reg(SI5351_REG_OUT_ENABLE, 0xFCU); /* CLK0/1 on, CLK2..7 off */
    return g_si5351_ok;
}

void si5351_set_lo(uint32_t tuned_hz)
{
    int64_t target = tuned_hz;
    int64_t diff = target - SI5351_IF_HZ;
    if (diff < 0) diff = -diff;

    if (diff < 8000 || diff > 150000000) {
        si5351_write_reg(SI5351_REG_OUT_ENABLE, 0xFEU); /* CLK1 off */
        g_si5351_actual_clk1 = 0U;
        return;
    }
    if (si5351_set_output(1U, SI5351_PLL_B, (uint32_t)diff))
        si5351_write_reg(SI5351_REG_OUT_ENABLE, 0xFCU);
}
