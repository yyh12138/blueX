PROJECT_NAME     := injectable
TARGETS          := nrf52840_xxaa
OUTPUT_DIRECTORY := build
DIST_DIRECTORY 	 := dist
SDK_ROOT	 := ~/nRF5_SDK_17.1.0_ddde560


ifeq ($(PLATFORM),)
    PLATFORM = BOARD_MDK_DONGLE
endif

SUPPORTED_PLATFORMS = BOARD_PCA10059 BOARD_MDK_DONGLE

ifeq ($(filter $(PLATFORM), $(SUPPORTED_PLATFORMS)),)
    $(error "PLATFORM not in $(SUPPORTED_PLATFORMS)")
endif

ifeq ($(PLATFORM),BOARD_PCA10059)
    LINKER_FILE := config/pca10059/pca10059.ld
    CONF_DIR := config/pca10059
    
	# C flags common to all targets
	CFLAGS += $(OPT)
	CFLAGS += -DAPP_TIMER_V2
	CFLAGS += -DAPP_TIMER_V2_RTC1_ENABLED
	CFLAGS += -DBOARD_PCA10059
	CFLAGS += -DCONFIG_GPIO_AS_PINRESET
	CFLAGS += -DFLOAT_ABI_HARD
	CFLAGS += -DNRF52840_XXAA
	CFLAGS += -mcpu=cortex-m4
	CFLAGS += -mthumb -mabi=aapcs
	CFLAGS += -Wall
	CFLAGS += -mfloat-abi=hard -mfpu=fpv4-sp-d16
	# keep every function in a separate section, this allows linker to discard unused ones
	CFLAGS += -ffunction-sections -fdata-sections -fno-strict-aliasing
	CFLAGS += -fno-builtin -fshort-enums

	# C++ flags common to all targets
	CXXFLAGS += $(OPT)
	# Assembler flags common to all targets
	ASMFLAGS += -g3
	ASMFLAGS += -mcpu=cortex-m4
	ASMFLAGS += -mthumb -mabi=aapcs
	ASMFLAGS += -mfloat-abi=hard -mfpu=fpv4-sp-d16
	ASMFLAGS += -DAPP_TIMER_V2
	ASMFLAGS += -DAPP_TIMER_V2_RTC1_ENABLED
	ASMFLAGS += -DBOARD_PCA10059
	ASMFLAGS += -DCONFIG_GPIO_AS_PINRESET
	ASMFLAGS += -DFLOAT_ABI_HARD
	ASMFLAGS += -DNRF52840_XXAA
	
	SRC_FILES += $(SDK_ROOT)/components/libraries/timer/app_timer2.c
	SRC_FILES += $(SDK_ROOT)/components/libraries/timer/drv_rtc.c
endif

ifeq ($(PLATFORM),BOARD_MDK_DONGLE)
    LINKER_FILE := config/mdk-dongle/mdk-dongle.ld
    CONF_DIR := config/mdk-dongle
    MDK_MOUNTPOINT := $(shell mount | grep UF2BOOT | awk '{print $$3}')
    
	# C flags common to all targets
	CFLAGS += $(OPT)
	CFLAGS += -DBOARD_CUSTOM
	CFLAGS += -DNRF52840_MDK_DONGLE
	#CFLAGS += -DCONFIG_GPIO_AS_PINRESET
	CFLAGS += -DFLOAT_ABI_HARD
	CFLAGS += -DNRF52840_XXAA
	CFLAGS += -DSWI_DISABLE0
	CFLAGS += -mcpu=cortex-m4
	CFLAGS += -mthumb -mabi=aapcs
	CFLAGS += -Wall -Werror
	CFLAGS += -mfloat-abi=hard -mfpu=fpv4-sp-d16
	# keep every function in a separate section, this allows linker to discard unused ones
	CFLAGS += -ffunction-sections -fdata-sections -fno-strict-aliasing
	CFLAGS += -fno-builtin -fshort-enums

	# C++ flags common to all targets
	CXXFLAGS += $(OPT)

	# Assembler flags common to all targets
	ASMFLAGS += -g3
	ASMFLAGS += -mcpu=cortex-m4
	ASMFLAGS += -mthumb -mabi=aapcs
	ASMFLAGS += -mfloat-abi=hard -mfpu=fpv4-sp-d16
	ASMFLAGS += -DBOARD_CUSTOM
	ASMFLAGS += -DNRF52840_MDK_DONGLE
	#ASMFLAGS += -DCONFIG_GPIO_AS_PINRESET
	ASMFLAGS += -DDEBUG
	ASMFLAGS += -DDEBUG_NRF
	ASMFLAGS += -DFLOAT_ABI_HARD
	ASMFLAGS += -DNRF52840_XXAA
	ASMFLAGS += -DSWI_DISABLE0	
	
	SRC_FILES += $(SDK_ROOT)/components/libraries/timer/app_timer.c
endif



ifneq ($(MAKECMDGOALS),send)
PROJ_DIR := src
#CONF_DIR := config
$(OUTPUT_DIRECTORY)/nrf52840_xxaa.out: \
  LINKER_SCRIPT  := $(LINKER_FILE)

# Source files common to all targets
SRC_FILES += \
	$(SDK_ROOT)/modules/nrfx/mdk/gcc_startup_nrf52840.S \
	$(SDK_ROOT)/components/libraries/log/src/nrf_log_backend_rtt.c \
	$(SDK_ROOT)/components/libraries/log/src/nrf_log_backend_serial.c \
	$(SDK_ROOT)/components/libraries/log/src/nrf_log_backend_uart.c \
	$(SDK_ROOT)/components/libraries/log/src/nrf_log_default_backends.c \
	$(SDK_ROOT)/components/libraries/log/src/nrf_log_frontend.c \
	$(SDK_ROOT)/components/libraries/log/src/nrf_log_str_formatter.c \
	$(SDK_ROOT)/components/boards/boards.c \
	$(SDK_ROOT)/components/libraries/util/app_error.c \
	$(SDK_ROOT)/components/libraries/util/app_error_handler_gcc.c \
	$(SDK_ROOT)/components/libraries/util/app_error_weak.c \
	$(SDK_ROOT)/components/libraries/uart/app_uart_fifo.c \
	$(SDK_ROOT)/components/libraries/usbd/app_usbd.c \
	$(SDK_ROOT)/components/libraries/usbd/class/cdc/acm/app_usbd_cdc_acm.c \
	$(SDK_ROOT)/components/libraries/usbd/app_usbd_core.c \
	$(SDK_ROOT)/components/libraries/usbd/app_usbd_serial_num.c \
	$(SDK_ROOT)/components/libraries/usbd/app_usbd_string_desc.c \
	$(SDK_ROOT)/components/libraries/util/app_util_platform.c \
	$(SDK_ROOT)/components/libraries/hardfault/nrf52/handler/hardfault_handler_gcc.c \
	$(SDK_ROOT)/components/libraries/hardfault/hardfault_implementation.c \
	$(SDK_ROOT)/components/libraries/util/nrf_assert.c \
	$(SDK_ROOT)/components/libraries/atomic_fifo/nrf_atfifo.c \
	$(SDK_ROOT)/components/libraries/atomic/nrf_atomic.c \
	$(SDK_ROOT)/components/libraries/balloc/nrf_balloc.c \
	$(SDK_ROOT)/components/libraries/cli/nrf_cli.c \
	$(SDK_ROOT)/components/libraries/cli/uart/nrf_cli_uart.c \
	$(SDK_ROOT)/external/fprintf/nrf_fprintf.c \
	$(SDK_ROOT)/external/fprintf/nrf_fprintf_format.c \
	$(SDK_ROOT)/components/libraries/memobj/nrf_memobj.c \
	$(SDK_ROOT)/components/libraries/pwr_mgmt/nrf_pwr_mgmt.c \
	$(SDK_ROOT)/components/libraries/queue/nrf_queue.c \
	$(SDK_ROOT)/components/libraries/ringbuf/nrf_ringbuf.c \
	$(SDK_ROOT)/components/libraries/sortlist/nrf_sortlist.c \
	$(SDK_ROOT)/components/libraries/strerror/nrf_strerror.c \
	$(SDK_ROOT)/integration/nrfx/legacy/nrf_drv_clock.c \
	$(SDK_ROOT)/integration/nrfx/legacy/nrf_drv_power.c \
	$(SDK_ROOT)/integration/nrfx/legacy/nrf_drv_uart.c \
	$(SDK_ROOT)/components/drivers_nrf/nrf_soc_nosd/nrf_nvic.c \
	$(SDK_ROOT)/components/drivers_nrf/nrf_soc_nosd/nrf_soc.c \
	$(SDK_ROOT)/modules/nrfx/soc/nrfx_atomic.c \
	$(SDK_ROOT)/modules/nrfx/drivers/src/nrfx_clock.c \
	$(SDK_ROOT)/modules/nrfx/drivers/src/nrfx_gpiote.c \
	$(SDK_ROOT)/modules/nrfx/drivers/src/nrfx_power.c \
	$(SDK_ROOT)/modules/nrfx/drivers/src/prs/nrfx_prs.c \
	$(SDK_ROOT)/modules/nrfx/drivers/src/nrfx_systick.c \
	$(SDK_ROOT)/modules/nrfx/drivers/src/nrfx_uart.c \
	$(SDK_ROOT)/modules/nrfx/drivers/src/nrfx_uarte.c \
	$(SDK_ROOT)/modules/nrfx/drivers/src/nrfx_usbd.c \
	$(SDK_ROOT)/components/libraries/bsp/bsp.c \
	$(SDK_ROOT)/modules/nrfx/mdk/system_nrf52840.c \
	$(PROJ_DIR)/messages/message.cpp \
	$(PROJ_DIR)/messages/response.cpp \
	$(PROJ_DIR)/messages/packet.cpp \
	$(PROJ_DIR)/messages/notification.cpp \
	$(PROJ_DIR)/messages/command.cpp \
	$(PROJ_DIR)/usb.cpp \
	$(PROJ_DIR)/led.cpp \
	$(PROJ_DIR)/time.cpp \
	$(PROJ_DIR)/helpers.cpp \
	$(PROJ_DIR)/radio.cpp \
	$(PROJ_DIR)/controller.cpp \
	$(PROJ_DIR)/controllers/blecontroller.cpp \
	$(PROJ_DIR)/core.cpp \
	$(PROJ_DIR)/main.cpp \

# Include folders common to all targets
INC_FOLDERS += \
	$(SDK_ROOT)/components \
	$(SDK_ROOT)/components/libraries/cli \
	$(SDK_ROOT)/modules/nrfx/mdk \
	$(SDK_ROOT)/components/libraries/scheduler \
	$(SDK_ROOT)/components/libraries/queue \
	$(SDK_ROOT)/components/libraries/pwr_mgmt \
	$(SDK_ROOT)/components/libraries/fifo \
	$(SDK_ROOT)/components/libraries/sortlist \
	$(SDK_ROOT)/components/libraries/strerror \
	$(SDK_ROOT)/components/toolchain/cmsis/include \
	$(SDK_ROOT)/components/libraries/timer \
	$(SDK_ROOT)/components/libraries/util \
	$(SDK_ROOT)/components/libraries/bsp \
	$(PROJ_DIR) \
	$(CONF_DIR) \
	$(SDK_ROOT)/components/libraries/usbd/class/cdc \
	$(SDK_ROOT)/components/libraries/balloc \
	$(SDK_ROOT)/components/libraries/ringbuf \
	$(SDK_ROOT)/components/libraries/hardfault/nrf52 \
	$(SDK_ROOT)/components/libraries/cli/uart \
	$(SDK_ROOT)/components/libraries/hardfault \
	$(SDK_ROOT)/components/libraries/uart \
	$(SDK_ROOT)/components/libraries/log \
	$(SDK_ROOT)/components/libraries/button \
	$(SDK_ROOT)/modules/nrfx \
	$(SDK_ROOT)/components/libraries/experimental_section_vars \
	$(SDK_ROOT)/integration/nrfx/legacy \
	$(SDK_ROOT)/components/libraries/usbd \
	$(SDK_ROOT)/components/libraries/usbd/class/cdc/acm \
	$(SDK_ROOT)/components/libraries/mutex \
	$(SDK_ROOT)/components/libraries/delay \
	$(SDK_ROOT)/external/segger_rtt \
	$(SDK_ROOT)/components/libraries/atomic_fifo \
	$(SDK_ROOT)/components/drivers_nrf/nrf_soc_nosd \
	$(SDK_ROOT)/components/libraries/atomic \
	$(SDK_ROOT)/components/boards \
	$(SDK_ROOT)/components/libraries/memobj \
	$(SDK_ROOT)/external/fnmatch \
	$(SDK_ROOT)/integration/nrfx \
	$(SDK_ROOT)/external/utf_converter \
	$(SDK_ROOT)/modules/nrfx/drivers/include \
	$(SDK_ROOT)/modules/nrfx/hal \
	$(SDK_ROOT)/external/fprintf \
	$(SDK_ROOT)/components/libraries/log/src \

# Libraries common to all targets
LIB_FILES += -lstdc++\

# Optimization flags
OPT = -O3 -g3
# Uncomment the line below to enable link time optimization
#OPT += -flto

# Linker flags
LDFLAGS += $(OPT)
LDFLAGS += -mthumb -mabi=aapcs -L$(SDK_ROOT)/modules/nrfx/mdk -T$(LINKER_SCRIPT)
LDFLAGS += -mcpu=cortex-m4
LDFLAGS += -mfloat-abi=hard -mfpu=fpv4-sp-d16
# let linker dump unused sections
LDFLAGS += -Wl,--gc-sections
# use newlib in nano version
LDFLAGS += --specs=nano.specs

nrf52840_xxaa: CFLAGS += -D__HEAP_SIZE=8192
nrf52840_xxaa: CFLAGS += -D__STACK_SIZE=8192
nrf52840_xxaa: ASMFLAGS += -D__HEAP_SIZE=8192
nrf52840_xxaa: ASMFLAGS += -D__STACK_SIZE=8192

# Add standard libraries at the very end of the linker input, after all objects
# that may need symbols provided by these libraries.
LIB_FILES += -lc -lnosys -lm


.PHONY: default help


# Default target - first one defined
default: nrf52840_xxaa
ifeq ($(PLATFORM),BOARD_PCA10059)
	cp $(OUTPUT_DIRECTORY)/nrf52840_xxaa.hex $(DIST_DIRECTORY)/pca10059.hex
endif
ifeq ($(PLATFORM),BOARD_MDK_DONGLE)
	cp $(OUTPUT_DIRECTORY)/nrf52840_xxaa.hex $(DIST_DIRECTORY)/mdk-dongle.hex
endif
# Print all targets that can be built
help:
	@echo following targets are available:
	@echo		nrf52840_xxaa
	@echo		sdk_config - starting external tool for editing sdk_config.h
	@echo		flash      - flashing binary

TEMPLATE_PATH := $(SDK_ROOT)/components/toolchain/gcc


include $(TEMPLATE_PATH)/Makefile.common

$(foreach target, $(TARGETS), $(call define_target, $(target)))
endif

.PHONY: flash erase

create_builddir:
	mkdir -p build

send: create_builddir
ifeq ($(PLATFORM),BOARD_PCA10059)
	@echo "Generating DFU package ..."
	rm -f $(OUTPUT_DIRECTORY)/dfu.zip
	nrfutil pkg generate --hw-version 52 --sd-req 0x00 --debug-mode --application $(DIST_DIRECTORY)/pca10059.hex $(OUTPUT_DIRECTORY)/dfu.zip
	@echo "Flashing device ..."
	nrfutil dfu usb-serial -pkg $(OUTPUT_DIRECTORY)/dfu.zip -p /dev/ttyACM0 -b 115200
	@echo "Done :)"
endif
ifeq ($(PLATFORM),BOARD_MDK_DONGLE)
ifneq ($(MDK_MOUNTPOINT),)
	@echo "Generating DFU package ..."
	rm -f $(OUTPUT_DIRECTORY)/flash.uf2
	python3 $(CONF_DIR)/uf2conv.py $(DIST_DIRECTORY)/mdk-dongle.hex -c -f 0xADA52840 -o $(OUTPUT_DIRECTORY)/flash.uf2
	@echo "Flashing device ..."
	cp $(OUTPUT_DIRECTORY)/flash.uf2 $(MDK_MOUNTPOINT)
	@echo "Done :)"
endif
ifeq ($(MDK_MOUNTPOINT),)
	@echo "Mountpoint not detected, aborting ..."
endif
endif

