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

NLCP_RELEASE_VERSION:=ol_R5.00.02
NLCP_SP_VERSION:=
NLCP_MAIN_REPO:=git://github.com/TI-OpenLink

NLCP_PATCHES_PATH:=$(PATCHES_PATH)/wlan/nlcp
NLCP_WL12xx_PATCHES_DIR:=$(NLCP_PATCHES_PATH)/r4/wl12xx
NLCP_COMPAT_PATCHES_DIR:=$(NLCP_PATCHES_PATH)/r4/compat
NLCP_COMPAT_WIRELESS_PATCHES_DIR:=$(NLCP_PATCHES_PATH)/r4/compat-wireless
NLCP_KERNEL_PATCHES:=$(NLCP_PATCHES_PATH)/kernel
NLCP_ANDROID_PATCHES:=$(NLCP_PATCHES_PATH)/android

NLCP_BINARIES_PATH=$(NLCP_PATCHES_PATH)/binaries

PROGRESS_NLCP_KERNEL_PATCHES:=$(PROGRESS_DIR)/nlcp.kernel.patched
PROGRESS_NLCP_MYDROID_PATCHES:=$(PROGRESS_DIR)/nlcp.mydroid.patched

################################################################################
# rules
################################################################################

nlcp-private-pre-bringup-validation:
	@$(ECHO) "nlcp pre-bringup validation passed..."
	
nlcp-private-pre-make-validation:
	@$(ECHO) "nlcp pre-make validation passed..."

WL12xx_REPO:=$(NLCP_MAIN_REPO)/wl12xx.git
WL12xx_DIR:=$(WORKSPACE_DIR)/wl12xx
WL12xx_BRANCH:=r5_3.2
WL12xx_TAG:=$(NLCP_RELEASE_VERSION)

PROGRESS_NLCP_FETCH_WL12xx:=$(PROGRESS_DIR)/nlcp.wl12xx.fetched
PROGRESS_NLCP_BRINGUP_WL12xx:=$(PROGRESS_DIR)/nlcp.wl12xx.bringup

$(PROGRESS_NLCP_FETCH_WL12xx):
	@$(ECHO) "getting wl12xx repository..."
	git clone $(WL12xx_REPO) $(WL12xx_DIR)
	@$(ECHO) "...done"
	@$(call echo-to-file, "DONE", $(PROGRESS_NLCP_FETCH_WL12xx))
	@$(call print, "wl12xx repository fetched")
	
$(PROGRESS_NLCP_BRINGUP_WL12xx): $(PROGRESS_NLCP_FETCH_WL12xx)
	@$(ECHO) "wl12xx bringup..."
	cd $(WL12xx_DIR) ; git checkout origin/$(WL12xx_BRANCH) -b $(WL12xx_BRANCH)
	cd $(WL12xx_DIR) ; git reset --hard $(WL12xx_TAG)
	@$(ECHO) "...done"
	@$(call echo-to-file, "DONE", $(PROGRESS_NLCP_BRINGUP_WL12xx))
	@$(call print, "wl12xx bringup done")

COMPAT_DIR:=$(WORKSPACE_DIR)/compat
COMPAT_REPO:=git://github.com/mcgrof/compat.git
COMPAT_BRANCH:=
COMPAT_HASH:=984ab77279488f3fea4436da76c0f81a618cef1b

PROGRESS_NLCP_FETCH_COMPAT:=$(PROGRESS_DIR)/nlcp.compat.fetched
PROGRESS_NLCP_BRINGUP_COMPAT:=$(PROGRESS_DIR)/nlcp.compat.bringup

$(PROGRESS_NLCP_FETCH_COMPAT):
	@$(ECHO) "getting compat repository..."
	git clone $(COMPAT_REPO) $(COMPAT_DIR)
	@$(ECHO) "...done"
	@$(call echo-to-file, "DONE", $(PROGRESS_NLCP_FETCH_COMPAT))
	@$(call print, "compat repository fetched")
	
$(PROGRESS_NLCP_BRINGUP_COMPAT): $(PROGRESS_NLCP_FETCH_COMPAT)
	@$(ECHO) "compat bringup..."
	cd $(COMPAT_DIR) ; git reset --hard $(COMPAT_HASH)
	@$(ECHO) "...done"
	@$(call echo-to-file, "DONE", $(PROGRESS_NLCP_BRINGUP_COMPAT))
	@$(call print, "compat bringup done")

COMPAT_WIRELESS_DIR:=$(WORKSPACE_DIR)/compat-wireless
COMPAT_WIRELESS_REPO:=git://github.com/mcgrof/compat-wireless.git
COMPAT_WIRELESS_BRANCH:=
COMPAT_WIRELESS_HASH:=22c9e40fe140f32a342810fe82a390a6df7827f1

PROGRESS_NLCP_FETCH_COMPAT_WIRELESS:=$(PROGRESS_DIR)/nlcp.compat-wireless.fetched
PROGRESS_NLCP_BRINGUP_COMPAT_WIRELESS:=$(PROGRESS_DIR)/nlcp.compat-wireless.bringup

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
	cd $(COMPAT_WIRELESS_DIR) ; git reset --hard $(COMPAT_WIRELESS_HASH)
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
HOSTAP_BRANCH:=p-ics-mr0
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
	cd $(HOSTAP_DIR) ; git reset --hard $(NLCP_RELEASE_VERSION)
	@$(ECHO) "updating nl80211 interface from driver code"
	$(COPY) $(WL12xx_DIR)/include/linux/nl80211.h $(HOSTAP_DIR)/src/drivers/nl80211_copy.h
	@$(ECHO) "...done"
	@$(call echo-to-file, "DONE", $(PROGRESS_NLCP_BRINGUP_HOSTAP))
	@$(call print, "hostapd/supplicant bringup done")

LIBNL_REPO:=$(NLCP_MAIN_REPO)/libnl.git
LIBNL_DIR:=$(MYDROID)/system/core/libnl_2
LIBNL_REMOTE_NAME:=ti-wcs
LIBNL_BRANCH:=ics
LIBNL_TAG:=

PROGRESS_NLCP_FETCH_LIBNL:=$(PROGRESS_DIR)/nlcp.libnl.fetched
PROGRESS_NLCP_BRINGUP_LIBNL:=$(PROGRESS_DIR)/nlcp.libnl.bringup

$(PROGRESS_NLCP_FETCH_LIBNL): $(PROGRESS_BRINGUP_MYDROID)
	@$(ECHO) "getting libnl..."
	cd $(LIBNL_DIR) ; \
	git remote add $(LIBNL_REMOTE_NAME) $(LIBNL_REPO) ; \
	git fetch $(LIBNL_REMOTE_NAME) 
	@$(ECHO) "...done"
	@$(call echo-to-file, "DONE", $(PROGRESS_NLCP_FETCH_LIBNL))
	@$(call print, "libnl repository fetched")
	
$(PROGRESS_NLCP_BRINGUP_LIBNL): $(PROGRESS_NLCP_FETCH_LIBNL)
	@$(ECHO) "libnl update..."
	cd $(LIBNL_DIR) ; git checkout $(LIBNL_REMOTE_NAME)/$(LIBNL_BRANCH) -b $(LIBNL_BRANCH)
	cd $(LIBNL_DIR) ; git reset --hard $(LIBNL_TAG) 
	@$(ECHO) "...done"
	@$(call echo-to-file, "DONE", $(PROGRESS_NLCP_BRINGUP_LIBNL))
	@$(call print, "libnl bringup done")

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

$(PROGRESS_NLCP_MYDROID_PATCHES): \
				$(PROGRESS_BRINGUP_MYDROID) \
				$(PROGRESS_NLCP_BRINGUP_WL12xx) \
				$(PROGRESS_NLCP_BRINGUP_HOSTAP) \
				$(PROGRESS_NLCP_BRINGUP_LIBNL) \
				$(PROGRESS_NLCP_BRINGUP_IW) \
				$(PROGRESS_NLCP_BRINGUP_TI_UTILS)
	@$(ECHO) "patching android for nlcp..."

#	cd $(MYDROID)/system/core/libnl_2; \
#		git am $(NLCP_ANDROID_PATCHES)/patches/system/core/libnl_2/*.patch
#	cd $(MYDROID)/device/ti/blaze ; \
#		git am $(NLCP_ANDROID_PATCHES)/patches/device/ti/blaze/*.patch

	@$(ECHO) "copying additional packages to mydroid directory..."
	$(MKDIR) -p $(TRASH_DIR)/hardware/wlan
	$(MKDIR) -p $(MYDROID)/hardware/wlan
	# add an recursive Android.mk to new mydroid/hardware/wlan directory
	if [ -f $(MYDROID)/hardware/wlan/Android.mk ] ; then $(MOVE) $(MYDROID)/hardware/wlan/Android.mk $(TRASH_DIR)/hardware/wlan/ ; fi
	$(COPY) -r $(NLCP_ANDROID_PATCHES)/packages/hardware/wlan/Android.mk $(MYDROID)/hardware/wlan/Android.mk
	# add the firmware install project (only Android.mk, the binaries are copied during 'nlcp-update-firmware-files')
	if [ -d $(MYDROID)/hardware/wlan/fw ] ; then $(MOVE) $(MYDROID)/hardware/wlan/fw $(TRASH_DIR)/hardware/wlan/ ; fi
	$(COPY) -r $(NLCP_ANDROID_PATCHES)/packages/hardware/wlan/fw $(MYDROID)/hardware/wlan/fw
	# add the kernel objects install project (only Android.mk, the binaries are copied during 'nlcp-make-private')
	if [ -d $(MYDROID)/hardware/wlan/ko ] ; then $(MOVE) $(MYDROID)/hardware/wlan/ko $(TRASH_DIR)/hardware/wlan/ ; fi
	$(COPY) -r $(NLCP_ANDROID_PATCHES)/packages/hardware/wlan/ko $(MYDROID)/hardware/wlan/ko

	$(MKDIR) -p $(TRASH)/hardware/ti/wlan/mac80211
	# remove omap's ti-utils project from ics
	if [ -d $(MYDROID)/hardware/ti/wlan/mac80211/ti-utils ] ; then $(MOVE) $(MYDROID)/hardware/ti/wlan/mac80211/ti-utils $(TRASH_DIR)/hardware/ti/wlan/mac80211/ ; fi
#	# remove the mac80211 config folder
#	if [ -d $(MYDROID)/hardware/ti/wlan/mac80211/config ] ; then $(MOVE) $(MYDROID)/hardware/ti/wlan/mac80211/config $(TRASH_DIR)$(MYDROID)/hardware/ti/wlan/mac80211/ ; fi
	
	# update hostapd.conf to $(MYDROID)/hardware/ti/wlan/mac80211/config project
	$(COPY) $(NLCP_BINARIES_PATH)/system/etc/wifi/hostapd.conf $(MYDROID)/hardware/ti/wlan/mac80211/config

	@$(ECHO) "...done"
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
	cd $(TI_UTILS_DIR); git pull origin $(TI_UTILS_BRANCH)
	cd $(IW_DIR); 		git pull origin $(IW_BRANCH)
	cd $(WL12xx_DIR); 	git pull origin $(WL12xx_BRANCH)
	cd $(LIBNL_DIR); 	git pull $(LIBNL_REMOTE_NAME) $(LIBNL_BRANCH)
	cd $(HOSTAP_DIR); 	git pull $(HOSTAP_REMOTE_NAME) $(HOSTAP_BRANCH)
	$(MAKE) nlcp-update-firmware-files

nlcp-bringup-private: 	$(PROGRESS_NLCP_BRINGUP_WL12xx) \
			$(PROGRESS_NLCP_BRINGUP_COMPAT) \
			$(PROGRESS_NLCP_BRINGUP_COMPAT_WIRELESS) \
			$(PROGRESS_NLCP_KERNEL_PATCHES) \
			$(PROGRESS_NLCP_MYDROID_PATCHES)
	@$(ECHO) "nlcp bringup..."
	cd $(COMPAT_WIRELESS_DIR) ; sh ./scripts/admin-refresh.sh
	cd $(COMPAT_WIRELESS_DIR) ; ./scripts/driver-select wl12xx
	touch $(COMPAT_WIRELESS_DIR)/drivers/net/Makefile
	@$(ECHO) "...done"

	
nlcp-make-private:	$(PROGRESS_NLCP_BRINGUP_COMPAT) \
			$(PROGRESS_NLCP_BRINGUP_COMPAT_WIRELESS) \
			$(PROGRESS_NLCP_BRINGUP_WL12xx) \
			nlcp-update-firmware-files
	@$(ECHO) "nlcp make..."
	cd $(COMPAT_WIRELESS_DIR) ; sh ./scripts/admin-refresh.sh
	cd $(COMPAT_WIRELESS_DIR) ; ./scripts/driver-select wl12xx
	touch $(COMPAT_WIRELESS_DIR)/drivers/net/Makefile
	$(MAKE) -C $(COMPAT_WIRELESS_DIR) KLIB=$(KERNEL_DIR) KLIB_BUILD=$(KERNEL_DIR) -j$(NTHREADS)
	$(FIND) $(COMPAT_WIRELESS_DIR) -name "*.ko" -exec $(COPY) {}  $(MYDROID)/hardware/wlan/ko \;
	@$(ECHO) "...done"

#NLCP_KO_TARGET_PATH:=$(MYFS_SYSTEM_PATH)/lib/modules
NLCP_KO_TARGET_PATH:=$(MYDROID)/hardware/wlan/ko

nlcp-install-private:
	@$(ECHO) "nlcp install..."
#	$(MKDIR) -p $(NLCP_KO_TARGET_PATH)
#	@$(ECHO) "copy modules from compat-wireless"
#	$(FIND) $(COMPAT_WIRELESS_DIR) -name "*.ko" -exec cp -f {}  $(NLCP_KO_TARGET_PATH) \;
#	@$(ECHO) "copy modules from kernel"
#	$(FIND) $(KERNEL_DIR)/drivers/staging -name "*.ko" -exec cp -v {} $(NLCP_KO_TARGET_PATH) \;
	@$(ECHO) "...done"
	
nlcp-clean-private:
	@$(ECHO) "nlcp clean..."
	cd $(COMPAT_WIRELESS_DIR) ; sh ./scripts/admin-clean.sh
	$(FIND) $(MYDROID)/hardware/wlan/ko -name "*.ko" -exec $(DEL) {} \;
	@$(ECHO) "...done"

