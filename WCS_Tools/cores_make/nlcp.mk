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

NLCP_RELEASE_VERSION:=ol_R5.00.04
NLCP_SP_VERSION:=
NLCP_MAIN_REPO:=git://github.com/TI-OpenLink

NLCP_PATCHES_PATH:=$(PATCHES_PATH)/wlan/nlcp
NLCP_WL12xx_PATCHES_DIR:=$(NLCP_PATCHES_PATH)/r4/wl12xx
NLCP_COMPAT_PATCHES_DIR:=$(NLCP_PATCHES_PATH)/r4/compat
NLCP_COMPAT_WIRELESS_PATCHES_DIR:=$(NLCP_PATCHES_PATH)/r4/compat-wireless
NLCP_KERNEL_PATCHES:=$(NLCP_PATCHES_PATH)/kernel
NLCP_ANDROID_PATCHES:=$(NLCP_PATCHES_PATH)/android

NLCP_BINARIES_PATH=$(NLCP_PATCHES_PATH)/binaries

################################################################################
# rules
################################################################################

nlcp-private-pre-bringup-validation:
	@$(ECHO) "nlcp pre-bringup validation passed..."
	
nlcp-private-pre-make-validation:
	@$(ECHO) "nlcp pre-make validation passed..."

OL_MANIFEST_REPO:=$(NLCP_MAIN_REPO)/ti-ol-manifest.git
OL_MANIFEST_BRANCH:=master
OL_MANIFEST_FILE:=TI-OpenLink-R5.00.xx.xml

WL12xx_MANIFEST_REPO:=git://github.com/TI-OpenLink/ti-ol-manifest.git

OL_MANIFEST_DIR:=$(WORKSPACE_DIR)/ti-ol-manifest
WL12xx_DIR:=$(WORKSPACE_DIR)/wl12xx
COMPAT_DIR:=$(WORKSPACE_DIR)/compat
COMPAT_WIRELESS_DIR:=$(WORKSPACE_DIR)/compat-wireless
HOSTAP_DIR:=$(MYDROID)/external/wpa_supplicant_8
TI_UTILS_DIR:=$(MYDROID)/external/ti-utils
IW_DIR:=$(MYDROID)/external/iw
LIBNL_DIR:=$(MYDROID)/system/core/libnl_2

PROGRESS_NLCP_KERNEL_PATCHES:=$(PROGRESS_DIR)/nlcp.kernel.patched
PROGRESS_NLCP_MYDROID_PATCHES:=$(PROGRESS_DIR)/nlcp.mydroid.patched
PROGRESS_NLCP_FETCH_OL_MANIFEST:=$(PROGRESS_DIR)/nlcp.ti-ol-manifest.fetched
PROGRESS_NLCP_BRINGUP_OL_MANIFEST:=$(PROGRESS_DIR)/nlcp.ti-ol-manifest.bringup

GIT_COMPAT_TREE:=$(COMPAT_DIR)
GIT_TREE:=$(WL12xx_DIR)

export GIT_COMPAT_TREE
export GIT_TREE

$(PROGRESS_NLCP_FETCH_OL_MANIFEST):
	@$(ECHO) "getting ti-ol-manifest repository..."
	git clone $(OL_MANIFEST_REPO) $(OL_MANIFEST_DIR)
	@$(ECHO) "...done"
	@$(call echo-to-file, "DONE", $(PROGRESS_NLCP_FETCH_OL_MANIFEST))
	@$(call print, "ti-ol-manifest repository fetched")
	
$(PROGRESS_NLCP_BRINGUP_OL_MANIFEST): $(PROGRESS_NLCP_FETCH_OL_MANIFEST)
	@$(ECHO) "ti-ol-manifest bringup..."
	@$(ECHO) "...done"
	@$(call echo-to-file, "DONE", $(PROGRESS_NLCP_BRINGUP_OL_MANIFEST))
	@$(call print, "ti-ol-manifest bringup done")

$(PROGRESS_NLCP_KERNEL_PATCHES): $(PROGRESS_BRINGUP_KERNEL)
	@$(ECHO) "patching kernel for nlcp..."
	# add dynamic debug support
	cd $(KERNEL_DIR) ; $(PATCH) -p1 <  $(NLCP_KERNEL_PATCHES)/blaze.config.patch
	@$(ECHO) "...done"
	@$(call echo-to-file, "DONE", $(PROGRESS_NLCP_KERNEL_PATCHES))
	@$(call print, "nlcp kernel patches done")	

$(PROGRESS_NLCP_MYDROID_PATCHES):
	@$(ECHO) "patching android for nlcp..."

	@$(ECHO) "copying additional packages to mydroid directory..."
	# add an recursive Android.mk to new mydroid/hardware/wlan directory
	$(MKDIR) -p $(TRASH_DIR)/hardware/wlan
	$(MKDIR) -p $(MYDROID)/hardware/wlan
	if [ -f $(MYDROID)/hardware/wlan/Android.mk ] ; then $(MOVE) $(MYDROID)/hardware/wlan/Android.mk $(TRASH_DIR)/hardware/wlan/ ; fi
	$(COPY) $(NLCP_ANDROID_PATCHES)/packages/hardware/wlan/Android.mk $(MYDROID)/hardware/wlan/Android.mk

	# remove omap's hostap project (wpa_supplicant_8) from ics
	$(MKDIR) -p $(TRASH_DIR)/mydroid/external
	if [ -d $(MYDROID)/external/wpa_supplicant_8 ] ; then $(MOVE) $(MYDROID)/external/wpa_supplicant_8 $(TRASH_DIR)/mydroid/external/ ; fi
	# remove omap's system/core/libnl_2 project
	$(MKDIR) -p $(TRASH_DIR)/system
	if [ -d $(MYDROID)/system/core ] ; then $(MOVE) $(MYDROID)/system/core $(TRASH_DIR)/system/ ; fi

	# remove omap's ti-utils project from ics
	$(MKDIR) -p $(TRASH_DIR)/mydroid/hardware/ti/wlan/mac80211
	if [ -d $(MYDROID)/hardware/ti/wlan/mac80211/ti-utils ] ; then $(MOVE) $(MYDROID)/hardware/ti/wlan/mac80211/ti-utils $(TRASH_DIR)/mydroid/hardware/ti/wlan/mac80211/ ; fi

	# update hostapd.conf to $(MYDROID)/hardware/ti/wlan/mac80211/config project
	$(COPY) $(NLCP_BINARIES_PATH)/system/etc/wifi/hostapd.conf $(MYDROID)/hardware/ti/wlan/mac80211/config

	@$(ECHO) "...done"
	@$(call echo-to-file, "DONE", $(PROGRESS_NLCP_MYDROID_PATCHES))
	@$(call print, "android patches and packages done")

nlcp-bringup-private: 	$(PROGRESS_NLCP_BRINGUP_OL_MANIFEST) \
						$(PROGRESS_NLCP_KERNEL_PATCHES) \
						$(PROGRESS_NLCP_MYDROID_PATCHES)
	@$(ECHO) "nlcp bringup..."
	repo init -u $(OL_MANIFEST_DIR) -b master -m $(OL_MANIFEST_FILE) --repo-branch=$(OMAP_REPO_BRANCH) --repo-url=$(OMAP_REPO_TOOL) --quiet --no-repo-verify
	repo sync --no-repo-verify
	cd $(COMPAT_WIRELESS_DIR) ; sh ./scripts/admin-refresh.sh
	cd $(COMPAT_WIRELESS_DIR) ; ./scripts/driver-select wl12xx
	$(TOUCH) $(COMPAT_WIRELESS_DIR)/drivers/net/Makefile
	@$(ECHO) "...done"

nlcp-make-private:
	@$(ECHO) "nlcp make..."
	cd $(COMPAT_WIRELESS_DIR) ; sh ./scripts/admin-refresh.sh
	cd $(COMPAT_WIRELESS_DIR) ; ./scripts/driver-select wl12xx
	$(TOUCH) $(COMPAT_WIRELESS_DIR)/drivers/net/Makefile
	$(MAKE) -C $(COMPAT_WIRELESS_DIR) KLIB=$(KERNEL_DIR) KLIB_BUILD=$(KERNEL_DIR) -j$(NTHREADS)
	$(FIND) $(COMPAT_WIRELESS_DIR) -name "*.ko" -exec $(COPY) {}  $(MYDROID)/hardware/wlan/ko \;
	@$(ECHO) "...done"

nlcp-install-private:
	@$(ECHO) "nlcp install..."
	@$(ECHO) "...done"
	
nlcp-clean-private:
	@$(ECHO) "nlcp clean..."
	cd $(COMPAT_WIRELESS_DIR) ; sh ./scripts/admin-clean.sh
	$(FIND) $(MYDROID)/hardware/wlan/ko -name "*.ko" -exec $(DEL) {} \;
	@$(ECHO) "...done"

#nlcp-invoke-fetch-private:	$(PROGRESS_NLCP_BRINGUP_WL12xx) \
#				$(PROGRESS_NLCP_KERNEL_PATCHES) \
#				$(PROGRESS_NLCP_MYDROID_PATCHES)
#	cd $(CRDA_DIR); 	git fetch
#	cd $(LIBNL_DIR); 	git fetch
#	cd $(TI_UTILS_DIR);	git fetch
#	cd $(IW_DIR); 		git fetch
#	cd $(HOSTAP_DIR); 	git fetch
#	cd $(WL12xx_DIR); 	git fetch
#
#nlcp-sync-ver-private:	$(PROGRESS_NLCP_BRINGUP_WL12xx) \
#			$(PROGRESS_NLCP_KERNEL_PATCHES) \
#			$(PROGRESS_NLCP_MYDROID_PATCHES)
#	$(MAKE) nlcp-invoke-fetch-private
#	cd $(CRDA_DIR); 	git reset --hard $(NLCP_RELEASE_VERSION)
#	cd $(LIBNL_DIR); 	git reset --hard $(NLCP_RELEASE_VERSION)
#	cd $(TI_UTILS_DIR);	git reset --hard $(NLCP_RELEASE_VERSION)
#	cd $(IW_DIR); 		git reset --hard $(NLCP_RELEASE_VERSION)
#	cd $(HOSTAP_DIR); 	git reset --hard $(NLCP_RELEASE_VERSION)
#	cd $(WL12xx_DIR); 	git reset --hard $(NLCP_RELEASE_VERSION)
#	
#nlcp-sync-repo-latest:	$(PROGRESS_NLCP_BRINGUP_WL12xx) \
#			$(PROGRESS_NLCP_KERNEL_PATCHES) \
#			$(PROGRESS_NLCP_MYDROID_PATCHES)
#	cd $(CRDA_DIR); 	git pull origin $(CRDA_BRANCH)
#	cd $(TI_UTILS_DIR); git pull origin $(TI_UTILS_BRANCH)
#	cd $(IW_DIR); 		git pull origin $(IW_BRANCH)
#	cd $(WL12xx_DIR); 	git pull origin $(WL12xx_BRANCH)
#	cd $(LIBNL_DIR); 	git pull $(LIBNL_REMOTE_NAME) $(LIBNL_BRANCH)
#	cd $(HOSTAP_DIR); 	git pull $(HOSTAP_REMOTE_NAME) $(HOSTAP_BRANCH)
