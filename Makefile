#
# Makefile
#
PROG    = iomem_hunter

# you can use command "export CROSS_COMPILE=powerpc-eabi-" instead of
CROSS_COMPILE = powerpc-eabi-

#
AS      = $(CROSS_COMPILE)as
LD      = $(CROSS_COMPILE)ld
CC      = $(CROSS_COMPILE)gcc
CPP     = $(CROSS_COMPILE)g++
AR      = $(CROSS_COMPILE)ar
NM      = $(CROSS_COMPILE)nm
STRIP   = $(CROSS_COMPILE)strip
OBJCOPY = $(CROSS_COMPILE)objcopy
OBJDUMP = $(CROSS_COMPILE)objdump
OBJCOPY = $(CROSS_COMPILE)objcopy
STRIP   = $(CROSS_COMPILE)strip

LDSTATIC  = -static
ELF2ECOFF = ${OBJCOPY} -O ecoff-bigmips
ELF2BIN   = ${OBJCOPY} -O binary

SUBDIRS =
OBJS	=


${PROG}.o: ${PROG}.S
	$(AS) --defsym ${IOS}=1 --defsym _COPY=${COPY} --defsym  _SIGNATURE=${SIGNATURE} -mregnames -o ${PROG}.elf ${PROG}.S

${PROG}.bin: ${PROG}.o
	${ELF2BIN} ${PROG}.elf ${PROG}.bin

clean:
	rm -f *.o core *.core ${PROG}.map ${PROG}.elf ${PROG}.bin

