# Variables
ASM        = nasm
ASFLAGS    = -f bin
OUTPUT_DIR = build
STAGE1_SRC        = stage1.asm
STAGE1_BIN     = $(OUTPUT_DIR)/stage1.bin

STAGE2_SRC = stage2.asm
STAGE2_BIN = $(OUTPUT_DIR)/stage2.bin

DISK_IMG   = $(OUTPUT_DIR)/disk.img

QEMU       = qemu-system-x86_64
QEMU_FLAGS = -drive format=raw,file=$(DISK_IMG)

.PHONY: all clean run

# Default target
all: $(OUTPUT_DIR) $(STAGE1_BIN) 
#$(STAGE2_BIN) $(DISK_IMG)

# Create the build directory if it doesn't exist
$(OUTPUT_DIR):
	mkdir -p $(OUTPUT_DIR)

# Compile stage1
$(STAGE1_BIN): $(STAGE1_SRC) | $(OUTPUT_DIR)
	$(ASM) $(ASFLAGS) -o $@ $<
	touch build/os.img; \
	truncate -s +64M build/os.img; \
	mkdosfs -F 32 -I -S 512 -v build/os.img; \
	dd if=build/stage1.bin of=build/os.img bs=512 count=1 conv=notrunc; \
	dd if=build/stage1.bin of=build/os.img bs=512 count=1 seek=6 conv=notrunc

# Compile stage2
$(STAGE2_BIN): $(STAGE2_SRC) | $(OUTPUT_DIR)
	$(ASM) $(ASFLAGS) -o $@ $<

# Create the disk image
$(DISK_IMG): $(STAGE1_BIN) $(STAGE2_BIN) | $(OUTPUT_DIR)
	@echo "Creating the disk image..."
	dd if=/dev/zero of=$@ bs=512 count=2880 2>/dev/null
	dd if=$(STAGE1_BIN) of=$@ bs=512 conv=notrunc
	dd if=$(STAGE2_BIN) of=$@ bs=512 seek=2 conv=notrunc
	@echo "Disk image created successfully."

# Run the bootloader in QEMU
run:
 # $(DISK_IMG)
	# $(QEMU) $(QEMU_FLAGS)
	# qemu-system-i386 -drive format=raw,file=build/disk.img
	qemu-system-i386 -hda build/os.img -serial file:serial.log

# Clean up build artifacts
clean:
	rm -rf $(OUTPUT_DIR)

