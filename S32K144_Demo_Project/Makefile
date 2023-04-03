#######################################################################################################################
# VARIABLE
#######################################################################################################################
PRO_DIR		:= .
PROJ_NAME	:= S32K144_DEMO
OUTPUT_DIR  := output
BIN_DIR     := $(OUTPUT_DIR)/bin
BUILD_DIR   := $(OUTPUT_DIR)/build
MAP_DIR     := $(OUTPUT_DIR)/map

# All path of directory contain the headers '.h' participating in the build are defined here
INC_DIRS := $(PRO_DIR)/include
INC_DIRS += $(PRO_DIR)/src/App/LED
INC_DIRS += $(PRO_DIR)/src/Drivers/Clock
INC_DIRS += $(PRO_DIR)/src/Drivers/GPIO
INC_DIRS += $(PRO_DIR)/src/Drivers/CAN
INC_DIRS += $(PRO_DIR)/src/Drivers/interrupt
INC_DIRS += $(PRO_DIR)/src/Drivers/PIT
INC_DIRS += $(PRO_DIR)/src/Drivers/PMC
INC_DIRS += $(PRO_DIR)/src/Drivers/RTC
INC_DIRS += $(PRO_DIR)/src/Drivers/WDog
INC_DIRS += $(PRO_DIR)/src/System/Init
INC_DIRS += $(PRO_DIR)/src/System/Sch
INC_DIRS += $(PRO_DIR)/src/System/Task

# All path of directory contain the sources '.c' participating in the build are defined here
SRC_DIRS := $(PRO_DIR)/src/System/Init
SRC_DIRS += $(PRO_DIR)/src/System/Sch
SRC_DIRS += $(PRO_DIR)/src/System/Task
SRC_DIRS += $(PRO_DIR)/src/App/LED
SRC_DIRS += $(PRO_DIR)/src/Drivers/Clock
SRC_DIRS += $(PRO_DIR)/src/Drivers/GPIO
SRC_DIRS += $(PRO_DIR)/src/Drivers/CAN
SRC_DIRS += $(PRO_DIR)/src/Drivers/interrupt
SRC_DIRS += $(PRO_DIR)/src/Drivers/PIT
SRC_DIRS += $(PRO_DIR)/src/Drivers/PMC
SRC_DIRS += $(PRO_DIR)/src/Drivers/RTC
SRC_DIRS += $(PRO_DIR)/src/Drivers/WDog
SRC_DIRS += $(PRO_DIR)/Project_Settings/Startup_Code
SRC_DIRS += $(PRO_DIR)/src

# All path of directory contain the file startup '.S' participating in the build are defined here
S_DIRD          := $(PRO_DIR)/Project_Settings/Startup_Code

# List of all source files participating in the build project
SRC_FILES       := $(foreach SRC_DIRS,$(SRC_DIRS),$(wildcard $(SRC_DIRS)/*.c))
# List of all header files participating in the build project
INCLUDE_FILES   := $(foreach INC_DIRS,$(INC_DIRS),$(wildcard $(INC_DIRS)/*.h))
# List of all startup files participating in the build project
S_FILES  		:= $(foreach S_DIRD,$(S_DIRD),$(wildcard $(S_DIRD)/*.S))

# Linker file for S32K144
LINKER_FILE	    := $(PRO_DIR)/Project_Settings/Linker_Files/S32K144_64_ram.ld
# Path of complier use to build project
COMPILER_DIR 	:= C:/NXP/S32DS_ARM_v2.2/S32DS/build_tools/gcc_v6.3/gcc-6.3-arm32-eabi
# Environment variable used to specify the compiler for the source files used in the compilation process
CC				:= $(COMPILER_DIR)/bin/arm-none-eabi-gcc
# Environment variable used to specify the linker for the source files used in the compilation process
LD				:= $(COMPILER_DIR)/bin/arm-none-eabi-ld
# Environment variable used to specify the assembler for the source files used in the compilation process
AS				:= $(COMPILER_DIR)/bin/arm-none-eabi-gcc

#---------------------------------------------------------------------------------------------------------------------#
# CFLAGS is an environment variable used in the C compilation process to specify additional flags
# to be passed to the C compiler
# -I : specify include directories
#---------------------------------------------------------------------------------------------------------------------#
CFLAGS          := -I

#---------------------------------------------------------------------------------------------------------------------#
# DEPFLAGS is an environment variable used in the makefile dependency generation process
# to specify additional flags to be passed to the compiler when generating the dependency files.
# -MMD: generate dependency files with a .d extension
# -MP : generate phony targets for each dependency to prevent build errors due to missing header files
# -MF : specifies the file name for the dependency file
# -MT : specify the target name for the generated dependency
#---------------------------------------------------------------------------------------------------------------------#
DEPFLAGS        = -MMD -MP -MF"$(@:%.o=%.d)" -MT

# List of include directories with flag -I
INC_DIRS_OPT    := $(foreach INC_DIRS,$(INC_DIRS), $(CFLAGS)$(INC_DIRS))

#---------------------------------------------------------------------------------------------------------------------#
# CCOPT is a makefile variable that contains the compiler options to be passed to the CC compiler
# when building the project
# -mcpu=cortex-m4: specifies the target processor architecture as ARM Cortex-M4.
# -c: specifies that the compiler should only generate object files and not attempt to link them into an executable.
# -O0: specifies that no optimization should be performed.
# -g: includes debug information in the object files.
# -mthumb: generates code in Thumb instruction set mode, which is more suitable for embedded systems.
# -Wall: enables all warning messages.
# -DDEBUG: defines the DEBUG preprocessor macro.
# -DCPU_S32K144HFT0VLLT: defines the CPU_S32K144HFT0VLLT preprocessor macro.
#---------------------------------------------------------------------------------------------------------------------#
CCOPT			:= -mcpu=cortex-m4 -c -O0 -g -mthumb -Wall -DDEBUG -DCPU_S32K144HFT0VLLT  $(INC_DIRS_OPT)

#---------------------------------------------------------------------------------------------------------------------#
# LDOPT is a variable used to specify options for the linker when generating the final output file
# -T option is used to specify the linker script file that defines the memory layout and sections of the output file
# $(LINKER_FILE) is a variable that holds the path to the linker script file.
# -Map option is used to generate a memory map of the output file
# $(MAP_DIR) is a variable that holds the directory where the map file should be generated
# $(PROJ_NAME) is a variable that holds the name of the project or output file.
#---------------------------------------------------------------------------------------------------------------------#
LDOPT			:= -T $(LINKER_FILE) -Map $(MAP_DIR)/$(PROJ_NAME).map

#---------------------------------------------------------------------------------------------------------------------#
# # ASOPT is a variable used to store the command line option for the assembler
# -mcpu=cortex-m4: specifies the target architecture for the assembler.
# -g: includes debug information in the object file.
# -mthumb: generates code in Thumb mode.
# -x assembler-with-cpp: specifies that the assembler should handle the input files as assembly files
# with preprocessor directives.
#---------------------------------------------------------------------------------------------------------------------#
ASOPT			:= -mcpu=cortex-m4 -g -mthumb -x assembler-with-cpp

# List of all object files participating in the build project
OJB_FILES       := $(notdir $(SRC_FILES))
OJB_FILES       := $(subst .c,.o,$(OJB_FILES))
# List of all startup files participating in the build project
S_FILES         := $(notdir $(S_FILES))
OJB_S_FILE      := $(subst .S,.o,$(S_FILES))

# List of path for all object files participating in the build project
PATH_OJBS       := $(foreach OJB_FILES,$(OJB_FILES),$(BUILD_DIR)/$(OJB_FILES))

#######################################################################################################################
# VPATH
#######################################################################################################################
vpath %.c $(SRC_DIRS)
vpath %.h $(INC_DIRS)
vpath %.S $(S_DIRD)

#######################################################################################################################
# TARGET
#######################################################################################################################
# All Target
all: build

# Build Target
build: $(BIN_DIR) $(BUILD_DIR) $(MAP_DIR) $(PROJ_NAME).elf $(PROJ_NAME).siz

$(BIN_DIR):
	@mkdir -p $@

$(BUILD_DIR):
	@mkdir -p $@

$(MAP_DIR):
	@mkdir -p $@

$(PROJ_NAME).elf: $(PATH_OJBS) $(LINKER_FILE) $(BUILD_DIR)/$(OJB_S_FILE)
	@echo 'Building target: $@'
	@echo 'Invoking: GCC compiler'
	$(LD) $(LDOPT) $(PATH_OJBS) -o $(BIN_DIR)/$(PROJ_NAME).elf
	$(COMPILER_DIR)/arm-none-eabi/bin/objcopy.exe -O ihex "$(BIN_DIR)/$(PROJ_NAME).elf" "$(BIN_DIR)/$(PROJ_NAME).hex"
	$(COMPILER_DIR)/arm-none-eabi/bin/objcopy.exe -O binary "$(BIN_DIR)/$(PROJ_NAME).elf" "$(BIN_DIR)/$(PROJ_NAME).bin"
	@echo 'Finished building target: $(PROJ_NAME).elf'
	@echo ' '

$(PROJ_NAME).siz:
	@echo 'Invoking: Print Size'
	size --format=berkeley $(OUTPUT_DIR)/bin/$(PROJ_NAME).elf
	@echo 'Finished building : $@'

$(BUILD_DIR)/%.o: %.c $(INCLUDE_FILES)
	@echo 'Building file: $<'
	@echo 'Invoking: GCC compiler'
	$(CC) $(CCOPT) $(DEPFLAGS)  $@ -o $@ $<
	@echo 'Finished building: $<'
	@echo ' '

$(BUILD_DIR)/$(OJB_S_FILE): $(S_DIRD)/$(S_FILES)
	@echo 'Building file: $<'
	@echo 'Invoking: GCC compiler'
	$(AS) $(ASOPT) -c $< -o $@
	@echo 'Finished building: $<'
	@echo ' '

# Clean Target
clean:
	rm -rf $(BIN_DIR)/* $(BUILD_DIR)/* $(MAP_DIR)/*
	@echo ' '

.PHONY: clean build all
#######################################################################################################################
# EOF
#######################################################################################################################
