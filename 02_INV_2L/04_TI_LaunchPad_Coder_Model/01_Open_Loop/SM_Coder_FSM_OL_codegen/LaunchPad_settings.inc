// TSP Version
#define TSP_VER 0x102

// Clock configurations
#define SYSCLK_HZ 190000000L
#define SYSCLK_WC_HI_HZ 196000000L
#define LSPCLK_HZ (SYSCLK_HZ / 4l)
#define PLL_SYSCLK_DIV 1
#define PLL_FMULT 0
#define PLL_IMULT 38
#define PLL_SRC 0
#define PLX_CPU_RATE 5.2631578947368L

// HAL object allocations
#define HAL_NUM_DOUT_CHANNELS 4
#define HAL_NUM_DIN_CHANNELS 1
#define HAL_NUM_PWM_CHANNELS 3
#define HAL_NUM_ADCS 2
#define HAL_NUM_QEP_CHANNELS 0
#define HAL_NUM_TZ_CHANNELS 6
#define HAL_NUM_SPI_CHANNELS 0
#define HAL_NUM_DAC_CHANNELS 0
#define HAL_NUM_CAP_CHANNELS 0
#define HAL_NUM_CANBUS_CHANNELS 0

// Dispatcher configurations
#define DISP_CONFIGURE_TRIGGER() DISPR_setTriggerByPwm((PWM_Unit_t)1, 3)
#define TASK1_HZ 20000 // exact value: 2.000000e+04 Hz
#define TASK1_PRD_IN_SYS_CLK_TICKS 9500L

#define NUM_TASKS 1


