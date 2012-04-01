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
include $(WIIST_PATH)/repo.mk

WLAN_PATCHES_PATH:=$(PATCHES_PATH)/wlan/nlcp

WLAN_DRIVER_PATCHES:=$(WLAN_PATCHES_PATH)/driver
WLAN_KERNEL_PATCHES:=$(WLAN_PATCHES_PATH)/kernel
WLAN_COMPAT_WIRELESS_PATCHES:=$(WLAN_PATCHES_PATH)/compat-wireless
WLAN_ANDROID_PATCHES:=$(WLAN_PATCHES_PATH)/android/patches
WLAN_BINARIES_PATH:=$(WLAN_PATCHES_PATH)/binaries

WLAN_IBI_PATCHES:=$(WLAN_PATCHES_PATH)/ibi
WLAN_IBI_DRIVER_PATCHES:=$(WLAN_IBI_PATCHES)/driver
WLAN_IBI_KERNEL_PATCHES:=$(WLAN_IBI_PATCHES)/kernel

WLAN_ROOT_DIR:=$(WORKSPACE_DIR)/wlan
WLCORE_DIR:=$(WLAN_ROOT_DIR)/wl12xx
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

PROGRESS_WLAN_DRIVER_FETCH:=$(PROGRESS_DIR)/wlan.driver.fetched
PROGRESS_WLAN_COMPAT_BRINGUP:=$(PROGRESS_DIR)/wlan.compat.bringup
PROGRESS_WLAN_IBI_BRINGUP:=$(PROGRESS_DIR)/wlan.ibi.bringup

WLAN_GIT_COMPAT_TREE:=$(WLAN_COMPAT_DIR)
WLAN_GIT_TREE:=$(WLCORE_DIR)

################################################################################
# rules
################################################################################

.PHONY += 	wlan-private-pre-bringup-validation \
			wlan-private-pre-make-validation 

wlan-private-pre-bringup-validation:
	@$(ECHO) "wlan pre-bringup validation passed..."
	
wlan-private-pre-make-validation:
	@$(ECHO) "wlan pre-make validation passed..."

$(PROGRESS_WLAN_KERNEL_PATCHES): $(PROGRESS_BRINGUP_KERNEL)
	@$(ECHO) "patching kernel for wlan..."
	cd $(KERNEL_DIR) ; git am $(WLAN_KERNEL_PATCHES)/0001-mmc-recognise-SDIO-cards-with-SDIO_CCCR_REV-3.00.patch
	# add dynamic debug support
	cd $(KERNEL_DIR) ; $(PATCH) -p1 <  $(WLAN_KERNEL_PATCHES)/blaze.config.patch
	@$(ECHO) "...done"
	@$(call echo-to-file, "DONE", $(PROGRESS_WLAN_KERNEL_PATCHES))
	@$(call print, "wlan kernel patches done")	

$(PROGRESS_WLAN_MYDROID_PATCHES): $(PROGRESS_BRINGUP_MYDROID)
	@$(ECHO) "patching android for wlan..."	
	# patch libnl
	cd $(LIBNL_DIR) ; git am $(WLAN_ANDROID_PATCHES)/system/core/*.patch	
	# patch BoardConfig.mk
	cd $(MYDROID)/device/ti/blaze ; git am $(WLAN_ANDROID_PATCHES)/device/ti/blaze/*.patch
	cd $(MYDROID)/device/ti/blaze_tablet ; git am $(WLAN_ANDROID_PATCHES)/device/ti/blaze_tablet/*.patch	
	
	# remove omap's firmware project from ics
	$(MKDIR) -p $(TRASH_DIR)/mydroid/device/ti/proprietary-open
	if [ -d $(MYDROID)/device/ti/proprietary-open/wl12xx ] ; then $(MOVE) $(MYDROID)/device/ti/proprietary-open/wl12xx $(TRASH_DIR)/mydroid/device/ti/proprietary-open/ ; fi
	# remove omap's ti-utils project from ics
	$(MKDIR) -p $(TRASH_DIR)/mydroid/hardware/ti/wlan/mac80211
	if [ -d $(MYDROID)/hardware/ti/wlan/mac80211/ti-utils ] ; then $(MOVE) $(MYDROID)/hardware/ti/wlan/mac80211/ti-utils $(TRASH_DIR)/mydroid/hardware/ti/wlan/mac80211/ ; fi
	# update hostapd.conf to $(MYDROID)/hardware/ti/wlan/mac80211/config project
	$(COPY) $(WLAN_BINARIES_PATH)/system/etc/wifi/hostapd.conf $(MYDROID)/hardware/ti/wlan/mac80211/config

	@$(ECHO) "...done"
	@$(call echo-to-file, "DONE", $(PROGRESS_WLAN_MYDROID_PATCHES))
	@$(call print, "android patches and packages done")
	
$(PROGRESS_WLAN_DRIVER_FETCH): $(PROGRESS_BRINGUP_WLAN_MANIFEST)
	$(MKDIR) -p $(WLAN_ROOT_DIR)
	cd $(WLAN_ROOT_DIR) ; \
	repo init -u $(WLAN_MANIFEST_DIR) -b $(WLAN_MANIFEST_BRANCH) -m $(WLAN_DRIVER_MANIFEST_NAME) $(REPO_INIT_DEF_PARAMS) ; \
	repo sync $(REPO_SYNC_DEF_PARAMS)
	@$(call echo-to-file, "DONE", $(PROGRESS_WLAN_DRIVER_FETCH))
	@$(call print, "wlan driver components fetched")
	
$(PROGRESS_WLAN_COMPAT_BRINGUP): $(PROGRESS_WLAN_DRIVER_FETCH)
	@$(ECHO) "compat-wireless bringup for wlcore..."		
#	cd $(WLAN_COMPAT_WIRELESS_DIR) ; \
	if [ -f patches/06-header-changes.patch ] ; then $(DEL) patches/06-header-changes.patch ; fi ; \
	if [ -f patches/09-threaded-irq.patch ] ; then $(DEL) patches/09-threaded-irq.patch ; fi ; \
	if [ -f patches/11-dev-pm-ops.patch ] ; then $(DEL) patches/11-dev-pm-ops.patch ; fi ; \
	if [ -f patches/25-multicast-list_head.patch ] ; then $(DEL) patches/25-multicast-list_head.patch ; fi ; \
	if [ -f patches/40-netdev-hw-features.patch ] ; then $(DEL) patches/40-netdev-hw-features.patch ; fi ; \
	if [ -f patches/45-remove-platform-id-table.patch ] ; then $(DEL) patches/45-remove-platform-id-table.patch ; fi ; \
	if [ -f patches/48-use_skb_get_queue_mapping.patch ] ; then $(DEL) patches/48-use_skb_get_queue_mapping.patch ; fi ; \
	if [ -f patches/99-change-makefiles.patch ] ; then $(DEL) patches/99-change-makefiles.patch ; fi ;
	@$(ECHO) "...done"
	@$(call echo-to-file, "DONE", $(PROGRESS_WLAN_COMPAT_BRINGUP))
	@$(call print, "compat-wireless patched and ready for wlcore")
	
wlan-bringup-private: 	$(PROGRESS_BRINGUP_WLAN_MANIFEST) \
						$(PROGRESS_WLAN_KERNEL_PATCHES) \
						$(PROGRESS_WLAN_MYDROID_PATCHES) \
						$(PROGRESS_WLAN_DRIVER_FETCH) \
						$(PROGRESS_WLAN_COMPAT_BRINGUP)
	@$(ECHO) "wlan bringup..."
	@$(ECHO) "starting branches"
	sh $(SCRIPTS_PATH)/start_ti-ol_components.sh
	export GIT_TREE=$(WLAN_GIT_TREE) ; \
	export GIT_COMPAT_TREE=$(WLAN_GIT_COMPAT_TREE) ; \
	cd $(WLAN_COMPAT_WIRELESS_DIR) ; \
	sh ./scripts/admin-refresh.sh ; \
	./scripts/driver-select wl12xx
	$(TOUCH) $(WLAN_COMPAT_WIRELESS_DIR)/drivers/net/Makefile
	@$(ECHO) "...done"

wlan-make-private:
	@$(ECHO) "wlan make..."
	export GIT_TREE=$(WLAN_GIT_TREE) ; \
	export GIT_COMPAT_TREE=$(WLAN_GIT_COMPAT_TREE) ; \
	cd $(WLAN_COMPAT_WIRELESS_DIR) ; \
	sh ./scripts/admin-refresh.sh ; \
	./scripts/driver-select wl12xx
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
	
wlan-update-codebase-private: $(PROGRESS_BRINGUP_WLAN_MANIFEST)
	cd $(WLAN_MANIFEST_DIR) ; \
	git reset --hard $(WLAN_MANIFEST_HASH)
	$(MAKE) mydroid-create-local-manifest
	$(DEL) $(PROGRESS_WLAN_DRIVER_FETCH)
	$(MAKE) $(PROGRESS_WLAN_DRIVER_FETCH)
	cd $(MYDROID) ; repo sync $(REPO_SYNC_DEF_PARAMS)
	if [ -f $(PROGRESS_WLAN_MYDROID_PATCHES) ] ; then $(DEL) $(PROGRESS_WLAN_MYDROID_PATCHES) ; fi
	$(MAKE) $(PROGRESS_WLAN_MYDROID_PATCHES)

