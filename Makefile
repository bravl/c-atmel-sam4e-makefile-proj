## Atmel SAM4E-EK Makefile
## Author: BRAVL

## Project name
PROJECT := simple_scheduler

## Output file
OUTPUT:= $(PROJECT).elf

## Toolchain
CC = $(CROSS_COMPILE)gcc
AS = $(CROSS_COMPILE)gcc
LD = $(CROSS_COMPILE)gcc
CP = $(CROSS_COMPILE)objcopy
OD = $(CROSS_COMPILE)objdump

## Automagically find files
CXX_FILES := $(shell find -name '*.c')
OBJ_FILES := $(CXX_FILES:.c=.o)
INC_FOLDER := $(shell find -name '*.h' -printf '%h\n' | sort -u)
INC_FOLDER := $(addprefix -I,$(INC_FOLDER))

## Set defines for compiler
C_DEFINES := -D__SAM4E16E__ -DDEBUG -DBOARD=SAM4E_EK -Dscanf=iscanf -DARM_MATH_CM4=true -Dprintf=iprintf -D__SAM4E16E__ -DUDD_ENABLE

## Compiler flags
C_FLAGS := -x c -mthumb -mcpu=cortex-m4 -c -pipe
C_FLAGS += $(C_DEFINES)
# Optimization and Debug
C_FLAGS += -O1 -g3
C_FLAGS += -fdata-sections -ffunction-sections -mlong-calls -fno-strict-aliasing -ffunction-sections -fdata-sections
C_FLAGS += -Wall -std=gnu99 --param max-inline-insns-single=500 -mfloat-abi=softfp -mfpu=fpv4-sp-d16

## Linker parameters
SYMBOL_MAP := $(PROJECT).map
# Find linker file
LD_FILE := $(shell find -name '*.ld')
# Set the address offset
# LD_SECT_START := -Wl,-section-start=.text=0x00420000
LD_SECT_START :=

## Compiler flags
LD_FLAGS := -mthumb -Wl,-Map=$(SYMBOL_MAP) -Wl,--start-group -larm_cortexM4lf_math_softfp -lm
LD_FLAGS += -Wl,--end-group -L"src/ASF/thirdparty/CMSIS/Lib/GCC"  -Wl,--gc-sections
LD_FLAGS += $(LD_SECT_START)
LD_FLAGS += -mcpu=cortex-m4 -Wl,--entry=Reset_Handler -Wl,--cref -mthumb -T$(LD_FILE)

.PHONY: print_config

all: print_config $(OUTPUT)

print_config:
	@echo "######## Source files ########"
	@$(foreach f, $(CXX_FILES), echo $(f);)
	@echo "######## Object files ########"
	@$(foreach f, $(OBJ_FILES), echo $(f);)
	@echo "######## Include path ########"	
	@$(foreach f, $(INC_FOLDER), echo $(f);)
	@echo "######## Compiler out ########"
	@echo $(CC) -c $(C_FLAGS) $(INC_FOLDER) $< -o $@
	@echo "######## Linkerrr out ########"
	@echo $(LD) $(C_FLAGS) $(LD_FLAGS) $(INC_FOLDER) -o $@ $^ -Wl,-Map,$(SYMBOL_MAP)
$(OUTPUT): $(OBJ_FILES)
	@echo "######## LINKING ########"
	$(LD) $(LD_FLAGS) $(INC_FOLDER) -o $@ $^ -Wl,-Map,$(SYMBOL_MAP)

%.o: %.c
	@echo "######## Compiling $< ########"
	$(CC) -c $(C_FLAGS) $(INC_FOLDER) $< -o $@
