OUTPUT_ARCH(arm)
ENTRY(Reset_Handler)

MEMORY
{
	RAM(xrw) : ORIGIN = 0x20000000, LENGTH = 64K
	FLASH(rx): ORIGIN = 0x08000000, LENGTH = 512K
}

SECTIONS
{
	. = ALIGN(4);
	.text :
	{
		KEEP(*(.isr_vector))
		*(.text)
	} > FLASH
	
	. = ALIGN(4);
	__etext = .;
	.data : AT (__etext)
	{
		__data_start__ = .;
		*(vtable)
		*(.data*)
		. = ALIGN(4);

		PROVIDE (__preinit_array_start = .);
		*(.preinit_array)
		PROVIDE (__preinit_array_end = .);

		. = ALIGN(4);
		PROVIDE (__init_array_start = .);
		*(SORT(.init_array.*))
		*(.init_array)
		PROVIDE (__init_array_end = .);

		. = ALIGN(4);
		PROVIDE (__fini_array_start = .);
		*(SORT(.fini_array.*))
		*(.fini_array)
		PROVIDE (__fini_array_end = .);

		. = ALIGN(4);
		__data_end__ = .;
	} > RAM
	
	. = ALIGN(4);
	.bss :
	{
		__bss_start__ = .;
		*(.bss)
		__bss_end__ = .;
	} > RAM
	
	. = ALIGN(4);
	.heap :
	{		
		__end__ = .;
		end = __end__;
		*(.heap*)
		__HeapLimit = .;
	} > RAM
	
	.stack_dummy :
	{
		*(.stack)
	} > RAM
	
	__StackTop = ORIGIN(RAM) + LENGTH(RAM);
	__StackLimit = __StackTop - SIZEOF(.stack_dummy);
	PROVIDE(__stack = __StackTop);
	
	/* 检查数据+堆+栈是否超出RAM */
	ASSERT(__StackLimit >= __HeapLimit, "region RAM overflowed with stack")
}


