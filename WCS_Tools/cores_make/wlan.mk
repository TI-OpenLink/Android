################################################################################
#
# wlan.mk
#
# Makefile for Android project integrated with WLAN
#
# Android Version	:	L27.IS.1 OMAP4 Icecream Sandwich
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
# wlan make arguments
################################################################################

include defs.mk

WLAN_PATCHES_PATH:=$(PATCHES_PATH)/wlan/nlcp
WLAN_KERNEL_PATCHES:=$(WLAN_PATCHES_PATH)/kernel
WLAN_ANDROID_PATCHES:=$(WLAN_PATCHES_PATH)/android/patches
WLAN_BINARIES_PATH:=$(WLAN_PATCHES_PATH)/binaries

WLAN_ROOT_DIR:=$(WORKSPACE_DIR)/wlan

WL12xx_DIR:=$(WLAN_ROOT_DIR)/wl12xx
WLAN_COMPAT_DIR:=$(WLAN_ROOT_DIR)/compat
WLAN_COMPAT_WIRELESS_DIR:=$(WLAN_ROOT_DIR)/compat-wireless

HOSTAP_DIR:=$(MYDROID)/external/wpa_supplicant_8
TI_UTILS_DIR:=$(MYDROID)/external/ti-utils
IW_DIR:=$(MYDROID)/external/iw
LIBNL_DIR:=$(MYDROID)/system/core/libnl_2
WL12xx_KO_INSTALLER:=$(MYDROID)/external/wl12xx_ko_installer
WL12xx_TARGET_SCRIPTS:=$(MYDROID)/external/wl12xx_target_scripts

PROGRESS_WLAN_KERNEL_PATCHES:=$(PROGRESS_DIR)/wlan.kernel.patched
PROGRESS_WLAN_MYDROID_PATCHES:=$(PROGRESS_DIR)/wlan.mydroid.patched
PROGRESS_WLAN_FETCH_OL_MANIFEST:=$(PROGRESS_DIR)/wlan.ti-ol-driver-manifest.fetched
PROGRESS_WLAN_BRINGUP_OL_MANIFEST:=$(PROGRESS_DIR)/wlan.ti-ol-driver-manifest.bringup

WLAN_GIT_COMPAT_TREE:=$(WLAN_COMPAT_DIR)
WLAN_GIT_TREE:=$(WL12xx_DIR)

################################################################################
# rules
################################################################################

wlan-private-pre-bringup-validation:
	@$(ECHO) "wlan pre-bringup validation passed..."
	
wlan-private-pre-make-validation:
	@$(ECHO) "wlan pre-make validation passed..."

$(PROGRESS_WLAN_FETCH_OL_MANIFEST):
	@$(ECHO) "getting ti-ol-driver-manifest repository..."
	git clone $(WLAN_DRIVER_MANIFEST_REPO) $(WLAN_DRIVER_MANIFEST_DIR)
	@$(ECHO) "...done"
	@$(call echo-to-file, "DONE", $(PROGRESS_WLAN_FETCH_OL_MANIFEST))
	@$(call print, "ti-ol-manifest repository fetched")
	
$(PROGRESS_WLAN_BRINGUP_OL_MANIFEST): $(PROGRESS_WLAN_FETCH_OL_MANIFEST)
	@$(ECHO) "ti-ol-driver-manifest bringup..."
	cd $(WLAN_DRIVER_MANIFEST_DIR) ; \
	git checkout $(WLAN_DRIVER_MANIFEST_BRANCH) ; \
	git reset --hard $(WLAN_DRIVER_MANIFEST_HASH)
	@$(ECHO) "...done"
	@$(call echo-to-file, "DONE", $(PROGRESS_WLAN_BRINGUP_OL_MANIFEST))
	@$(call print, "ti-ol-manifest bringup done")
	
$(PROGRESS_WLAN_KERNEL_PATCHES): $(PROGRESS_BRINGUP_KERNEL)
	@$(ECHO) "patching kernel for wlan..."
	# add dynamic debug support
	cd $(KERNEL_DIR) ; $(PATCH) -p1 <  $(WLAN_KERNEL_PATCHES)/blaze.config.patch
	@$(ECHO) "...done"
	@$(call echo-to-file, "DONE", $(PROGRESS_WLAN_KERNEL_PATCHES))
	@$(call print, "wlan kernel patches done")	

$(PROGRESS_WLAN_MYDROID_PATCHES):
	@$(ECHO) "patching android for wlan..."
	
	# patch libnl
	cd $(LIBNL_DIR) ; git am $(WLAN_ANDROID_PATCHES)/system/core/*.patch

	# remove omap's ti-utils project from ics
	$(MKDIR) -p $(TRASH_DIR)/mydroid/hardware/ti/wlan/mac80211
	if [ -d $(MYDROID)/hardware/ti/wlan/mac80211/ti-utils ] ; then $(MOVE) $(MYDROID)/hardware/ti/wlan/mac80211/ti-utils $(TRASH_DIR)/mydroid/hardware/ti/wlan/mac80211/ ; fi

	# update hostapd.conf to $(MYDROID)/hardware/ti/wlan/mac80211/config project
	$(COPY) $(WLAN_BINARIES_PATH)/system/etc/wifi/hostapd.conf $(MYDROID)/hardware/ti/wlan/mac80211/config

	@$(ECHO) "...done"
	@$(call echo-to-file, "DONE", $(PROGRESS_WLAN_MYDROID_PATCHES))
	@$(call print, "android patches and packages done")
	
wlan-bringup-private: 	$(PROGRESS_WLAN_BRINGUP_OL_MANIFEST) \
						$(PROGRESS_WLAN_KERNEL_PATCHES) \
						$(PROGRESS_WLAN_MYDROID_PATCHES)
	@$(ECHO) "wlan bringup..."
	$(MKDIR) -p $(WLAN_ROOT_DIR)
	cd $(WLAN_ROOT_DIR) ; \
	repo init -u $(WLAN_DRIVER_MANIFEST_DIR) -b $(WLAN_DRIVER_MANIFEST_BRANCH) -m $(WLAN_DRIVER_MANIFEST_NAME) $(REPO_INIT_DEF_PARAMS) ; \
	repo sync --no-repo-verify
	
	export GIT_TREE=$(WLAN_GIT_TREE) ; \
	export GIT_COMPAT_TREE=$(WLAN_GIT_COMPAT_TREE) ; \
	cd $(WLAN_COMPAT_WIRELESS_DIR) ; sh ./scripts/admin-refresh.sh ; \
	cd $(WLAN_COMPAT_WIRELESS_DIR) ; ./scripts/driver-select wl12xx
	$(TOUCH) $(WLAN_COMPAT_WIRELESS_DIR)/drivers/net/Makefile
	@$(ECHO) "...done"

wlan-make-private:
	@$(ECHO) "wlan make..."
	export GIT_TREE=$(WLAN_GIT_TREE) ; \
	export GIT_COMPAT_TREE=$(WLAN_GIT_COMPAT_TREE) ; \
	cd $(WLAN_COMPAT_WIRELESS_DIR) ; sh ./scripts/admin-refresh.sh ; \
	cd $(WLAN_COMPAT_WIRELESS_DIR) ; ./scripts/driver-select wl12xx
	$(TOUCH) $(WLAN_COMPAT_WIRELESS_DIR)/drivers/net/Makefile
	$(MAKE) -C $(WLAN_COMPAT_WIRELESS_DIR) KLIB=$(KERNEL_DIR) KLIB_BUILD=$(KERNEL_DIR) -j$(NTHREADS)
	$(FIND) $(WLAN_COMPAT_WIRELESS_DIR) -name "*.ko" -exec $(COPY) {} $(WL12xx_KO_INSTALLER) \;
	@$(ECHO) "...done"

wlan-install-private:
	@$(ECHO) "wlan install..."
	@$(ECHO) "...done"
	
wlan-clean-private:
	@$(ECHO) "wlan clean..."
	cd $(WLAN_COMPAT_WIRELESS_DIR) ; sh ./scripts/admin-clean.sh
	$(FIND) $(WL12xx_KO_INSTALLER) -name "*.ko" -exec $(DEL) {} \;
	@$(ECHO) "...done"

