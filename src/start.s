    .syntax	unified
    .arch	armv7-m
    /* define stack size */
    .section .stack
    .align 3
    .equ	Stack_Size,	0x400
    .equ	BootRAM,	0xF1E0F85F
    .globl	__StackTop
    .globl	__StackLimit
__StackLimit:
    .space	Stack_Size
    .size	__StackLimit, . - __StackLimit
__StackTop:
    .size	__StackTop, . - __StackTop
    /* define heap size */
    .section .heap
    .align 3
    .equ	Heap_Size, 0x200
    .globl	__HeapBase
    .globl	__HeapLimit
__HeapBase:
    .space	Heap_Size
    .size	__HeapBase, . - __HeapBase
__HeapLimit:
    .size	__HeapLimit, . - __HeapLimit
    
    .section .isr_vector
    .align 2
    .globl	__isr_vector
__isr_vector:
    .word    __StackTop
    .word    Reset_Handler
    .word    NMI_Handler
    .word    HardFault_Handler
    .word    MemManage_Handler
    .word    BusFault_Handler
    .word    UsageFault_Handler
    .word    0
    .word    0
    .word    0
    .word    0
    .word    vPortSVCHandler
    .word    DebugMon_Handler
    .word    0
    .word    xPortPendSVHandler
    .word    xPortSysTickHandler

    /* external interrupts */
    .word    WWDG_IRQHandler
    .word    PVD_IRQHandler
    .word    TAMPER_IRQHandler
    .word    RTC_IRQHandler
    .word    FLASH_IRQHandler
    .word    RCC_IRQHandler
    .word    EXTI0_IRQHandler
    .word    EXTI1_IRQHandler
    .word    EXTI2_IRQHandler
    .word    EXTI3_IRQHandler
    .word    EXTI4_IRQHandler
    .word    DMA1_Channel1_IRQHandler
    .word    DMA1_Channel2_IRQHandler
    .word    DMA1_Channel3_IRQHandler
    .word    DMA1_Channel4_IRQHandler
    .word    DMA1_Channel5_IRQHandler
    .word    DMA1_Channel6_IRQHandler
    .word    DMA1_Channel7_IRQHandler
    .word    ADC1_2_IRQHandler
    .word    USB_HP_CAN1_TX_IRQHandler
    .word    USB_LP_CAN1_RX0_IRQHandler
    .word    CAN1_RX1_IRQHandler
    .word    CAN1_SCE_IRQHandler
    .word    EXTI9_5_IRQHandler
    .word    TIM1_BRK_IRQHandler
    .word    TIM1_UP_IRQHandler
    .word    TIM1_TRG_COM_IRQHandler
    .word    TIM1_CC_IRQHandler
    .word    TIM2_IRQHandler
    .word    TIM3_IRQHandler
    .word    TIM4_IRQHandler
    .word    I2C1_EV_IRQHandler
    .word    I2C1_ER_IRQHandler
    .word    I2C2_EV_IRQHandler
    .word    I2C2_ER_IRQHandler
    .word    SPI1_IRQHandler
    .word    SPI2_IRQHandler
    .word    USART1_IRQHandler
    .word    USART2_IRQHandler
    .word    USART3_IRQHandler
    .word    EXTI15_10_IRQHandler
    .word    RTCAlarm_IRQHandler
    .word    USBWakeUp_IRQHandler 
    .word    0
    .word    0
    .word    0
    .word    0
    .word    0
    .word    0
    .word    0

    /* vector size */
    .size    __isr_vector, . - __isr_vector

    .text
    .thumb
    .thumb_func
    .align 2
    .globl   Reset_Handler
    .type    Reset_Handler, %function
Reset_Handler:
    ldr    r1, =__etext
    ldr    r2, =__data_start__
    ldr    r3, =__data_end__

.flash_to_ram_loop:
    cmp    r2, r3
    ittt   lt
    ldrlt  r0, [r1], #4
    strlt  r0, [r2], #4
    blt    .flash_to_ram_loop
    /* clear bss */
    ldr    r0, =0
    ldr    r1, =__bss_start__
    ldr    r2, =__bss_end__

clear_bss_loop:
    cmp    r1, r2
    beq    clear_bss_loop_end
    str    r0, [r1], #4
    b      clear_bss_loop
clear_bss_loop_end:

    /* jump to main */
    ldr    r0, =SystemInit
    blx    r0
    ldr    r0, =main
    bx     r0

exit_loop:
    nop
    b      exit_loop    
    
    .pool
    .size  Reset_Handler, . - Reset_Handler
    
    .macro    def_default_handler    handler_name
    .align 1
    .thumb_func
    .weak    \handler_name
    .type    \handler_name, %function
\handler_name :
    b    .
    .size    \handler_name, . - \handler_name
    .endm
    
    def_default_handler    NMI_Handler
    def_default_handler    HardFault_Handler
    def_default_handler    MemManage_Handler
    def_default_handler    BusFault_Handler
    def_default_handler    UsageFault_Handler
    def_default_handler    DebugMon_Handler
    
    def_default_handler    WWDG_IRQHandler
    def_default_handler    PVD_IRQHandler
    def_default_handler    TAMPER_IRQHandler
    def_default_handler    RTC_IRQHandler
    def_default_handler    FLASH_IRQHandler
    def_default_handler    RCC_IRQHandler
    def_default_handler    EXTI0_IRQHandler
    def_default_handler    EXTI1_IRQHandler
    def_default_handler    EXTI2_IRQHandler
    def_default_handler    EXTI3_IRQHandler
    def_default_handler    EXTI4_IRQHandler
    def_default_handler    DMA1_Channel1_IRQHandler
    def_default_handler    DMA1_Channel2_IRQHandler
    def_default_handler    DMA1_Channel3_IRQHandler
    def_default_handler    DMA1_Channel4_IRQHandler
    def_default_handler    DMA1_Channel5_IRQHandler
    def_default_handler    DMA1_Channel6_IRQHandler
    def_default_handler    DMA1_Channel7_IRQHandler
    def_default_handler    ADC1_2_IRQHandler
    def_default_handler    USB_HP_CAN1_TX_IRQHandler
    def_default_handler    USB_LP_CAN1_RX0_IRQHandler
    def_default_handler    CAN1_RX1_IRQHandler
    def_default_handler    CAN1_SCE_IRQHandler
    def_default_handler    EXTI9_5_IRQHandler
    def_default_handler    TIM1_BRK_IRQHandler
    def_default_handler    TIM1_UP_IRQHandler
    def_default_handler    TIM1_TRG_COM_IRQHandler
    def_default_handler    TIM1_CC_IRQHandler
    def_default_handler    TIM2_IRQHandler
    def_default_handler    TIM3_IRQHandler
    def_default_handler    TIM4_IRQHandler
    def_default_handler    I2C1_EV_IRQHandler
    def_default_handler    I2C1_ER_IRQHandler
    def_default_handler    I2C2_EV_IRQHandler
    def_default_handler    I2C2_ER_IRQHandler
    def_default_handler    SPI1_IRQHandler
    def_default_handler    SPI2_IRQHandler
    def_default_handler    USART1_IRQHandler
    def_default_handler    USART2_IRQHandler
    def_default_handler    USART3_IRQHandler
    def_default_handler    EXTI15_10_IRQHandler
    def_default_handler    RTCAlarm_IRQHandler
    def_default_handler    USBWakeUp_IRQHandler 
    
    .end
