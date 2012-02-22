################################################################################
#
# rules.mk
#
# Makefile for Android project integrated with NLCP
# Based on OMAP's L27.INC1.13.1 instructions
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

include defs.mk
include $(WIIST_PATH)/repo.mk

$(PROGRESS_DIR):
	@$(MKDIR) -p $(PROGRESS_DIR)

$(PROGRESS_FETCH_MANIFEST):
	@$(ECHO) "getting manifest..."
	@$(MAKE) $(PROGRESS_DIR)
	@$(ECHO) "$(PROGRESS_FETCH_MANIFEST)"
	@git clone $(OMAPMANIFEST_REPO) $(MANIFEST)
	@$(call echo-to-file, "DONE", $(PROGRESS_FETCH_MANIFEST))
	@$(call print, "manifest for $(OMAPMANIFEST_BRANCH) retrieved")
	@$(call echo-to-file, "PACKAGE SOURCE: git -> $(GIT_PROTOCOL_USE)", $(PROGRESS_FETCH_METHOD))

$(PROGRESS_BRINGUP_MANIFEST): $(PROGRESS_FETCH_MANIFEST)
	@$(ECHO) "manifest bringup..."
	@cd $(MANIFEST) ; git checkout $(OMAPMANIFEST_BRANCH)
	@$(call echo-to-file, "DONE", $(PROGRESS_BRINGUP_MANIFEST))
	@$(call print, "manifest for $(OMAPMANIFEST_BRANCH) ready to use")

omapmanifest-bringup: $(PROGRESS_BRINGUP_MANIFEST)

ifeq ($(GIT_PROTOCOL_USE), opbu)
$(PROGRESS_FETCH_MYDROID):
ifndef OPBU_TAR_FILE
	$(MAKE) error-opbu_missing
else
	@if [ ! -f $(OPBU_TAR_FILE) ] ; then \
		$(MAKE) error-opbu_missing ; \
	fi
endif
	$(TAR) -xjf $(OPBU_TAR_FILE)
	@$(call echo-to-file, "OPBU", $(PROGRESS_FETCH_MYDROID))
	@$(call echo-to-file, "OPBU", $(PROGRESS_FETCH_KERNEL))
	@$(call echo-to-file, "OPBU", $(PROGRESS_FETCH_UBOOT))
	@$(call echo-to-file, "OPBU", $(PROGRESS_FETCH_XLOADER))
	
	@$(call echo-to-file, "PACKAGE SOURCE: OPBU TAR FILE -> $(OPBU_TAR_FILE)", $(PROGRESS_FETCH_METHOD))
	
error-opbu_missing:
	$(error OPBU tar file is missing or not defined)
else
$(PROGRESS_MYDROID_REPO_INIT): $(PROGRESS_BRINGUP_MANIFEST)
	@$(MKDIR) -p $(MYDROID)
	cd $(MYDROID) ; \
	repo init -u $(MANIFEST) -b $(OMAPMANIFEST_BRANCH) -m $(OMAPMANIFEST_XMLFILE) $(REPO_INIT_DEF_PARAMS)
	@$(call echo-to-file, "DONE", $(PROGRESS_MYDROID_REPO_INIT))
	@$(call print, "android repo inited")

$(PROGRESS_FETCH_MYDROID): $(PROGRESS_MYDROID_REPO_INIT)
	$(MAKE) mydroid-create-local-manifest
	cd $(MYDROID) ; repo sync $(REPO_SYNC_DEF_PARAMS)
	@$(call echo-to-file, "DONE", $(PROGRESS_FETCH_MYDROID))
	@$(call print, "android filesystem retrieved")
endif

$(PROGRESS_FETCH_KERNEL): $(PROGRESS_FETCH_MANIFEST)
	@$(MKDIR) -p $(KERNEL_DIR)
	git clone $(KERNEL_REPO) $(KERNEL_DIR)
	cd $(KERNEL_DIR) ; git checkout $(KERNEL_TAG_HASH) -b vanilla
	@$(call echo-to-file, "DONE", $(PROGRESS_FETCH_KERNEL))
	@$(call print, "kernel version $(KERNEL_VERSION) retrieved")

$(PROGRESS_FETCH_UBOOT): 
	git clone $(UBOOT_REPO) $(UBOOT_DIR)
	cd $(UBOOT_DIR) ; git checkout $(UBOOT_TAG_HASH) -b vanilla
	@$(call echo-to-file, "DONE", $(PROGRESS_FETCH_UBOOT))
	@$(call print, "u-boot retrieved")

$(PROGRESS_FETCH_XLOADER): 
	git clone $(XLOADER_REPO) $(XLOADER_DIR)
	cd $(XLOADER_DIR) ; git checkout $(XLOADER_TAG_HASH) -b vanilla
	@$(call echo-to-file, "DONE", $(PROGRESS_FETCH_XLOADER))
	@$(call print, "x-loader retrieved")

$(PROGRESS_BRINGUP_UBOOT): $(PROGRESS_FETCH_UBOOT)
	$(MAKE) -C $(UBOOT_DIR) distclean
	$(MAKE) -C $(UBOOT_DIR) ARCH=arm $(UBOOT_PLATFORM_CONFIG)
	@$(call echo-to-file, "DONE", $(PROGRESS_BRINGUP_UBOOT))
	@$(call print, "u-boot bringup done")

u-boot-bringup: 	$(PROGRESS_BRINGUP_UBOOT)

$(PROGRESS_BRINGUP_XLOADER): $(PROGRESS_FETCH_XLOADER)
	$(MAKE) -C $(XLOADER_DIR) distclean	
	$(MAKE) -C $(XLOADER_DIR) ARCH=arm $(XLOADER_PLATFORM_CONFIG)
	@$(call echo-to-file, "DONE", $(PROGRESS_BRINGUP_XLOADER))
	@$(call print, "x-loader bringup done")

x-loader-bringup: 	$(PROGRESS_BRINGUP_XLOADER)

$(PROGRESS_BRINGUP_KERNEL): $(PROGRESS_FETCH_KERNEL)
	$(MAKE) -C $(KERNEL_DIR) -j$(NTHREADS) ARCH=arm distclean	
	$(MAKE) -C $(KERNEL_DIR) ARCH=arm $(KERNEL_PLATFORM_CONFIG)
	@$(call echo-to-file, "DONE", $(PROGRESS_BRINGUP_KERNEL))
	@$(call print, "kernel bringup done")

kernel-bringup: 	$(PROGRESS_BRINGUP_KERNEL)

$(PROGRESS_BRINGUP_MYDROID): $(PROGRESS_FETCH_MYDROID)
	@$(ECHO) "$(PROGRESS_BRINGUP_MYDROID)"
	@cd $(MYDROID) ; source build/envsetup.sh ; $(MAKE) -j$(NTHREADS) clean 2>&1
	@$(call echo-to-file, "DONE", $(PROGRESS_BRINGUP_MYDROID))
	@$(call print, "mydroid bringup done")

mydroid-bringup: 	$(PROGRESS_BRINGUP_MYDROID)

u-boot-make: 		$(PROGRESS_BRINGUP_UBOOT)
	$(MAKE) -C $(UBOOT_DIR) 2>&1
	@$(call print, "u-boot make done")

x-loader-make: 		$(PROGRESS_BRINGUP_XLOADER)
	$(MAKE) -C $(XLOADER_DIR) ift 2>&1
	@$(call print, "x-loader make done")

kernel-make: 		$(PROGRESS_BRINGUP_KERNEL) \
			u-boot-make
	$(MAKE) -C $(KERNEL_DIR) ARCH=arm -j$(NTHREADS) uImage 2>&1
	$(MAKE) -C $(KERNEL_DIR) ARCH=arm -j$(NTHREADS) modules 2>&1
	@$(call print, "kernel make done")

mydroid-make: 		$(PROGRESS_BRINGUP_MYDROID)
	cd $(MYDROID) ; source build/envsetup.sh ; $(MAKE) $(AFS_BUILD_OPTION) -j$(NTHREADS) 2>&1
	@$(call print, "mydroid make done")

$(UBOOT_DIR)/u-boot.bin:
	$(MAKE) u-boot-make

u-boot-install: 	$(UBOOT_DIR)/u-boot.bin
	@$(COPY) $(UBOOT_DIR)/u-boot.bin $(BOOT_PATH)
	@$(call print, "u-boot install done")

$(XLOADER_DIR)/MLO:
	$(MAKE) x-loader-make

x-loader-install:	$(XLOADER_DIR)/MLO
	@$(COPY) $(XLOADER_DIR)/MLO $(BOOT_PATH)
	$(call print, "x-loader install done")

$(KERNEL_DIR)/arch/arm/boot/uImage:
	$(MAKE) kernel-make

kernel-install: 	$(KERNEL_DIR)/arch/arm/boot/uImage
	@$(COPY) $(KERNEL_DIR)/arch/arm/boot/uImage $(BOOT_PATH)
	$(call print, "kernel install done")

mydroid-install:
	@$(ECHO) extract prebuilt binaries...
	$(MAKE) binaries-install
	
	@$(ECHO) copy init.rc scripts to rootfs folder...
	@$(MKDIR) -p $(MYFS_ROOT_PATH)
	@$(COPY) -fv $(INITRC_PATH)/init.rc $(MYFS_ROOT_PATH)/
	
	@$(ECHO) install busybox links...
	@$(MKDIR) -p $(MYFS_SYSTEM_PATH)/xbin/busybox
	@cd $(MYFS_SYSTEM_PATH)/xbin/busybox ; source $(WIIST_PATH)/misc/scripts/create_busybox_symlink.sh
	@$(CHMOD) -R 777 $(MYFS_SYSTEM_PATH)/xbin/busybox

	@$(call print, "mydroid install done")

VERSION_TI_TXT_FILE:=$(BINARIES_PATH)/root/version_ti.txt

binaries-install:
	@$(MKDIR) -p $(BINARIES_PATH)
	@$(ECHO) "OMAP's RELEASE: $(VERSION)" >$(VERSION_TI_TXT_FILE)
	@$(ECHO) "http://omapedia.org/wiki/L27.IS.1_OMAP4_Icecream_Sandwich_Release_Notes" >>$(VERSION_TI_TXT_FILE)
	@$(ECHO) "" >>$(VERSION_TI_TXT_FILE)
ifeq ($(CONFIG_GPS), y)
	@$(ECHO) "GPS version : NaviLink_MCP2.6_RC1.5" >>$(VERSION_TI_TXT_FILE)
	@$(ECHO) "" >>$(VERSION_TI_TXT_FILE)
endif
ifeq ($(CONFIG_NLCP), y)
	@$(ECHO) "NLCP version : $(NLCP_RELEASE_VERSION)" >>$(VERSION_TI_TXT_FILE)
	@$(ECHO) "SP Version: $(NLCP_SP_VERSION)" >>$(VERSION_TI_TXT_FILE)
	@$(ECHO) "wl12xx commit id : $(WL12xx_HASH)" >>$(VERSION_TI_TXT_FILE)
	@$(ECHO) "compat commit id : $(COMPAT_HASH)" >>$(VERSION_TI_TXT_FILE)
	@$(ECHO) "compat-wireless commit id : $(COMPAT_WIRELESS_HASH)" >>$(VERSION_TI_TXT_FILE)
endif
	@$(ECHO) "Built by :" `whoami` "@ " `date` ", on machine:" `hostname`>>$(VERSION_TI_TXT_FILE)
	@$(ECHO) "CROSS COMPILE: $(CROSS_COMPILE)" >>$(VERSION_TI_TXT_FILE)
	@$(ECHO) "JAVA HOME: $(JAVA_HOME)" >>$(VERSION_TI_TXT_FILE)
	@$(ECHO) "" >>$(VERSION_TI_TXT_FILE)
	@$(ECHO) "BUILD PATH: $(PWD)" >>$(VERSION_TI_TXT_FILE)
	@cat $(PROGRESS_FETCH_METHOD) >>$(VERSION_TI_TXT_FILE)
	@$(ECHO) "BUILD COMMAND: $(MAKECMDGOALS)" >>$(VERSION_TI_TXT_FILE)
	@$(ECHO) "" >>$(VERSION_TI_TXT_FILE)
	@$(ECHO) "KERNEL VERSION: $(KERNEL_VERSION)" >>$(VERSION_TI_TXT_FILE)
	@$(ECHO) "" >>$(VERSION_TI_TXT_FILE)
	@$(ECHO) "CONFIG_TIST: $(CONFIG_TIST)" >>$(VERSION_TI_TXT_FILE)
	@$(ECHO) "CONFIG_GPS: $(CONFIG_GPS)" >>$(VERSION_TI_TXT_FILE)
	@$(ECHO) "CONFIG_BT: $(CONFIG_BT)" >>$(VERSION_TI_TXT_FILE)
	@$(ECHO) "CONFIG_FM: $(CONFIG_FM)" >>$(VERSION_TI_TXT_FILE)
	@$(ECHO) "CONFIG_NLCP: $(CONFIG_NLCP)" >>$(VERSION_TI_TXT_FILE)
	@$(ECHO) "" >>$(VERSION_TI_TXT_FILE)
	@$(ECHO) "" >>$(VERSION_TI_TXT_FILE)
	@if [ -d $(BINARIES_PATH)/system ] ; then $(COPY) -rf $(BINARIES_PATH)/system/* $(MYFS_SYSTEM_PATH)/ ; fi
	@if [ -d $(BINARIES_PATH)/root ] ; then $(COPY) -rf $(BINARIES_PATH)/root/* $(MYFS_ROOT_PATH)/ ; fi
	@$(call print, "binaries copied to target directory")

u-boot-clean: 		$(PROGRESS_BRINGUP_UBOOT)
	$(MAKE) -C $(UBOOT_DIR) clean 2>&1
	@$(call print, "u-boot clean done")
	
u-boot-distclean: 	$(PROGRESS_BRINGUP_UBOOT)
	$(MAKE) -C $(UBOOT_DIR) distclean 2>&1
	@$(DEL) $(PROGRESS_BRINGUP_UBOOT)
	@$(call print, "u-boot distclean done")

x-loader-clean: 	$(PROGRESS_BRINGUP_XLOADER)
	$(MAKE) -C $(XLOADER_DIR) clean 2>&1
	@$(call print, "x-loader clean done")

x-loader-distclean: $(PROGRESS_BRINGUP_XLOADER)
	$(MAKE) -C $(XLOADER_DIR) distclean 2>&1
	@$(DEL) $(PROGRESS_BRINGUP_XLOADER)
	@$(call print, "x-loader distclean done")

kernel-clean: 		$(PROGRESS_BRINGUP_KERNEL)
	$(MAKE) -C $(KERNEL_DIR) ARCH=arm -j$(NTHREADS) clean 2>&1
	@$(call print, "kernel clean done")
	
kernel-distclean:	$(PROGRESS_BRINGUP_KERNEL)
	$(MAKE) -C $(KERNEL_DIR) -j$(NTHREADS) ARCH=arm distclean
	@$(DEL) $(PROGRESS_BRINGUP_KERNEL)
	@$(call print, "kernel distclean done")

mydroid-clean: 		$(PROGRESS_BRINGUP_MYDROID)
	$(MAKE) -C $(MYDROID) -j$(NTHREADS) clean 2>&1
	@$(call print, "mydroid clean done")

mydroid-distclean:
	$(MAKE) mydroid-clean
	
mydroid-create-local-manifest:
	$(MAKE) wlan-create-local-android-manifest
	$(MAKE) bt-create-local-android-manifest
	$(MAKE) gps-create-local-android-manifest
	$(MAKE) fm-create-local-android-manifest
	# merge local manifest and align main manifest.xml
	@$(call print, "align wlan and bt manifests")
	cd $(MYDROID)/.repo ; \
	$(SCRIPTS_PATH)/align_manifest.py $(WLAN_ANDROID_LOCAL_MANIFEST_NAME) $(BT_ANDROID_LOCAL_MANIFEST_NAME)
	@$(call print, "merge wlan and bt manifests")	
	cd $(MYDROID)/.repo ; \
	$(SCRIPTS_PATH)/merge_wcs_manifest.py local_manifest.xml $(WLAN_ANDROID_LOCAL_MANIFEST_NAME) $(BT_ANDROID_LOCAL_MANIFEST_NAME)
	@$(call print, "align local and repo manifests")
	cd $(MYDROID)/.repo ; \
	$(SCRIPTS_PATH)/align_manifest.py local_manifest.xml manifest.xml
	
$(PROGRESS_FETCH_WLAN_MANIFEST):
	@$(ECHO) "getting wlan android manifest..."
ifeq ($(CONFIG_WLAN), y)
	git clone $(WLAN_MANIFEST_REPO) $(WLAN_MANIFEST_DIR)
	@$(call print, "wlan manifest fetched")
endif
	@$(call echo-to-file, "DONE", $(PROGRESS_FETCH_WLAN_MANIFEST))
	@$(ECHO) "...done"
	
$(PROGRESS_BRINGUP_WLAN_MANIFEST): \
		$(PROGRESS_MYDROID_REPO_INIT) \
		$(PROGRESS_FETCH_WLAN_MANIFEST)
	@$(ECHO) "wlan android manifest bringup..."
	cd $(WLAN_MANIFEST_DIR) ; \
	git checkout $(WLAN_MANIFEST_BRANCH) ; \
	git reset --hard $(WLAN_MANIFEST_HASH)
	@$(call echo-to-file, "DONE", $(PROGRESS_BRINGUP_WLAN_MANIFEST))
	@$(call print, "wlan manifest bringup done")
	@$(ECHO) "...done"

wlan-create-local-android-manifest:
ifeq ($(CONFIG_WLAN), y)
	$(MAKE) $(PROGRESS_BRINGUP_WLAN_MANIFEST)
	# copy manifest to .repo folder of android
	$(COPY) $(WLAN_MANIFEST_DIR)/$(WLAN_ANDROID_MANIFEST_NAME) $(MYDROID)/.repo/$(WLAN_ANDROID_LOCAL_MANIFEST_NAME)
else
	$(COPY) $(WIIST_PATH)/misc/empty_manifest.xml $(MYDROID)/.repo/$(WLAN_ANDROID_LOCAL_MANIFEST_NAME)
	$(TOUCH) $(MYDROID)/.repo/$(WLAN_ANDROID_LOCAL_MANIFEST_NAME)
endif

$(PROGRESS_FETCH_BT_MANIFEST):
	@$(ECHO) "getting bt android manifest..."
ifeq ($(CONFIG_BT), y)
	git clone $(BT_MANIFEST_REPO) $(BT_MANIFEST_DIR)
	@$(call print, "bt manifest fetched")
endif
	@$(call echo-to-file, "DONE", $(PROGRESS_FETCH_BT_MANIFEST))
	@$(ECHO) "...done"
	
$(PROGRESS_BRINGUP_BT_MANIFEST): \
		$(PROGRESS_MYDROID_REPO_INIT) \
		$(PROGRESS_FETCH_BT_MANIFEST)
	@$(ECHO) "bt android manifest bringup..."
	cd $(BT_MANIFEST_DIR) ; \
	git checkout $(BT_MANIFEST_BRANCH) ; \
	git reset --hard $(BT_MANIFEST_HASH)
	@$(call echo-to-file, "DONE", $(PROGRESS_BRINGUP_BT_MANIFEST))
	@$(call print, "bt manifest bringup done")
	@$(ECHO) "...done"
	
bt-create-local-android-manifest:
ifeq ($(CONFIG_BT), y)
	$(MAKE)  $(PROGRESS_BRINGUP_BT_MANIFEST)
	# copy manifest to .repo folder of android
	$(COPY) $(BT_MANIFEST_DIR)/$(BT_ANDROID_MANIFEST_NAME) $(MYDROID)/.repo/$(BT_ANDROID_LOCAL_MANIFEST_NAME)
else
	$(COPY) $(WIIST_PATH)/misc/empty_manifest.xml $(MYDROID)/.repo/$(BT_ANDROID_LOCAL_MANIFEST_NAME)
	$(TOUCH) $(MYDROID)/.repo/$(BT_ANDROID_LOCAL_MANIFEST_NAME)
endif

gps-create-local-android-manifest:

fm-create-local-android-manifest:
