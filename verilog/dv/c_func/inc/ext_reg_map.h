//--------------------------------------------------------------------
// Register Address Map As Seen By the External/Caravel RISCV Core
//--------------------------------------------------------------------

//-------------------------------------
// PinMux Register
// ------------------------------------
#define reg_glbl_chip_id       (*(volatile uint32_t*)0x30020000)  // reg_0  - Chip ID
#define reg_glbl_cfg0          (*(volatile uint32_t*)0x30020004)  // reg_1  - Global Config-0
#define reg_glbl_cfg1          (*(volatile uint32_t*)0x30020008)  // reg_2  - Global Config-1
#define reg_glbl_intr_msk      (*(volatile uint32_t*)0x3002000C)  // reg_3  - Global Interrupt Mask
#define reg_glbl_intr          (*(volatile uint32_t*)0x30020010)  // reg_4  - Global Interrupt
#define reg_glbl_multi_func    (*(volatile uint32_t*)0x30020014)  // reg_5 - GPIO Multi Function
#define reg_glbl_soft_reg_0    (*(volatile uint32_t*)0x30020018)  // reg_6 - Soft Register-0
#define reg_glbl_soft_reg_1    (*(volatile uint32_t*)0x3002001C)  // reg_7 - Sof Register-1
#define reg_glbl_soft_reg_2    (*(volatile uint32_t*)0x30020020)  // reg_8 - Sof Register-2
#define reg_glbl_soft_reg_3    (*(volatile uint32_t*)0x30020024)  // reg_9 - Sof Register-3
#define reg_glbl_soft_reg_4    (*(volatile uint32_t*)0x30020028)  // reg_10 - Sof Register-4
#define reg_glbl_soft_reg_5    (*(volatile uint32_t*)0x3002002C)  // reg_11 - Sof Register-5

#define reg_gpio_dsel         (*(volatile uint32_t*)0x30020040)  // reg_0  - GPIO Direction Select
#define reg_gpio_type         (*(volatile uint32_t*)0x30020044)  // reg_1  - GPIO TYPE - Static/Waveform
#define reg_gpio_idata        (*(volatile uint32_t*)0x30020048)  // reg_2  - GPIO Data In
#define reg_gpio_odata        (*(volatile uint32_t*)0x3002004C)  // reg_3  - GPIO Data Out
#define reg_gpio_intr_stat    (*(volatile uint32_t*)0x30020050)  // reg_4  - GPIO Interrupt status
#define reg_gpio_intr_clr     (*(volatile uint32_t*)0x30020050)  // reg_5  - GPIO Interrupt Clear
#define reg_gpio_intr_set     (*(volatile uint32_t*)0x30020054)  // reg_6 - GPIO Interrupt Set
#define reg_gpio_intr_mask    (*(volatile uint32_t*)0x30020058)  // reg_7 - GPIO Interrupt Mask
#define reg_gpio_pos_intr     (*(volatile uint32_t*)0x3002005C)  // reg_8 - GPIO Posedge Interrupt
#define reg_gpio_neg_intr     (*(volatile uint32_t*)0x30020060)  // reg_9 - GPIO Neg Interrupt

#define reg_pinmux_glbl_cfg   (*(volatile uint32_t*)0x30020080)  // reg_0 - PWM Reg-0
#define reg_pinmux_cfg_pwm0   (*(volatile uint32_t*)0x30020084)  // reg_1 - PWM Reg-0
#define reg_pinmux_cfg_pwm1   (*(volatile uint32_t*)0x30020088)  // reg_2 - PWM Reg-1
#define reg_pinmux_cfg_pwm2   (*(volatile uint32_t*)0x3002008C)  // reg_3 - PWM Reg-2
#define reg_pinmux_cfg_pwm3   (*(volatile uint32_t*)0x30020090)  // reg_4 - PWM Reg-3
#define reg_pinmux_cfg_pwm4   (*(volatile uint32_t*)0x30020094)  // reg_5 - PWM Reg-4
#define reg_pinmux_cfg_pwm5   (*(volatile uint32_t*)0x30020098)  // reg_6 - PWM Reg-5

#define reg_timer_glbl_cfg    (*(volatile uint32_t*)0x300200C0)  // reg_0 - Global config
#define reg_timer_cfg_timer0  (*(volatile uint32_t*)0x300200C4)  // reg_1 - Timer-0
#define reg_timer_cfg_timer1  (*(volatile uint32_t*)0x300200C8)  // reg_2 - Timer-1
#define reg_timer_cfg_timer2  (*(volatile uint32_t*)0x300200CC)  // reg_3 - Timer-2

#define reg_sema_lock0        (*(volatile uint32_t*)0x30020100)  // reg_0  - Hardware Lock-0
#define reg_sema_lock1        (*(volatile uint32_t*)0x30020104)  // reg_1  - Hardware Lock-1
#define reg_sema_lock2        (*(volatile uint32_t*)0x30020108)  // reg_2  - Hardware Lock-2
#define reg_sema_lock3        (*(volatile uint32_t*)0x3002010C)  // reg_3  - Hardware Lock-3
#define reg_sema_lock4        (*(volatile uint32_t*)0x30020110)  // reg_4  - Hardware Lock-4
#define reg_sema_lock5        (*(volatile uint32_t*)0x30020114)  // reg_5  - Hardware Lock-5
#define reg_sema_lock6        (*(volatile uint32_t*)0x30020118)  // reg_6  - Hardware Lock-6
#define reg_sema_lock7        (*(volatile uint32_t*)0x3002011C)  // reg_7  - Hardware Lock-7
#define reg_sema_lock8        (*(volatile uint32_t*)0x30020120)  // reg_8  - Hardware Lock-8
#define reg_sema_lock9        (*(volatile uint32_t*)0x30020124)  // reg_9  - Hardware Lock-9
#define reg_sema_lock10       (*(volatile uint32_t*)0x30020128)  // reg_10 - Hardware Lock-10
#define reg_sema_lock11       (*(volatile uint32_t*)0x3002012C)  // reg_11 - Hardware Lock-11
#define reg_sema_lock12       (*(volatile uint32_t*)0x30020130)  // reg_12 - Hardware Lock-12
#define reg_sema_lock13       (*(volatile uint32_t*)0x30020134)  // reg_13 - Hardware Lock-13
#define reg_sema_lock14       (*(volatile uint32_t*)0x30020138)  // reg_14 - Hardware Lock-14
#define reg_sema_lock_cfg     (*(volatile uint32_t*)0x3002013C)  // reg_15 - Hardware Lock config
#define reg_sema_lock_stat    (*(volatile uint32_t*)0x3002013C)  // reg_15 - Hardware Lock Status


#define reg_uart0_ctrl         (*(volatile uint32_t*)0x30010000)  // Reg-0
#define reg_uart0_intr_stat    (*(volatile uint32_t*)0x30010004)  // Reg-1
#define reg_uart0_baud_ctrl1   (*(volatile uint32_t*)0x30010008)  // Reg-2
#define reg_uart0_baud_ctrl2   (*(volatile uint32_t*)0x3001000C)  // Reg-3
#define reg_uart0_status       (*(volatile uint32_t*)0x30010010)  // Reg-4
#define reg_uart0_txdata       (*(volatile uint32_t*)0x30010014)  // Reg-5
#define reg_uart0_rxdata       (*(volatile uint32_t*)0x30010018)  // Reg-6
#define reg_uart0_txfifo_stat  (*(volatile uint32_t*)0x3001001C)  // Reg-7
#define reg_uart0_rxfifo_stat  (*(volatile uint32_t*)0x30010020)  // Reg-8

#define reg_uart1_ctrl         (*(volatile uint32_t*)0x30010100)  // Reg-0
#define reg_uart1_intr_stat    (*(volatile uint32_t*)0x30010104)  // Reg-1
#define reg_uart1_baud_ctrl1   (*(volatile uint32_t*)0x30010108)  // Reg-2
#define reg_uart1_baud_ctrl2   (*(volatile uint32_t*)0x3001010C)  // Reg-3
#define reg_uart1_status       (*(volatile uint32_t*)0x30010110)  // Reg-4
#define reg_uart1_txdata       (*(volatile uint32_t*)0x30010114)  // Reg-5
#define reg_uart1_rxdata       (*(volatile uint32_t*)0x30010118)  // Reg-6
#define reg_uart1_txfifo_stat  (*(volatile uint32_t*)0x3001011C)  // Reg-7
#define reg_uart1_rxfifo_stat  (*(volatile uint32_t*)0x30010120)  // Reg-8

