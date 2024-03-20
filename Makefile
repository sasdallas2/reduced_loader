### reduced_loader Makefile
### Written by sasdallas (2024)

# Programs

NASM = nasm
CC = cc

DD = dd
RM = rm
CP = cp

QEMU = qemu-system-x86_64
QEMU_IMG = qemu-img
MKFS = mkfs.vfat
MCOPY = mcopy


# Flags

CC32_FLAGS = -m32 -ffreestanding

ASM_FLAGS = -f bin

# Directories

SRC_DIR = src
BUILD_DIR = build

BOOTLDR_SRC = $(SRC_DIR)/reduced_loader/bootldr
BOOTMGR_SRC = $(SRC_DIR)/reduced_loader/bootmgr


# Files

BOOTMGR_ASM = $(wildcard $(BOOTMGR_SRC)/*.asm)
BOOTMGR_C = $(wildcard $(BOOTMGR_SRC)/*.c)
OBJ_FILES = $(patsubst $(BOOTMGR_SRC)/%.asm, $(BUILD_DIR)/%.bin, $(BOOTMGR_ASM)) $(patsubst $(BOOTMGR_SRC)/%.asm, $(BUILD_DIR)/%.bin, $(BOOTMGR_C))



all: print_info mbr $(BUILD_DIR)/BOOTLDR.SYS hd

# print_info target
print_info:
	@printf "===== reduced_loader - (C) sasdallas =====\n"
	@printf "======= Beginning compile process ========\n"





# mbr target (src/mbr.asm)
mbr:
	@printf "[ compiling MBR... ]\n"
	$(NASM) $(ASM_FLAGS) $(SRC_DIR)/mbr.asm -o $(BUILD_DIR)/mbr.bin

# make_hd target
make_hd:
	@printf "[ tbd, use WinImage for MBR now via wine ]\n"
	@printf "[ (i'm not that great with VBR/MBR stuff ) ]\n"

# hd target (writes to hd image)
hd:
	@printf "[ Copying BOOTLDR.SYS... ]\n"
	@$(MCOPY) -i disk.img $(BUILD_DIR)/BOOTLDR.SYS ::
	@printf "[ Starting via QEMU ]\n"
	$(QEMU) -fda disk.img


$(BUILD_DIR)/BOOTLDR.SYS:
	@printf "[ compiling BOOTLDR.SYS... ]\n"
	$(NASM) -f bin $(BOOTLDR_SRC)/start.asm -o $(BUILD_DIR)/BOOTLDR.SYS


clean:
	$(RM) -rf $(BUILD_DIR)/*
	$(RM) hd.img
	@printf "[ cleaned successfully ]\n"