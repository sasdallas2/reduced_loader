### reduced_loader Makefile
### Written by sasdallas (2024)

# Programs

NASM = nasm
CC = cc
DD = dd

QEMU = qemu-system-x86_64
QEMU_IMG = qemu-img


# Flags

CC16_FLAGS = -m16 -ffrestanding
CC32_FLAGS = -m32 -ffreestanding

ASM_FLAGS = -f bin

# Directories

SRC_DIR = src
BUILD_DIR = build

# mbr target (src/mbr.asm)
mbr:
	$(NASM) $(ASM_FLAGS) $(SRC_DIR)/mbr.asm -o $(BUILD_DIR)/mbr.bin

# hd target (writes to hd image)
hd:
	$(QEMU_IMG) create hd.img 1M
	$(DD) if=$(BUILD_DIR)/mbr.bin of=hd.img bs=512 seek=0
	$(QEMU) -hda hd.img



all: mbr
