################################################################################
#
# nlcp.mk
#
# Makefile for Android project integrated with NLCP
#
# Android Version	:	L27.INC1.13.1 OMAP4 GingerBread ES2
# Platform	     	:	Blaze platform es2.2
# Date				:	Oct. 2011
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
# nlcp make arguments
################################################################################

#include $(PWD)/defs.mk
include defs.mk

NLCP_RELEASE_VERSION:=RLS_R4_12
NLCP_SP_VERSION:=2
NLCP_MAIN_REPO:=git://github.com/TI-OpenLink

NLCP_PATCHES_PATH:=$(PATCHES_PATH)/wlan/nlcp
NLCP_WL12xx_PATCHES_DIR:=$(NLCP_PATCHES_PATH)/r4/wl12xx
NLCP_COMPAT_PATCHES_DIR:=$(NLCP_PATCHES_PATH)/r4/compat
NLCP_COMPAT_WIRELESS_PATCHES_DIR:=$(NLCP_PATCHES_PATH)/r4/compat-wireless
NLCP_KERNEL_PATCHES:=$(NLCP_PATCHES_PATH)/kernel
NLCP_ANDROID_PATCHES:=$(NLCP_PATCHES_PATH)/android

NLCP_BINARIES_PATH=$(NLCP_PATCHES_PATH)/binaries

PROGRESS_NLCP_FETCH_WL12xx:=$(PROGRESS_DIR)/nlcp.wl12xx.fetched
PROGRESS_NLCP_FETCH_COMPAT:=$(PROGRESS_DIR)/nlcp.compat.fetched
PROGRESS_NLCP_FETCH_COMPAT_WIRELESS:=$(PROGRESS_DIR)/nlcp.compat-wireless.fetched

PROGRESS_NLCP_BRINGUP_WL12xx:=$(PROGRESS_DIR)/nlcp.wl12xx.bringup
PROGRESS_NLCP_BRINGUP_COMPAT:=$(PROGRESS_DIR)/nlcp.compat.bringup
PROGRESS_NLCP_BRINGUP_COMPAT_WIRELESS:=$(PROGRESS_DIR)/nlcp.compat-wireless.bringup

PROGRESS_NLCP_KERNEL_PATCHES:=$(PROGRESS_DIR)/nlcp.kernel.patched
PROGRESS_NLCP_MYDROID_PATCHES:=$(PROGRESS_DIR)/nlcp.mydroid.patched

################################################################################
# rules
################################################################################

nlcp-private-pre-bringup-validation:
	@$(ECHO) "nlcp pre-bringup validation passed..."
	
nlcp-private-pre-make-validation:
#	cd $(HOSTAP_DIR) ; git checkout hostapd_vanilla
	@$(ECHO) "nlcp pre-make validation passed..."

WL12xx_REPO:=$(NLCP_MAIN_REPO)/wl12xx.git
WL12xx_DIR:=$(WORKSPACE_DIR)/wl12xx
WL12xx_BRANCH:=r5
WL12xx_TAG:=$(NLCP_RELEASE_VERSION)

$(PROGRESS_NLCP_FETCH_WL12xx):
	@$(ECHO) "getting wl12xx repository..."
	git clone $(WL12xx_REPO) $(WL12xx_DIR)
	@$(ECHO) "...done"
	@$(call echo-to-file, "DONE", $(PROGRESS_NLCP_FETCH_WL12xx))
	@$(call print, "wl12xx repository fetched")
	
$(PROGRESS_NLCP_BRINGUP_WL12xx): $(PROGRESS_NLCP_FETCH_WL12xx)
	@$(ECHO) "wl12xx bringup..."
	cd $(WL12xx_DIR) ; git checkout origin/$(WL12xx_BRANCH) -b $(WL12xx_BRANCH)
	@$(ECHO) "...done"
	@$(call echo-to-file, "DONE", $(PROGRESS_NLCP_BRINGUP_WL12xx))
	@$(call print, "wl12xx bringup done")

COMPAT_DIR:=$(WORKSPACE_DIR)/compat
COMPAT_REPO:=$(NLCP_MAIN_REPO)compat.git
COMPAT_BRANCH:=
COMPAT_HASH:=

$(PROGRESS_NLCP_FETCH_COMPAT):
	@$(ECHO) "getting compat repository..."
	git clone $(COMPAT_REPO) $(COMPAT_DIR)
	@$(ECHO) "...done"
	@$(call echo-to-file, "DONE", $(PROGRESS_NLCP_FETCH_COMPAT))
	@$(call print, "compat repository fetched")
	
$(PROGRESS_NLCP_BRINGUP_COMPAT): $(PROGRESS_NLCP_FETCH_COMPAT)
	@$(ECHO) "compat bringup..."
	$(COPY) $(WL12xx_DIR)/include/linux/if_ether.h $(COMPAT_DIR)/include/linux/
	$(COPY) $(WL12xx_DIR)/include/net/cfg80211-wext.h $(COMPAT_DIR)/include/net/	
	@$(ECHO) "...done"
	@$(call echo-to-file, "DONE", $(PROGRESS_NLCP_BRINGUP_COMPAT))
	@$(call print, "compat bringup done")

COMPAT_WIRELESS_DIR:=$(WORKSPACE_DIR)/compat-wireless
COMPAT_WIRELESS_REPO:=$(NLCP_MAIN_REPO)compat-wireless.git
COMPAT_WIRELESS_BRANCH:=
COMPAT_WIRELESS_HASH:=

GIT_COMPAT_TREE:=$(COMPAT_DIR)
GIT_TREE:=$(WL12xx_DIR)

export GIT_COMPAT_TREE
export GIT_TREE
	
$(PROGRESS_NLCP_FETCH_COMPAT_WIRELESS):
	@$(ECHO) "getting compat wireless repository..."
	git clone $(COMPAT_WIRELESS_REPO) $(COMPAT_WIRELESS_DIR)
	@$(ECHO) "...done"
	@$(call echo-to-file, "DONE", $(PROGRESS_NLCP_FETCH_COMPAT_WIRELESS))
	@$(call print, "compat wireless repository fetched")
	
$(PROGRESS_NLCP_BRINGUP_COMPAT_WIRELESS): $(PROGRESS_NLCP_FETCH_COMPAT_WIRELESS)
	@$(ECHO) "compat wireless bringup..."
	@$(ECHO) "...done"
	@$(call echo-to-file, "DONE", $(PROGRESS_NLCP_BRINGUP_COMPAT_WIRELESS))
	@$(call print, "compat wireless bringup done")

$(PROGRESS_NLCP_KERNEL_PATCHES): $(PROGRESS_BRINGUP_KERNEL)
	@$(ECHO) "patching kernel for nlcp..."
	@$(ECHO) "...done"
	@$(call echo-to-file, "DONE", $(PROGRESS_NLCP_KERNEL_PATCHES))
	@$(call print, "nlcp kernel patches done")	
	
HOSTAP_REPO:=$(NLCP_MAIN_REPO)/hostap.git
HOSTAP_DIR:=$(MYDROID)/external/wpa_supplicant_8
HOSTAP_REMOTE_NAME:=ti-wcs
HOSTAP_BRANCH:=ics
HOSTAP_TAG:=$(NLCP_RELEASE_VERSION)

PROGRESS_NLCP_FETCH_HOSTAP:=$(PROGRESS_DIR)/nlcp.hostap.fetched
PROGRESS_NLCP_BRINGUP_HOSTAP:=$(PROGRESS_DIR)/nlcp.hostap.bringup

$(PROGRESS_NLCP_FETCH_HOSTAP): $(PROGRESS_BRINGUP_MYDROID)
	@$(ECHO) "getting hostapd/supplicant repository..."
	cd $(HOSTAP_DIR) ; \
	git remote add $(HOSTAP_REMOTE_NAME) $(HOSTAP_REPO) ; \
	git fetch $(HOSTAP_REMOTE_NAME) 
	@$(ECHO) "...done"
	@$(call echo-to-file, "DONE", $(PROGRESS_NLCP_FETCH_HOSTAP))
	@$(call print, "hostapd/supplicant repository fetched")
	
$(PROGRESS_NLCP_BRINGUP_HOSTAP): $(PROGRESS_NLCP_FETCH_HOSTAP)
	@$(ECHO) "hostapd/supplicant bringup..."
	$(MKDIR) -p $(HOSTAP_DIR)
	cd $(HOSTAP_DIR) ; git checkout $(HOSTAP_REMOTE_NAME)/$(HOSTAP_BRANCH) -b $(HOSTAP_BRANCH)
	@$(ECHO) "...done"
	@$(call echo-to-file, "DONE", $(PROGRESS_NLCP_BRINGUP_HOSTAP))
	@$(call print, "hostapd/supplicant bringup done")

IW_REPO:=$(NLCP_MAIN_REPO)/iw.git
IW_DIR:=$(MYDROID)/external/iw
IW_BRANCH:=ics
IW_TAG:=

PROGRESS_NLCP_FETCH_IW:=$(PROGRESS_DIR)/nlcp.iw.fetched
PROGRESS_NLCP_BRINGUP_IW:=$(PROGRESS_DIR)/nlcp.iw.bringup

$(PROGRESS_NLCP_FETCH_IW): $(PROGRESS_BRINGUP_MYDROID)
	@$(ECHO) "getting iw repository..."
	if [ -d $(IW_DIR) ] ; then $(MOVE) $(IW_DIR) $(TRASH_DIR)/iw ; fi
	git clone $(IW_REPO) $(IW_DIR)
	@$(ECHO) "...done"
	@$(call echo-to-file, "DONE", $(PROGRESS_NLCP_FETCH_IW))
	@$(call print, "iw repository fetched")
	
$(PROGRESS_NLCP_BRINGUP_IW): $(PROGRESS_NLCP_FETCH_IW)
	@$(ECHO) "iw bringup..."
	cd $(IW_DIR) ; git checkout origin/$(IW_BRANCH) -b $(IW_BRANCH)
	@$(ECHO) "...done"
	@$(call echo-to-file, "DONE", $(PROGRESS_NLCP_BRINGUP_IW))
	@$(call print, "iw bringup done")

TI_UTILS_REPO:=$(NLCP_MAIN_REPO)/ti-utils.git
TI_UTILS_DIR:=$(MYDROID)/external/ti-utils
TI_UTILS_BRANCH:=ics
TI_UTILS_TAG:=

PROGRESS_NLCP_FETCH_TI_UTILS:=$(PROGRESS_DIR)/nlcp.ti-utils.fetched
PROGRESS_NLCP_BRINGUP_TI_UTILS:=$(PROGRESS_DIR)/nlcp.ti-utils.bringup

$(PROGRESS_NLCP_FETCH_TI_UTILS): $(PROGRESS_BRINGUP_MYDROID)
	@$(ECHO) "getting ti-utils repository..."
	if [ -d $(TI_UTILS_DIR) ] ; then $(MOVE) $(TI_UTILS_DIR) $(TRASH_DIR)/ti-utils ; fi
	git clone $(TI_UTILS_REPO) $(TI_UTILS_DIR)
	@$(ECHO) "...done"
	@$(call echo-to-file, "DONE", $(PROGRESS_NLCP_FETCH_TI_UTILS))
	@$(call print, "ti-utils repository fetched")
	
$(PROGRESS_NLCP_BRINGUP_TI_UTILS): $(PROGRESS_NLCP_FETCH_TI_UTILS)
	@$(ECHO) "ti-utils bringup..."
	cd $(TI_UTILS_DIR) ; git checkout origin/$(TI_UTILS_BRANCH) -b $(TI_UTILS_BRANCH)
	cd $(TI_UTILS_DIR) ; git reset --hard $(TI_UTILS_TAG)
	@$(ECHO) "...done"
	@$(call echo-to-file, "DONE", $(PROGRESS_NLCP_BRINGUP_TI_UTILS))
	@$(call print, "ti-utils bringup done")
	
nlcp-update-firmware-files:			$(PROGRESS_NLCP_BRINGUP_TI_UTILS)
#	latest firmwares are managed at the ti-utils project: mydroid/external/ti-utils/firmware,
#	we move it to the android fw hardware project (which installs it during android make)
	@$(MKDIR) -p $(MYDROID)/hardware/wlan/fw
	@$(ECHO) "Updating latest firmware binaries from ti-utils project..."
	@$(COPY) -f $(TI_UTILS_DIR)/firmware/wl128x-fw-mr.bin.r4 $(MYDROID)/hardware/wlan/fw
	@$(COPY) -f $(TI_UTILS_DIR)/firmware/wl128x-fw-mr_plt.bin.r4 $(MYDROID)/hardware/wlan/fw
	@$(COPY) -f $(TI_UTILS_DIR)/firmware/wl128x-fw-mr.bin.r5 $(MYDROID)/hardware/wlan/fw
	@$(COPY) -f $(TI_UTILS_DIR)/firmware/wl128x-fw-mr_plt.bin.r5 $(MYDROID)/hardware/wlan/fw
	@$(ECHO) "...done"
	
.PHONY += nlcp-update-firmware-files

$(PROGRESS_NLCP_MYDROID_PATCHES): $(PROGRESS_BRINGUP_MYDROID) \
				$(PROGRESS_NLCP_BRINGUP_WL12xx)
				$(PROGRESS_NLCP_BRINGUP_HOSTAP) \
				$(PROGRESS_NLCP_BRINGUP_IW) \
				$(PROGRESS_NLCP_BRINGUP_TI_UTILS)
	@$(ECHO) "patching android for nlcp..."
#	cd $(MYDROID)/build; \
#		git am $(NLCP_ANDROID_PATCHES)/build/*patch
#	cd $(MYDROID)/device/ti/blaze; \
#		git am $(NLCP_ANDROID_PATCHES)/device.ti.blaze/*patch
#	cd $(MYDROID)/external/hostapd; \
# 		git am $(NLCP_ANDROID_PATCHES)/external.hostapd/*patch
#	cd $(MYDROID)/external/openssl; \
# 		git am $(NLCP_ANDROID_PATCHES)/external.openssl/*patch
##	cd $(MYDROID)/external/ti-utils; \
# 		git am $(NLCP_ANDROID_PATCHES)/external.ti-utils/*patch
#	cd $(MYDROID)/external/wpa_supplicant_6; \
#	 	git am $(NLCP_ANDROID_PATCHES)/external.wpa_supplicant_6/*patch
#	cd $(MYDROID)/frameworks/base; \
#		git am $(NLCP_ANDROID_PATCHES)/frameworks.base/*.patch
#	cd $(MYDROID)/hardware/libhardware_legacy; \
#		git am $(NLCP_ANDROID_PATCHES)/hardware.libhardware_legacy/*.patch
#	cd $(MYDROID)/system/netd; \
#		git am $(NLCP_ANDROID_PATCHES)/system.netd/*.patch
#	@$(ECHO) "...done"
#	

	cd $(MYDROID)/system/core/libnl_2; \
		git am $(NLCP_ANDROID_PATCHES)/patches/system/core/libnl_2/*.patch

	@$(ECHO) "copying additional packages to mydroid directory..."
	$(MKDIR) -p $(TRASH_DIR)/hardware/wlan
	$(MKDIR) -p $(MYDROID)/hardware/wlan
#	if [ -f $(MYDROID)/hardware/wlan/Android.mk ] ; then $(MOVE) $(MYDROID)/hardware/wlan/Android.mk $(TRASH_DIR)/hardware/wlan/ ; fi
#	$(COPY) -r $(NLCP_ANDROID_PATCHES)/packages/hardware/wlan/Android.mk $(MYDROID)/hardware/wlan/Android.mk		
#	if [ -d $(MYDROID)/hardware/wlan/initial_regdom ] ; then $(MOVE) $(MYDROID)/hardware/wlan/initial_regdom $(TRASH_DIR)/hardware/wlan/ ; fi
#	$(COPY) -r $(NLCP_ANDROID_PATCHES)/packages/hardware/wlan/initial_regdom $(MYDROID)/hardware/wlan/initial_regdom	
#	if [ -d $(MYDROID)/hardware/wlan/wifi_conf ] ; then $(MOVE) $(MYDROID)/hardware/wlan/wifi_conf $(TRASH_DIR)/hardware/wlan/ ; fi
#	$(COPY) -r $(NLCP_ANDROID_PATCHES)/packages/hardware/wlan/wifi_conf $(MYDROID)/hardware/wlan/wifi_conf
	@$(ECHO) "...done"
	if [ -d $(MYDROID)/hardware/wlan/fw ] ; then $(MOVE) $(MYDROID)/hardware/wlan/fw $(TRASH_DIR)/hardware/wlan/ ; fi
	$(COPY) -r $(NLCP_ANDROID_PATCHES)/packages/hardware/wlan/fw $(MYDROID)/hardware/wlan/fw
	@$(call echo-to-file, "DONE", $(PROGRESS_NLCP_MYDROID_PATCHES))
	$(MAKE) nlcp-update-firmware-files
	@$(call print, "android patches and packages done")

nlcp-invoke-fetch-private:	$(PROGRESS_NLCP_BRINGUP_WL12xx) \
				$(PROGRESS_NLCP_KERNEL_PATCHES) \
				$(PROGRESS_NLCP_MYDROID_PATCHES)
	cd $(CRDA_DIR); 	git fetch
	cd $(LIBNL_DIR); 	git fetch
	cd $(TI_UTILS_DIR);	git fetch
	cd $(IW_DIR); 		git fetch
	cd $(HOSTAP_DIR); 	git fetch
	cd $(WL12xx_DIR); 	git fetch

nlcp-sync-ver-private:	$(PROGRESS_NLCP_BRINGUP_WL12xx) \
			$(PROGRESS_NLCP_KERNEL_PATCHES) \
			$(PROGRESS_NLCP_MYDROID_PATCHES)
	$(MAKE) nlcp-invoke-fetch-private
	cd $(CRDA_DIR); 	git reset --hard $(NLCP_RELEASE_VERSION)
	cd $(LIBNL_DIR); 	git reset --hard $(NLCP_RELEASE_VERSION)
	cd $(TI_UTILS_DIR);	git reset --hard $(NLCP_RELEASE_VERSION)
	cd $(IW_DIR); 		git reset --hard $(NLCP_RELEASE_VERSION)
	cd $(HOSTAP_DIR); 	git reset --hard $(NLCP_RELEASE_VERSION)
	cd $(WL12xx_DIR); 	git reset --hard $(NLCP_RELEASE_VERSION)
	$(MAKE) nlcp-update-firmware-files
	
nlcp-sync-repo-latest:	$(PROGRESS_NLCP_BRINGUP_WL12xx) \
			$(PROGRESS_NLCP_KERNEL_PATCHES) \
			$(PROGRESS_NLCP_MYDROID_PATCHES)
	cd $(CRDA_DIR); 	git pull origin $(CRDA_BRANCH)
	cd $(LIBNL_DIR); 	git pull origin $(LIBNL_BRANCH)
	cd $(TI_UTILS_DIR); 	git pull origin $(TI_UTILS_BRANCH)
	cd $(IW_DIR); 		git pull origin $(IW_BRANCH)
	cd $(HOSTAP_DIR); 	git pull origin $(HOSTAP_BRANCH)
	cd $(WL12xx_DIR); 	git pull origin $(WL12xx_BRANCH)
	$(MAKE) nlcp-update-firmware-files

nlcp-bringup-private: 	$(PROGRESS_NLCP_BRINGUP_WL12xx) \
			$(PROGRESS_NLCP_BRINGUP_COMPAT) \
			$(PROGRESS_NLCP_BRINGUP_COMPAT_WIRELESS) \
			$(PROGRESS_NLCP_KERNEL_PATCHES) \
			$(PROGRESS_NLCP_MYDROID_PATCHES)
	@$(ECHO) "nlcp bringup..."
	cd $(COMPAT_WIRELESS_DIR) ; sh ./scripts/admin-refresh.sh
	cd $(COMPAT_WIRELESS_DIR) ; ./scripts/driver-select wl12xx
	@$(ECHO) "...done"

	
nlcp-make-private:	$(PROGRESS_NLCP_BRINGUP_COMPAT) \
			$(PROGRESS_NLCP_BRINGUP_COMPAT_WIRELESS) \
			$(PROGRESS_NLCP_BRINGUP_WL12xx) \
			nlcp-update-firmware-files
	@$(ECHO) "nlcp make..."
	cd $(COMPAT_WIRELESS_DIR) ; sh ./scripts/admin-refresh.sh
	cd $(COMPAT_WIRELESS_DIR) ; ./scripts/driver-select wl12xx
	$(MAKE) -C $(COMPAT_WIRELESS_DIR) KLIB=$(KERNEL_DIR) KLIB_BUILD=$(KERNEL_DIR) -j$(NTHREADS)

	@$(ECHO) "...done"
	
nlcp-install-private:
	@$(ECHO) "nlcp install..."
	$(MKDIR) -p $(MYFS_PATH)/system/lib/modules
	@$(ECHO) "copy modules from compat-wireless"
	$(FIND) $(COMPAT_WIRELESS_DIR) -name "*.ko" -exec cp -f {}  $(MYFS_PATH)/system/lib/modules/ \;
	@$(ECHO) "copy modules from kernel"
	$(FIND) $(KERNEL_DIR)/drivers/staging -name "*.ko" -exec cp -v {} $(MYFS_PATH) \;
#	@$(ECHO) "patching init.omap4430.rc"
#	cd $(MYFS_PATH) ; $(PATCH) -p1 --dry-run < $(NLCP_PATCHES_PATH)/nlcp.init.omap4430.rc.patch
#	cd $(MYFS_PATH) ; $(PATCH) -p1 < $(NLCP_PATCHES_PATH)/nlcp.init.omap4430.rc.patch
	@$(ECHO) "copying additinal binaries to file system"
	$(COPY) -rf $(NLCP_BINARIES_PATH)/* $(MYFS_PATH)
	$(CHMOD) -R 777 $(MYFS_PATH)/data/misc/wifi/*
	@$(ECHO) "...done"
	
nlcp-clean-private:
	@$(ECHO) "nlcp clean..."
	$(MAKE) -C $(COMPAT_WIRELESS_DIR) KLIB=$(KERNEL_DIR) KLIB_BUILD=$(KERNEL_DIR) -j$(NTHREADS) clean
	@$(ECHO) "...done"

nlcp-distclean-private:
	@$(ECHO) "nlcp distclean..."
	$(MAKE) $(PROGRESS_NLCP_MYDROID_PATCHES)-distclean
	$(MAKE) $(PROGRESS_NLCP_KERNEL_PATCHES)-distclean
	@$(ECHO) "removing wl12xx..."
	$(DEL) -rf $(WL12xx_DIR) $(PROGRESS_NLCP_FETCH_WL12xx) $(PROGRESS_NLCP_BRINGUP_WL12xx)
	@$(ECHO) "...done"
	@$(ECHO) "removing compat..."
	$(DEL) -rf $(COMPAT_DIR) $(PROGRESS_NLCP_FETCH_COMPAT) $(PROGRESS_NLCP_BRINGUP_COMPAT)
	@$(ECHO) "...done"	
	@$(ECHO) "removing compat wireless..."
	$(DEL) -rf $(COMPAT_WIRELESS_DIR) $(PROGRESS_NLCP_FETCH_COMPAT_WIRELESS) $(PROGRESS_NLCP_BRINGUP_COMPAT_WIRELESS)
	@$(ECHO) "...done"
	@$(call print, "nlcp removed from workspace")

$(PROGRESS_NLCP_KERNEL_PATCHES)-distclean: $(PROGRESS_NLCP_KERNEL_PATCHES)
	@$(ECHO) "removing nlcp support from kernel..."
	cd $(KERNEL_DIR) ; $(REM_PATCH) -p1 < $(NLCP_KERNEL_PATCHES)/L27.INC1.13.1.kernel-config.nlcp-r3-rc5.patch
	cd $(KERNEL_DIR) ; $(REM_PATCH) -p1 < $(NLCP_KERNEL_PATCHES)/L27.INC1.13.1.kernel.nlcp-r3-rc5.patch
	@$(ECHO) "...done"
	@$(DEL) $(PROGRESS_NLCP_KERNEL_PATCHES)
	@$(call print, "nlcp kernel patches removed")

$(PROGRESS_NLCP_MYDROID_PATCHES)-distclean: $(PROGRESS_NLCP_MYDROID_PATCHES)
	@$(ECHO) "removing nlcp support from android..."
	cd $(MYDROID)/system/netd ; $(REM_PATCH) -p1 < $(NLCP_ANDROID_PATCHES)/system.netd/0004*
	cd $(MYDROID)/system/netd ; $(REM_PATCH) -p1 < $(NLCP_ANDROID_PATCHES)/system.netd/0003*
	cd $(MYDROID)/system/netd ; $(REM_PATCH) -p1 < $(NLCP_ANDROID_PATCHES)/system.netd/0002*
	cd $(MYDROID)/system/netd ; $(REM_PATCH) -p1 < $(NLCP_ANDROID_PATCHES)/system.netd/0001*
	cd $(MYDROID)/system/core ; $(REM_PATCH) -p1 < $(NLCP_ANDROID_PATCHES)/system.core/0003-revert-android-dhcp-service-name-device-name-usage.patch
	cd $(MYDROID)/system/core ; $(REM_PATCH) -p1 < $(NLCP_ANDROID_PATCHES)/system.core/0002*
	cd $(MYDROID)/system/core ; $(REM_PATCH) -p1 < $(NLCP_ANDROID_PATCHES)/system.core/0001*
	cd $(MYDROID)/hardware/libhardware_legacy ; $(REM_PATCH) -p1 < $(NLCP_ANDROID_PATCHES)/hardware.libhardware_legacy/0001-Revert*
	cd $(MYDROID)/frameworks/base ; $(REM_PATCH) -p1 < $(NLCP_ANDROID_PATCHES)/frameworks.base/0002*
	cd $(MYDROID)/frameworks/base ; $(REM_PATCH) -p1 < $(NLCP_ANDROID_PATCHES)/frameworks.base/0001*
	cd $(MYDROID)/external/wpa_supplicant_6 ; $(REM_PATCH) -p1 < $(NLCP_ANDROID_PATCHES)/external.wpa_supplicant_6/*
	cd $(MYDROID)/external/openssl ; $(REM_PATCH) -p1 < $(NLCP_ANDROID_PATCHES)/external.openssl/*
	cd $(MYDROID)/external/hostapd ; $(REM_PATCH) -p1 < $(NLCP_ANDROID_PATCHES)/external.hostapd/*
	cd $(MYDROID)/device/ti/blaze ; $(REM_PATCH) -p1 < $(NLCP_ANDROID_PATCHES)/device.ti.blaze/*
	cd $(MYDROID)/build ; $(REM_PATCH) -p1 < $(NLCP_ANDROID_PATCHES)/build/*	
	@$(ECHO) "...done"	
	@$(ECHO) "removing additional packages from mydroid directory..."
	$(DEL) -rf $(MYDROID)/external/crda
	if [ -d $(TRASH_DIR)/crda ] ; $(MOVE) $(TRASH_DIR)/crda $(MYDROID)/external/crda ; fi
	$(DEL) -rf $(MYDROID)/external/hostap
	if [ -d $(TRASH_DIR)/hostapd ] ; $(MOVE) $(TRASH_DIR)/hostapd $(MYDROID)/external/hostapd ; fi
	$(DEL) -rf $(MYDROID)/external/iw
	if [ -d $(TRASH_DIR)/iw ] ; $(MOVE) $(TRASH_DIR)/iw $(MYDROID)/external/iw ; fi
	$(DEL) -rf $(MYDROID)/external/libnl
	if [ -d $(TRASH_DIR)/libnl ] ; $(MOVE) $(TRASH_DIR)/libnl $(MYDROID)/external/libnl ; fi
	$(DEL) -rf $(MYDROID)/external/ti-utils
	if [ -d $(TRASH_DIR)/ti-utils ] ; $(MOVE) $(TRASH_DIR)/ti-utils $(MYDROID)/external/ti-utils ; fi
	$(MKDIR) -p $(MYDROID)/hardware/wlan
	$(DEL) -rf $(MYDROID)/hardware/wlan/Android.mk
	if [ -f $(MYDROID)/hardware/wlan/Android.mk.org ] ; then $(MOVE) $(MYDROID)/hardware/wlan/Android.mk.org $(MYDROID)/hardware/wlan/Android.mk ; fi
	$(DEL) -rf $(MYDROID)/hardware/wlan/fw
	if [ -d $(MYDROID)/hardware/wlan/fw.org ] ; then $(MOVE) $(MYDROID)/hardware/wlan/fw.org $(MYDROID)/hardware/wlan/fw ; fi
	$(DEL) -rf $(MYDROID)/hardware/wlan/initial_regdom
	if [ -d $(MYDROID)/hardware/wlan/initial_regdom.org ] ; then $(MOVE) $(MYDROID)/hardware/wlan/initial_regdom.org $(MYDROID)/hardware/wlan/initial_regdom ; fi
	$(DEL) -rf $(MYDROID)/hardware/wlan/wifi_conf
	if [ -d $(MYDROID)/hardware/wlan/wifi_conf.org ] ; then $(MOVE) $(MYDROID)/hardware/wlan/wifi_conf.org $(MYDROID)/hardware/wlan/wifi_conf ; fi
	$(DEL) -rf $(MYDROID)/hardware/wlan/wpa_supplicant_lib
	if [ -d $(MYDROID)/hardware/wlan/wpa_supplicant_lib.org ] ; then $(MOVE) $(MYDROID)/hardware/wlan/wpa_supplicant_lib.org $(MYDROID)/hardware/wlan/wpa_supplicant_lib ; fi
	@$(ECHO) "...done"
	@$(DEL) $(PROGRESS_NLCP_MYDROID_PATCHES)
	@$(call print, "android patches and packages removed")
