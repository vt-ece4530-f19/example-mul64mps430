# base
MSPBASE=/cygdrive/c/ti/msp430-gcc/bin
# configuration
MSPCC=${MSPBASE}/msp430-elf-gcc
# MSPCCFLAGS=-Wall -Os -fdata-sections -ffunction-sections -mmcu=msp430c1111 
# MSPLDFLAGS=-mmcu=msp430c1111 -Wl,--gc-sections -minrt -T linker.x 
MSPCCFLAGS=-Wall -Os -mmcu=msp430c1111 -Ic:/ti/msp430-gcc/include 
MSPLDFLAGS=-mmcu=msp430c1111 -T linker.x 
MSPOBJCOPY=${MSPBASE}/msp430-elf-objcopy
MSPOBJDUMP=${MSPBASE}/msp430-elf-objdump
MSPSIZE=${MSPBASE}/msp430-elf-size

all:
	@echo "Targets: "
	@echo "  compile    Compile software packages"
	@echo "  clean      Remove intermediate files"

compile: mul64.bin

main.o: main.c
	$(MSPCC)  -I../hal $(MSPCCFLAGS) -c $< -o $@ 
	$(MSPSIZE) $@

mul64.elf: main.o
	$(MSPCC)  $(MSPLDFLAGS) -L../hal  $< -lomsp_de -o $@ 
	$(MSPSIZE) $@
	${MSPOBJDUMP} -dSt mul64.elf >mul64.lst

mul64.bin: mul64.elf
	$(MSPOBJCOPY) -I elf32-msp430 -O binary mul64.elf mul64.bin

clean:
	rm -rf mul64.elf *.o *~ mul64.bin mul64.lst

