#   Copyright (c) 2019 by Plexim GmbH
#   All rights reserved.
#
#   A free license is granted to anyone to use this software for any legal
#   non safety-critical purpose, including commercial applications, provided
#   that:
#   1) IT IS NOT USED TO DIRECTLY OR INDIRECTLY COMPETE WITH PLEXIM, and
#   2) THIS COPYRIGHT NOTICE IS PRESERVED in its entirety.
#
#   THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS
#   OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
#   FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
#   AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
#   LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
#   OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
#   SOFTWARE.

include LaunchPad_sources.mk

TARGET_ROOT=/Applications/Coder Targets/ti_c2000/ccs/2837x
TOOLS_PATH=/Applications/ti/ti-cgt-c2000_20.12.0.STS
BIN_DIR=./output_TI2837xS
OUT_NAME=LaunchPad
MAKEFILE=LaunchPad.mk
LINKFILE=LaunchPad.lkf
INSTALL_DIR=./
BASE_NAME=LaunchPad
CCXML_FILE=/Applications/Coder Targets/ti_c2000/templates/uniflash/Launchpad_TMS320F28377S.ccxml
FLASH_EXE=/Applications/ti/uniflash_6.2.0/dslite.sh
BUILD_CONFIG=FLASH
AUTO_START_OPTION=-u

##############################################################

C_SOURCE_FILES=\
main.c\
pil_symbols_c.c\
pil_symbols_p.c\
F2837xS_Adc.c\
F2837xS_DefaultISR.c\
F2837xS_DevInit.c\
F2837xS_GlobalVariableDefs.c\
F2837xS_Gpio.c\
ain_2837x.c \
dio_2837x.c \
dispatcher_2837x.c \
gatedriver_basic.c \
hal_2837x.c \
power.c \
pwm_2837x.c \
qep_2837x.c \
sci_2837x.c \
spi_2837x.c \
dac_2837x.c \
cap_2837x.c \
canbus_2837x.c \
can.c \
sysctl.c \
interrupt.c

ASM_SOURCE_FILES=\
F2837xS_CodeStartBranch.asm\
F2837xS_usDelay.asm

HFILES=\
LaunchPad_probes_cg.h \
LaunchPad_settings_cg.h \
LaunchPad_settings.inc

##############################################################
space:=
space+=
# for MacOS - NOTE: not tolerant to leading spaces or already escaped spaces '\ '
EscapeSpaces=$(subst $(space),\$(space),$(1))
FlipSlashesBack=$(subst /,\,$(1))

ifeq ($(OS),Windows_NT)
# Windows
SHELL := cmd.exe
FixPath=$(call FlipSlashesBack,$(1))
ClearDir=del /F /Q "$(call FlipSlashesBack,$(1))\*.*"
MoveFile=move /Y "$(call FlipSlashesBack,$(1))" "$(call FlipSlashesBack,$(2))"
CopyFile=copy /Y "$(call FlipSlashesBack,$(1))" "$(call FlipSlashesBack,$(2))"

else
# Linux style
FixPath = $(1)
ClearDir=rm -Rf $(call EscapeSpaces,$(1))/*
MoveFile=mv $(call EscapeSpaces,$(1)) $(call EscapeSpaces,$(2))
CopyFile=cp $(call EscapeSpaces,$(1)) $(call EscapeSpaces,$(2))

endif 

CGT_EXE_PATH=$(TOOLS_PATH)/BIN
CGT_LIB_PATH=$(TOOLS_PATH)/LIB
CGT_INC_PATH=$(TOOLS_PATH)/INCLUDE

BIN_DIR_OS=$(call FixPath,$(BIN_DIR))

# compiler / assembler
C_OPTIONS=\
-D_PLEXIM_\
-DCPU1\
-DBASE_NAME=$(BASE_NAME)\
-DEXTERNAL_MODE=1\
-fr$(BIN_DIR)\
-fs$(BIN_DIR)\
-v28 \
-ml \
-mt \
--float_support=fpu32 \
-O0 \
--include_path="$(TARGET_ROOT)/app" \
--include_path="$(TARGET_ROOT)/../pil" \
--include_path="$(TARGET_ROOT)/../shrd" \
--include_path="$(TARGET_ROOT)/../inc" \
--include_path="$(TARGET_ROOT)/inc_impl" \
--include_path="$(TARGET_ROOT)/tiinc" \
--include_path="$(TARGET_ROOT)/tiinc/driverlib" \
--include_path="$(TOOLS_PATH)/include" \
--include_path="./" \
-g \
--gcc \
--diag_warning=225

ifeq ($(BUILD_CONFIG),FLASH)
C_OPTIONS += -D_FLASH
endif

L_OPTIONS=$(LINKFILE)

C_OBJFILES=$(patsubst %.c, $(BIN_DIR)/%.obj, $(C_SOURCE_FILES)) $(patsubst %.c, $(BIN_DIR)/%.obj, $(SOURCE_FILES))
ASM_OBJFILES=$(patsubst %.asm, $(BIN_DIR)/%.obj, $(ASM_SOURCE_FILES))

OBJFILES=$(C_OBJFILES) $(ASM_OBJFILES)

# make all variables available to sub-makes
export

# Top level 
##########################################################################
all:
ifneq ($(wildcard $(BIN_DIR_OS)),  $(BIN_DIR_OS))
	"$(MAKE)" -f $(MAKEFILE) clean
endif
	"$(MAKE)" -f $(MAKEFILE) $(BIN_DIR)/$(OUT_NAME).elf
	
# Download
##########################################################################rm C
$(BIN_DIR)/uniflash.ccxml:	$(call EscapeSpaces,$(CCXML_FILE))
							$(call CopyFile,$(CCXML_FILE),$(BIN_DIR)/uniflash.ccxml)

ifneq ($(and $(FLASH_EXE),$(CCXML_FILE)),)
download: $(BIN_DIR)/$(OUT_NAME).out $(BIN_DIR)/uniflash.ccxml
	"$(FLASH_EXE)" --flash --config=$(call FixPath,$(BIN_DIR)/uniflash.ccxml) $(call FixPath,$(BIN_DIR)/$(OUT_NAME).out) $(AUTO_START_OPTION)
else
download:
	@echo "Download not configured."
endif 
 
# Linker
##########################################################################
$(BIN_DIR)/$(OUT_NAME).elf:  $(BIN_DIR)/$(OUT_NAME).out
						$(call CopyFile,$(BIN_DIR)/$(OUT_NAME).out,$(INSTALL_DIR)/$(OUT_NAME).elf)

$(BIN_DIR)/$(OUT_NAME).out:  $(OBJFILES)
						"$(CGT_EXE_PATH)"/cl2000 -z -i"$(CGT_LIB_PATH)" $(OBJFILES) $(L_OPTIONS)

# Implicit Rules for generated files
##########################################################################
$(BIN_DIR)/%.obj:		%.c	$(HFILES)
						"$(CGT_EXE_PATH)"/cl2000 $(C_OPTIONS) $<

# Explicit rules (we must use explicit rules to allow spaces in $(TARGET_ROOT))
##########################################################################
$(BIN_DIR)/main.obj:	$(call EscapeSpaces,$(TARGET_ROOT))/app/main.c $(HFILES)
						"$(CGT_EXE_PATH)"/cl2000 $(C_OPTIONS) "$<"

$(BIN_DIR)/pil_symbols_c.obj:	$(call EscapeSpaces,$(TARGET_ROOT))/app/pil_symbols_c.c $(HFILES)
						"$(CGT_EXE_PATH)"/cl2000 $(C_OPTIONS) "$<"

$(BIN_DIR)/pil_symbols_p.obj:	$(call EscapeSpaces,$(TARGET_ROOT))/app/pil_symbols_p.c $(HFILES)
						"$(CGT_EXE_PATH)"/cl2000 $(C_OPTIONS) "$<"

$(BIN_DIR)/F2837xS_Adc.obj:	$(call EscapeSpaces,$(TARGET_ROOT))/tisrc/F2837xS_Adc.c $(HFILES)
						"$(CGT_EXE_PATH)"/cl2000 $(C_OPTIONS) "$<"

$(BIN_DIR)/F2837xS_DefaultISR.obj:	$(call EscapeSpaces,$(TARGET_ROOT))/tisrc/F2837xS_DefaultISR.c $(HFILES)
						"$(CGT_EXE_PATH)"/cl2000 $(C_OPTIONS) "$<"

$(BIN_DIR)/F2837xS_GlobalVariableDefs.obj:	$(call EscapeSpaces,$(TARGET_ROOT))/tisrc/F2837xS_GlobalVariableDefs.c $(HFILES)
						"$(CGT_EXE_PATH)"/cl2000 $(C_OPTIONS) "$<"

$(BIN_DIR)/F2837xS_DevInit.obj:	$(call EscapeSpaces,$(TARGET_ROOT))/tisrc/F2837xS_DevInit.c $(HFILES)
						"$(CGT_EXE_PATH)"/cl2000 $(C_OPTIONS) "$<"

$(BIN_DIR)/F2837xS_Gpio.obj:	$(call EscapeSpaces,$(TARGET_ROOT))/tisrc/F2837xS_Gpio.c $(HFILES)
						"$(CGT_EXE_PATH)"/cl2000 $(C_OPTIONS) "$<"

$(BIN_DIR)/F2837xS_CodeStartBranch.obj:	$(call EscapeSpaces,$(TARGET_ROOT))/tisrc/F2837xS_CodeStartBranch.asm $(HFILES)
						"$(CGT_EXE_PATH)"/cl2000 $(C_OPTIONS) "$<"

$(BIN_DIR)/F2837xS_usDelay.obj:	$(call EscapeSpaces,$(TARGET_ROOT))/tisrc/F2837xS_usDelay.asm $(HFILES)
						"$(CGT_EXE_PATH)"/cl2000 $(C_OPTIONS) "$<"

$(BIN_DIR)/pwm_2837x.obj:	$(call EscapeSpaces,$(TARGET_ROOT))/src/pwm_2837x.c $(HFILES)
						"$(CGT_EXE_PATH)"/cl2000 $(C_OPTIONS) "$<"

$(BIN_DIR)/ain_2837x.obj:	$(call EscapeSpaces,$(TARGET_ROOT))/src/ain_2837x.c $(HFILES)
						"$(CGT_EXE_PATH)"/cl2000 $(C_OPTIONS) "$<"

$(BIN_DIR)/dio_2837x.obj:	$(call EscapeSpaces,$(TARGET_ROOT))/src/dio_2837x.c $(HFILES)
						"$(CGT_EXE_PATH)"/cl2000 $(C_OPTIONS) "$<"

$(BIN_DIR)/qep_2837x.obj:	$(call EscapeSpaces,$(TARGET_ROOT))/src/qep_2837x.c $(HFILES)
						"$(CGT_EXE_PATH)"/cl2000 $(C_OPTIONS) "$<"

$(BIN_DIR)/dispatcher_2837x.obj:	$(call EscapeSpaces,$(TARGET_ROOT))/src/dispatcher_2837x.c $(HFILES)
						"$(CGT_EXE_PATH)"/cl2000 $(C_OPTIONS) "$<"

$(BIN_DIR)/gatedriver_basic.obj:	$(call EscapeSpaces,$(TARGET_ROOT))/src/gatedriver_basic.c $(HFILES)
						"$(CGT_EXE_PATH)"/cl2000 $(C_OPTIONS) "$<"

$(BIN_DIR)/power.obj:	$(call EscapeSpaces,$(TARGET_ROOT))/src/power.c $(HFILES)
						"$(CGT_EXE_PATH)"/cl2000 $(C_OPTIONS) "$<"

$(BIN_DIR)/hal_2837x.obj:	$(call EscapeSpaces,$(TARGET_ROOT))/src/hal_2837x.c $(HFILES)
						"$(CGT_EXE_PATH)"/cl2000 $(C_OPTIONS) "$<"

$(BIN_DIR)/sci_2837x.obj:	$(call EscapeSpaces,$(TARGET_ROOT))/src/sci_2837x.c $(HFILES)
						"$(CGT_EXE_PATH)"/cl2000 $(C_OPTIONS) "$<"

$(BIN_DIR)/spi_2837x.obj:	$(call EscapeSpaces,$(TARGET_ROOT))/src/spi_2837x.c $(HFILES)
						"$(CGT_EXE_PATH)"/cl2000 $(C_OPTIONS) "$<"

$(BIN_DIR)/dac_2837x.obj:	$(call EscapeSpaces,$(TARGET_ROOT))/src/dac_2837x.c $(HFILES)
						"$(CGT_EXE_PATH)"/cl2000 $(C_OPTIONS) "$<"
						
$(BIN_DIR)/cap_2837x.obj:	$(call EscapeSpaces,$(TARGET_ROOT))/src/cap_2837x.c $(HFILES)
						"$(CGT_EXE_PATH)"/cl2000 $(C_OPTIONS) "$<"
						
$(BIN_DIR)/canbus_2837x.obj:	$(call EscapeSpaces,$(TARGET_ROOT))/src/canbus_2837x.c $(HFILES)
						"$(CGT_EXE_PATH)"/cl2000 $(C_OPTIONS) "$<"
						
$(BIN_DIR)/can.obj:	$(call EscapeSpaces,$(TARGET_ROOT))/tisrc/driverlib/can.c $(HFILES)
						"$(CGT_EXE_PATH)"/cl2000 $(C_OPTIONS) "$<"
						
$(BIN_DIR)/sysctl.obj:	$(call EscapeSpaces,$(TARGET_ROOT))/tisrc/driverlib/sysctl.c $(HFILES)
						"$(CGT_EXE_PATH)"/cl2000 $(C_OPTIONS) "$<"
						
$(BIN_DIR)/interrupt.obj:	$(call EscapeSpaces,$(TARGET_ROOT))/tisrc/driverlib/interrupt.c $(HFILES)
						"$(CGT_EXE_PATH)"/cl2000 $(C_OPTIONS) "$<"

##########################################################################

clean:
ifeq ($(wildcard $(BIN_DIR_OS)),  $(BIN_DIR_OS))
		$(call ClearDir, $(BIN_DIR_OS))
else
		mkdir $(BIN_DIR_OS)
endif
