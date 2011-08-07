################################################################################
#
# Makefile
#
# Makefile for Android project integrated with NLCP
#
# Android Version	:	L27.INC1.13.1 OMAP4 GingerBread ES2
# Platform	     	:	Blaze platform es2.2
# Date				:	July 2011
#
# Copyright (C) 2011 Texas Instruments Incorporated - http://www.ti.com/
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
# 	http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and  
# limitations under the License.
#
################################################################################

MAKEFLAGS += --no-print-directory
SHELL=/bin/bash

include defs.mk
include $(WIIST_PATH)/utils.mk
include $(WIIST_PATH)/repo.mk

.PHONY: all install clean distclean help update-internals

help:
	@cat $(WIIST_PATH)/README
	
update-internals:
ifneq (INTERNALS_PATH, "")
	@$(ECHO) "updating $(WIIST_PATH) with internals..."
	@$(COPY) -rf $(INTERNALS_PATH)/* $(WIIST_PATH)/
endif

bringup: update-internals
	@$(MKDIR) -p $(TRASH_DIR)
	@$(MKDIR) -p $(PROGRESS_DIR)
	@$(MAKE) ti-st-pre-bringup-validation
	@$(MAKE) bt-pre-bringup-validation
	@$(MAKE) gps-pre-bringup-validation
	@$(MAKE) fm-pre-bringup-validation
	@$(MAKE) nlcp-pre-bringup-validation
	
	@$(MAKE) mydroid-bringup
	@$(MAKE) kernel-bringup
	@$(MAKE) u-boot-bringup
	@$(MAKE) x-loader-bringup
	
	@$(MAKE) nlcp-bringup
	@$(MAKE) ti-st-bringup
	@$(MAKE) bt-bringup
	@$(MAKE) gps-bringup	
	@$(MAKE) fm-bringup
	
	@$(call echo-to-file, "BRINGUP DONE", bringup)
	@$(call print, "BRINGUP DONE")
	@$(call print, "The bringup process took $$(( $(call GET_TIME)-$(MAKE_START_TIME) )) seconds")

all: bringup
	@$(MKDIR) -p $(PROGRESS_DIR)
	@if [ -d $(OUTPUT_PATH) ] ; then $(ECHO) removing $(OUTPUT_PATH) directory ; $(DEL) -rf $(OUTPUT_PATH) ; fi

	$(MAKE) u-boot-make
	$(MAKE) x-loader-make
	$(MAKE) kernel-make
	$(MAKE) nlcp-make
	$(MAKE) mydroid-make
	$(MAKE) ti-st-make
	$(MAKE) bt-make
	$(MAKE) gps-make
	$(MAKE) fm-make
	
	@$(call print, "MAKE ALL DONE")
	@$(call print, "The build process took $$(( $(call GET_TIME)-$(MAKE_START_TIME) )) seconds")

install: all
	$(MAKE) install-only
	@$(call print, "The install process took $$(( $(call GET_TIME)-$(MAKE_START_TIME) )) seconds")

install-only:
	@if [ -d $(OUTPUT_PATH) ] ; then $(ECHO) removing $(OUTPUT_PATH) directory ; $(DEL) -rf $(OUTPUT_PATH) ; fi
	@$(MKDIR) -p $(BOOT_PATH)
	@$(MKDIR) -p $(MYFS_PATH)
	@$(MKDIR) -p $(EMMC_PATH)

	$(MAKE) u-boot-install
	$(MAKE) x-loader-install
	$(MAKE) kernel-install
	$(MAKE) mydroid-install
	$(MAKE) nlcp-install
	$(MAKE) ti-st-install
	$(MAKE) bt-install
	$(MAKE) gps-install
	$(MAKE) fm-install

	$(MAKE) pack-sd-fs
	@$(call print, "INSTALL DONE")

pack-sd-fs:
	@cd $(OUTPUT_PATH_SD) ; $(TAR) cf $(OUTPUT_PATH_SD)/$(VERSION).sd.tar *
	@cd $(OUTPUT_PATH_SD)/rootfs ; $(TAR) cf $(OUTPUT_PATH_SD)/rootfs.tar *
	@cd $(OUTPUT_PATH_SD)/boot ; $(TAR) cf $(OUTPUT_PATH_SD)/boot.tar *
	
$(OUTPUT_PATH_SD)/$(VERSION).sd.tar:
	$(MAKE) install
	
create-images: $(OUTPUT_PATH_SD)/$(VERSION).sd.tar
	@if [ -d $(EMMC_PATH) ] ; then $(DEL) -rf $(EMMC_PATH) ; fi
	$(MKDIR) -p $(EMMC_PATH)
	$(COPY) -f $(MYDROID)/out/host/linux-x86/bin/fastboot $(EMMC_PATH)
	$(COPY) -f $(MYDROID)/out/host/linux-x86/bin/mkbootimg $(EMMC_PATH)
	$(COPY) -f $(BOOT_PATH)/u-boot.bin $(EMMC_PATH)
	$(COPY) -f $(BOOT_PATH)/MLO* $(EMMC_PATH)
	$(COPY) -f $(KERNEL_DIR)/arch/arm/boot/zImage $(EMMC_PATH)
#	$(FIND) $(OUTPUT_IMG_DIR) -name *.img | xargs rm
	$(FIND) $(OUTPUT_IMG_DIR) -name *.img -exec rm -f {} \;
	# echo instead of just copy since there are ommited directories (which causes errors)
	$(ECHO) `$(COPY) $(MYFS_PATH)/* $(OUTPUT_IMG_DIR)/root`
	$(COPY) -rf $(MYFS_PATH)/system/* $(OUTPUT_IMG_DIR)/system
	$(COPY) -rf $(MYFS_PATH)/data/* $(OUTPUT_IMG_DIR)/data	
	$(MAKE) mydroid-make
	$(COPY) -f $(OUTPUT_IMG_DIR)/*.img $(EMMC_PATH)	
	cd $(EMMC_PATH) ; ./mkbootimg --kernel zImage --ramdisk ramdisk.img --base 0x80000000 --cmdline "console=ttyO2,115200n8 rootdelay=2 mem=456M@0x80000000 mem=512M@0xA0000000 init=/init vram=10M omapfb.vram=0:4M androidboot.console=ttyO2" --board omap4 -o boot.img
	cd $(EMMC_PATH) ; dd if=/dev/zero of=./cache.img bs=1048510 count=128
	cd $(EMMC_PATH) ; $(MKFS_EXT4) -F cache.img -L cache
	
	@$(call print, "eMMC IMAGES CREATION DONE")
	@$(call print, "creation of images took $$(( $(call GET_TIME)-$(MAKE_START_TIME) )) seconds")	

clean: bringup
	@if [ -d $(OUTPUT_PATH) ] ; then $(ECHO) removing $(OUTPUT_PATH) directory ; $(DEL) -rf $(OUTPUT_PATH) ; fi

	$(MAKE) u-boot-clean
	$(MAKE) x-loader-clean
	$(MAKE) kernel-clean
	$(MAKE) mydroid-clean
	$(MAKE) nlcp-clean
	$(MAKE) ti-st-clean
	$(MAKE) bt-clean
	$(MAKE) gps-clean
	$(MAKE) fm-clean
	
	@$(call print, "CLEAN DONE")
	@$(call print, "The clean process took $$(( $(call GET_TIME)-$(MAKE_START_TIME) )) seconds")
	
distclean:
	@if [ -f bringup ] ; then $(DEL) -rf bringup ; fi
	@if [ -d $(PROGRESS_DIR) ] ; then $(ECHO) removing $(PROGRESS_DIR) directory ; $(DEL) -rf $(PROGRESS_DIR) ; fi
	@if [ -d $(OUTPUT_PATH) ] ; then $(ECHO) removing $(OUTPUT_PATH) directory ; $(DEL) -rf $(OUTPUT_PATH) ; fi
	@if [ -d $(MANIFEST) ] ; then $(ECHO) removing $(MANIFEST) directory ; $(DEL) -rf $(MANIFEST) ; fi
	@if [ -d $(WORKSPACE_DIR) ] ; then $(ECHO) removing $(WORKSPACE_DIR) directory ; $(DEL) -rf $(WORKSPACE_DIR) ; fi
	@$(ECHO) synchronizing...
	@sync &
	@$(call print, "DISTCLEAN DONE")
	@$(call print, "The distclean process took $$(( $(call GET_TIME)-$(MAKE_START_TIME) )) seconds")

include $(WIIST_PATH)/rules.mk
include $(WIIST_PATH)/wiist.mk

include $(MAKEFILES_PATH)/ti-st.mk
include $(MAKEFILES_PATH)/bt.mk
include $(MAKEFILES_PATH)/gps.mk
include $(MAKEFILES_PATH)/fm.mk
include $(MAKEFILES_PATH)/nlcp.mk
