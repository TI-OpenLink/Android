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

include .config
include defs.mk
include $(WIIST_PATH)/utils.mk
include $(WIIST_PATH)/repo.mk

.PHONY: all install clean distclean help update-internals test

help:
	@cat $(WIIST_PATH)/README

/data/git/repositories/wiist/Android/R4.xx/internals:
	$(error, "internal repository does not exist, are you sure you're in TI's IL network?"
	
update-internals: /data/git/repositories/wiist/Android/R4.xx/internals
	@$(ECHO) getting internals from local repository
	@if [ -d ./.internals ] ; then $(DEL) -rf ./.internals ; fi
	git clone /data/git/repositories/wiist/Android/R4.xx/internals ./.internals
	cd ./.internals ; git checkout origin/ics
	@$(ECHO) "updating $(WIIST_PATH) with internals..."
	@$(COPY) -rf ./.internals/* $(WIIST_PATH)/
	@$(ECHO) "deleting local internals repository..."
	@$(DEL) -rf ./.internals

bringup:
ifdef USE_INTERNALS
ifeq ($(USE_INTERNALS),yes)
	$(MAKE) update-internals
endif
endif
	@if [ -d $(TRASH_DIR) ] ; then $(DEL) -rf $(TRASH_DIR) ; fi
	@$(MKDIR) -p $(TRASH_DIR)
	@$(MKDIR) -p $(PROGRESS_DIR)
	@$(MAKE) ti-st-pre-bringup-validation
	@$(MAKE) bt-pre-bringup-validation
	@$(MAKE) gps-pre-bringup-validation
	@$(MAKE) fm-pre-bringup-validation
	@$(MAKE) wlan-pre-bringup-validation
	
	@$(MAKE) mydroid-bringup
	@$(MAKE) kernel-bringup
	@$(MAKE) u-boot-bringup
	@$(MAKE) x-loader-bringup
	
	@$(MAKE) wlan-bringup
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
ifdef USE_INTERNALS
ifeq ($(USE_INTERNALS),yes)
	$(MAKE) update-internals
endif
endif
	$(MAKE) u-boot-make
	$(MAKE) x-loader-make
	$(MAKE) kernel-make
	$(MAKE) wlan-make
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
ifdef USE_INTERNALS
ifeq ($(USE_INTERNALS),yes)
	$(MAKE) update-internals
endif
endif
	@$(MKDIR) -p $(BOOT_PATH)
	@$(MKDIR) -p $(MYFS_PATH)
	@$(MKDIR) -p $(EMMC_PATH)

	$(MAKE) u-boot-install
	$(MAKE) x-loader-install
	$(MAKE) kernel-install
	$(MAKE) wlan-install
	$(MAKE) mydroid-install
	$(MAKE) ti-st-install
	$(MAKE) bt-install
	$(MAKE) gps-install
	$(MAKE) fm-install

#	$(MAKE) pack-sd-fs
	@$(call print, "INSTALL DONE")

pack-sd-fs:
#	@cd $(OUTPUT_PATH_SD) ; $(TAR) cf $(OUTPUT_PATH_SD)/$(VERSION).sd.tar *
#	@cd $(OUTPUT_PATH_SD)/rootfs ; $(TAR) cf $(OUTPUT_PATH_SD)/rootfs.tar *
#	@cd $(OUTPUT_PATH_SD)/boot ; $(TAR) cf $(OUTPUT_PATH_SD)/boot.tar *
#	
#$(OUTPUT_PATH_SD)/$(VERSION).sd.tar:
#	$(MAKE) install
	
create-images: 
#$(OUTPUT_PATH_SD)/$(VERSION).sd.tar
	@if [ -d $(EMMC_PATH) ] ; then $(DEL) -rf $(EMMC_PATH) ; fi
	$(MKDIR) -p $(EMMC_PATH)
	$(COPY) -f $(MYDROID)/out/host/linux-x86/bin/fastboot $(EMMC_PATH)
	$(COPY) -f $(MYDROID)/out/host/linux-x86/bin/mkbootimg $(EMMC_PATH)
	$(COPY) -f $(MYDROID)/out/host/linux-x86/bin/make_ext4fs $(EMMC_PATH)
	$(COPY) -f $(BOOT_PATH)/u-boot.bin $(EMMC_PATH)
	$(COPY) -f $(BOOT_PATH)/MLO* $(EMMC_PATH)
	$(COPY) -f $(KERNEL_DIR)/arch/arm/boot/zImage $(EMMC_PATH)

#	# echo instead of just copy since there are ommited directories (which causes errors)
#	$(ECHO) `$(COPY) $(MYFS_PATH)/* $(OUTPUT_IMG_DIR)/root`
#	$(COPY) -rf $(MYFS_PATH)/system/* $(OUTPUT_IMG_DIR)/system
#	$(COPY) -rf $(MYFS_PATH)/data/* $(OUTPUT_IMG_DIR)/data
	$(FIND) $(OUTPUT_IMG_DIR) -name *.img -exec rm -f {} \;	
	$(MAKE) mydroid-make
	
	#copy all android generated images to local folder
	$(COPY) -f $(OUTPUT_IMG_DIR)/*.img $(EMMC_PATH)
	
	# create boot .img
	if [ -f $(EMMC_PATH)/boot.img ] ; then $(DEL) $(EMMC_PATH)/boot.img ; fi
	cd $(EMMC_PATH) ; ./mkbootimg --kernel zImage --ramdisk ramdisk.img --base 0x80000000 --cmdline "console=ttyO2,115200n8" --board omap4 -o boot.img
	
	# create cache.img partiotion
	cd $(EMMC_PATH) ; ./make_ext4fs -s -l 256M -a cache cache.img

	# create efs.img partiotion
	cd $(EMMC_PATH) ; ./make_ext4fs -s -l 16M -a efs efs.img
	
	$(COPY) $(WIIST_PATH)/misc/fastboot.sh $(EMMC_PATH)
	
	@$(call print, "eMMC IMAGES CREATION DONE")
	@$(call print, "creation of images took $$(( $(call GET_TIME)-$(MAKE_START_TIME) )) seconds")
	
clean: bringup
	@if [ -d $(OUTPUT_PATH) ] ; then $(ECHO) removing $(OUTPUT_PATH) directory ; $(DEL) -rf $(OUTPUT_PATH) ; fi

	$(MAKE) u-boot-clean
	$(MAKE) x-loader-clean
	$(MAKE) kernel-clean
	$(MAKE) mydroid-clean
	$(MAKE) wlan-clean
	$(MAKE) ti-st-clean
	$(MAKE) bt-clean
	$(MAKE) gps-clean
	$(MAKE) fm-clean
	
	@$(call print, "CLEAN DONE")
	@$(call print, "The clean process took $$(( $(call GET_TIME)-$(MAKE_START_TIME) )) seconds")
	
distclean:
	@if [ -f bringup ] ; then $(DEL) -rf bringup ; fi
	@if [ -d $(PROGRESS_DIR) ] ; then $(ECHO) removing $(PROGRESS_DIR) directory ; $(DEL) -rf $(PROGRESS_DIR) ; fi
	@if [ -d $(TRASH_DIR) ] ; then $(ECHO) removing $(TRASH_DIR) directory ; $(DEL) -rf $(TRASH_DIR) ; fi
	@if [ -d $(OUTPUT_PATH) ] ; then $(ECHO) removing $(OUTPUT_PATH) directory ; $(DEL) -rf $(OUTPUT_PATH) ; fi
	@if [ -d $(MANIFEST) ] ; then $(ECHO) removing $(MANIFEST) directory ; $(DEL) -rf $(MANIFEST) ; fi
	@if [ -d .repo ] ; then $(ECHO) removing .repo directory ; $(DEL) -rf .repo ; fi
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
include $(MAKEFILES_PATH)/wlan.mk
