CROSS_COMPILE		?= arm-none-eabi-

DIRECTORY			?= ./
SOURCEPATH			:= $(DIRECTORY)src/

INCLUDELIBPATH		+= $(DIRECTORY)lib/inc/
SOURCELIBPATH		+= $(DIRECTORY)lib/src/

FREERTOSPATH		+= $(DIRECTORY)freertos/
FREERTOSPORTPATH	+= $(FREERTOSPATH)portable/
INCLUDEFREERTOSPATH	+= $(FREERTOSPATH)include/
INCLUDEFREERTOSPATH	+= $(FREERTOSPORTPATH)

DEFINE				+= USE_STDPERIPH_DRIVER
DEFINE				+= STM32F10X_HD

INCLUDEPATH			+= $(SOURCEPATH)
INCLUDEPATH			+= $(INCLUDELIBPATH)
INCLUDEPATH			+= $(INCLUDEFREERTOSPATH)

FREERTOSSOURCES		+= list.c
FREERTOSSOURCES		+= tasks.c
FREERTOSSOURCES		+= queue.c
FREERTOSPORTSOURCES	+= port.c
FREERTOSPORTSOURCES	+= heap_2.c

LIBSOURCES			+= system_stm32f10x.c
LIBSOURCES			+= misc.c
LIBSOURCES			+= stm32f10x_rcc.c
LIBSOURCES			+= stm32f10x_gpio.c 
LIBSOURCES			+= stm32f10x_tim.c 
LIBSOURCES			+= stm32f10x_usart.c 

SOURCES				+= start.s
SOURCES				+= main.c
SOURCES				+= led.c
SOURCES				+= timer.c
SOURCES				+= usart.c
SOURCES				+= printf-stdarg.c

LD_FILE				:= $(DIRECTORY)linker.lds
ELF_FILE			:= $(DIRECTORY)stm32f10x_freertos.elf
BIN_FILE			:= $(DIRECTORY)stm32f10x_freertos.bin
HEX_FILE			:= $(DIRECTORY)stm32f10x_freertos.hex

SOURCE				+= $(addprefix $(SOURCEPATH),$(SOURCES))
SOURCE				+= $(addprefix $(SOURCELIBPATH),$(LIBSOURCES))
SOURCE				+= $(addprefix $(FREERTOSPATH),$(FREERTOSSOURCES))
SOURCE				+= $(addprefix $(FREERTOSPORTPATH),$(FREERTOSPORTSOURCES))
INCLUDE				:= $(addprefix -I,$(INCLUDEPATH))
OBJECTFILES			:= $(patsubst %.c,%.o,$(patsubst %.s,%.o,$(SOURCE)))
CLEAR				:= $(OBJECTFILES)

CC					:= $(CROSS_COMPILE)gcc
LD					:= $(CROSS_COMPILE)ld
OBJCOPY				:= $(CROSS_COMPILE)objcopy

DEFINE_FLAG			:= $(addprefix -D,$(DEFINE))
CC_FLAG				:= -O0 -Wall -mthumb -mcpu=cortex-m3
LD_FLAG				:= -O0 -nostartfiles -T$(LD_FILE)


all: $(ELF_FILE)
$(ELF_FILE): $(OBJECTFILES)
	$(LD) $(LD_FLAG) $(INCLUDE) -o $@ $^ 
	$(OBJCOPY) -O binary $@ $(BIN_FILE)
	$(OBJCOPY) -O ihex $@ $(HEX_FILE) 

%.o: %.s
	$(CC) -c $(CC_FLAG) -o $@ $<

%.o: %.c
	$(CC) $(CC_FLAG) $(DEFINE_FLAG) $(INCLUDE) -o $@ -c $<

.PHONY: clean
clean:
	rm -f $(subst /,/,$(CLEAR)) *.hex *.bin *.elf
