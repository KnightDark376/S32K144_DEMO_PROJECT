#######################################################################################################################
# VARIABLE
#######################################################################################################################
PRO_DIR		    := .
PROJ_NAME	    := S32K144_DEMO
OUTPUT_DIR      := output
BIN_DIR         := $(OUTPUT_DIR)/bin
BUILD_DIR       := $(OUTPUT_DIR)/build
MAP_DIR         := $(OUTPUT_DIR)/map
SUBDIR_PATH     := $(PRO_DIR)/src/App \
				   $(PRO_DIR)/src/Drivers \
				   $(PRO_DIR)/src/System
SUBDIR          := $(foreach find_folder,$(SUBDIR_PATH), $(wildcard $(find_folder)/*))

MKDIR           := mkdir -p
RM              := rm -rf


# All path of directory contain the headers '.h' participating in the build are defined here
INC_DIRS        := $(PRO_DIR)/include \
			       $(SUBDIR)

# All path of directory contain the sources '.c' participating in the build are defined here
SRC_DIRS        := $(PRO_DIR)/src \
			       $(PRO_DIR)/Project_Settings/Startup_Code \
			       $(SUBDIR)

# List of all source files participating in the build project
SRC_FILES       := $(foreach SRC_DIRS,$(SRC_DIRS),$(wildcard $(SRC_DIRS)/*.c))
SRC_FILES       += $(foreach SRC_DIRS,$(SRC_DIRS),$(wildcard $(SRC_DIRS)/*.S))
# List of all header files participating in the build project
INC_FILES       := $(foreach INC_DIRS,$(INC_DIRS),$(wildcard $(INC_DIRS)/*.h))

# Linker file for S32K144
LINKER_FILE	    := $(PRO_DIR)/Project_Settings/Linker_Files/S32K144_64_ram.ld
# Path of complier use to build project
COMPILER_DIR 	:= C:/NXP/S32DS_ARM_v2.2/S32DS/build_tools/gcc_v6.3/gcc-6.3-arm32-eabi
# Environment variable used to specify the compiler for the source files used in the compilation process
CC				:= $(COMPILER_DIR)/bin/arm-none-eabi-gcc
# Environment variable used to specify the linker for the source files used in the compilation process
LD				:= $(COMPILER_DIR)/bin/arm-none-eabi-gcc
# Environment variable used to specify the assembler for the source files used in the compilation process
AS				:= $(COMPILER_DIR)/bin/arm-none-eabi-gcc

NEWLIB_DIR      := $(COMPILER_DIR)/arm-none-eabi/newlib

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
INC_OPT    := $(foreach INC_DIRS,$(INC_DIRS), -I$(INC_DIRS))

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
CCOPT			:= -mcpu=cortex-m4 -c -Os -g3 -mthumb -Wall -fmessage-length=0 -ffunction-sections -fdata-sections \
                   -specs=nano.specs -specs=nosys.specs --sysroot=$(NEWLIB_DIR) \
				   -DDEBUG -DCPU_S32K144HFT0VLLT -DDEV_ERROR_DETECT  $(INC_OPT)

#---------------------------------------------------------------------------------------------------------------------#
# LDOPT is a variable used to specify options for the linker when generating the final output file
# -T option is used to specify the linker script file that defines the memory layout and sections of the output file
# $(LINKER_FILE) is a variable that holds the path to the linker script file.
# -Map option is used to generate a memory map of the output file
# $(MAP_DIR) is a variable that holds the directory where the map file should be generated
# $(PROJ_NAME) is a variable that holds the name of the project or output file.
#---------------------------------------------------------------------------------------------------------------------#
LDOPT			:= -T $(LINKER_FILE) -Wl,-Map,$(MAP_DIR)/$(PROJ_NAME).map -Xlinker --gc-sections \
                   -n -mcpu=cortex-m4 -ffunction-sections -fdata-sections -specs=nano.specs \
				   -specs=nosys.specs --sysroot=$(NEWLIB_DIR)

# List of all object files participating in the build project
#OJB_FILES       := $(notdir $(SRC_FILES))
#OJB_FILES       := $(subst .c,.o,$(OJB_FILES))
#OJB_FILES       := $(subst .S,.o,$(OJB_FILES))

OBJ_FILES        := $(addprefix $(BUILD_DIR)/, \
						$(patsubst %.c,%.o,\
							$(filter %.c,$(SRC_FILES)))) \
					$(addprefix $(BUILD_DIR)/, \
						$(patsubst %.S,%.o,\
							$(filter %.S,$(SRC_FILES))))


# List of path for all object files participating in the build project
DEPS            := $(patsubst %.o,%.d,$(OBJ_FILES))

#######################################################################################################################
# VPATH
#######################################################################################################################
# Tells Make to look for all .c and .S files in the directories listed in the SRC_DIRS variable.
vpath %.c $(SRC_DIRS)
vpath %.S $(SRC_DIRS)
# Tells Make to look for all .h files in the directories listed in the INC_DIRS variable.
vpath %.h $(INC_DIRS)

#######################################################################################################################
# TARGET
#######################################################################################################################
all: build

$(BUILD_DIR)/%.o: %.c
	@echo 'Building file: $<'
	@echo 'Invoking: GCC compiler'
	@$(MKDIR) $(@D)
	@$(CC) $(CCOPT) $(DEPFLAGS) $@ -o $@ $<
	@echo 'Finished building: $<'
	@echo ' '

$(BUILD_DIR)/%.o: %.S
	@echo 'Building file: $<'
	@echo 'Invoking: GCC compiler'
	@$(MKDIR) $(@D)
	@$(CC) $(CCOPT) $(DEPFLAGS) $@ -o $@ $<
	@echo 'Finished building: $<'
	@echo ' '

-include $(DEPS)


# Build Target
build: $(BIN_DIR) $(MAP_DIR) $(PROJ_NAME).elf $(PROJ_NAME).siz

$(BIN_DIR):
	$(MKDIR) $@

$(MAP_DIR):
	$(MKDIR) $@

$(PROJ_NAME).elf: $(OBJ_FILES) $(LINKER_FILE)
	@echo 'Building target: $@'
	@echo 'Invoking: GCC compiler'
	@$(MKDIR) $(dir $@)
	@$(LD) -o $(BIN_DIR)/$(PROJ_NAME).elf $(LDOPT) $(OBJ_FILES)
	@$(COMPILER_DIR)/arm-none-eabi/bin/objcopy.exe -O ihex "$(BIN_DIR)/$(PROJ_NAME).elf" "$(BIN_DIR)/$(PROJ_NAME).hex"
	@$(COMPILER_DIR)/arm-none-eabi/bin/objcopy.exe -O binary "$(BIN_DIR)/$(PROJ_NAME).elf" "$(BIN_DIR)/$(PROJ_NAME).bin"
	@echo 'Finished building target: $(PROJ_NAME).elf'
	@echo ' '

$(PROJ_NAME).siz:
	@echo 'Invoking: Print Size of file: $@'
	size --format=berkeley $(OUTPUT_DIR)/bin/$(PROJ_NAME).elf
	@echo 'Finished building : $@'

# Clean Target
clean:
#	rm -rf $(BIN_DIR)/* $(BUILD_DIR)/* $(MAP_DIR)/*
	$(RM) $(OUTPUT_DIR)/*
	@echo ' '

log-%:
	@echo $($(subst log-,,$@))

.PHONY: clean build all

#######################################################################################################################
# EOF
#######################################################################################################################
