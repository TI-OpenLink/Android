################################################################################
#
# bt.mk
#
# Makefile for Android project integrated with NLCP
#
# Android Version	:	L27.IS.1 OMAP4 Icecream Sandwich
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
# bt make arguments
################################################################################

include defs.mk

BT_PATCHES_PATH:=$(PATCHES_PATH)/bt/bt
BT_KERNEL_PATCHES:=$(BT_PATCHES_PATH)/kernel
BT_ANDROID_PATCHES:=$(BT_PATCHES_PATH)/android/patches

BT_ROOT_DIR:=$(WORKSPACE_DIR)/bt

BLUETOOTH_NEXT:=$(BT_ROOT_DIR)/bluetooth-next
BLUEZ_DIR:=$(BT_ROOT_DIR)/bluez
BT_COMPAT_DIR:=$(BT_ROOT_DIR)/compat
BT_COMPAT_WIRELESS_DIR:=$(BT_ROOT_DIR)/compat-wireless

PROGRESS_BT_KERNEL_PATCHES:=$(PROGRESS_DIR)/bt.kernel.patched
PROGRESS_BT_MYDROID_PATCHES:=$(PROGRESS_DIR)/bt.mydroid.patched
PROGRESS_BT_FETCH_DRIVER_MANIFEST:=$(PROGRESS_DIR)/bt-driver-manifest.fetched
PROGRESS_BT_BRINGUP_DRIVER_MANIFEST:=$(PROGRESS_DIR)/bt-driver-manifest.bringup

BT_GIT_COMPAT_TREE:=$(BT_COMPAT_DIR)
BT_GIT_TREE:=$(BLUETOOTH_NEXT)

################################################################################
# rules
################################################################################

bt-private-pre-bringup-validation:
	@$(ECHO) "bt pre-bringup validation passed..."

bt-private-pre-make-validation:
	@$(ECHO) "bt pre-make validation passed..."
	
$(PROGRESS_BT_FETCH_DRIVER_MANIFEST):
	@$(ECHO) "getting bt-driver-manifest repository..."
	git clone $(BT_DRIVER_MANIFEST_REPO) $(BT_DRIVER_MANIFEST_DIR)
	@$(ECHO) "...done"
	@$(call echo-to-file, "DONE", $(PROGRESS_BT_FETCH_DRIVER_MANIFEST))
	@$(call print, "bt-driver-manifest repository fetched")
	
$(PROGRESS_BT_BRINGUP_DRIVER_MANIFEST): $(PROGRESS_BT_FETCH_DRIVER_MANIFEST)
	@$(ECHO) "bt-driver-manifest bringup..."
	cd $(BT_DRIVER_MANIFEST_DIR) ; \
	git checkout $(BT_DRIVER_MANIFEST_BRANCH) ; \
	git reset --hard $(BT_DRIVER_MANIFEST_HASH)
	@$(ECHO) "...done"
	@$(call echo-to-file, "DONE", $(PROGRESS_BT_BRINGUP_DRIVER_MANIFEST))
	@$(call print, "bt-driver-manifest bringup done")
	
$(PROGRESS_BT_KERNEL_PATCHES): $(PROGRESS_BRINGUP_KERNEL)
	@$(ECHO) "patching kernel to include bt modules as M"
	cd $(KERNEL_DIR) ; $(SED) -rie 's/CONFIG_BT=y/CONFIG_BT=m/' .config
	cd $(KERNEL_DIR) ; $(SED) -rie 's/CONFIG_BT_L2CAP=y/CONFIG_BT_L2CAP=m/' .config
	cd $(KERNEL_DIR) ; $(SED) -rie 's/CONFIG_BT_SCO=y/CONFIG_BT_SCO=m/' .config
	cd $(KERNEL_DIR) ; $(SED) -rie 's/CONFIG_BT_RFCOMM=y/CONFIG_BT_RFCOMM=m/' .config
	cd $(KERNEL_DIR) ; $(SED) -rie 's/CONFIG_BT_HIDP=y/CONFIG_BT_HIDP=m/' .config
	cd $(KERNEL_DIR) ; $(SED) -rie 's/# CONFIG_CRYPTO_AES is not set/CONFIG_CRYPTO_AES=y/' .config
	cd $(KERNEL_DIR) ; $(SED) -rie 's/CONFIG_CRYPTO_AES=y/CONFIG_CRYPTO_AES=m/' .config
	cd $(KERNEL_DIR) ; $(SED) -rie 's/CONFIG_CRYPTO_ECB=m/CONFIG_CRYPTO_ECB=y/' .config
	@$(call echo-to-file, "DONE", $(PROGRESS_BT_KERNEL_PATCHES))
	@$(call print, "kernel configured to use bt as modules")

$(PROGRESS_BT_MYDROID_PATCHES): $(PROGRESS_BRINGUP_MYDROID)
	@$(ECHO) "patching android for bt..."
	@$(ECHO) "...done"
	@$(call echo-to-file, "DONE", $(PROGRESS_BT_MYDROID_PATCHES))
	@$(call print, "android patches and packages done")

bt-bringup-private: $(PROGRESS_BT_BRINGUP_DRIVER_MANIFEST) \
					$(PROGRESS_BT_KERNEL_PATCHES) \
					$(PROGRESS_BT_MYDROID_PATCHES)
	@$(ECHO) "bt bringup..."
	$(MKDIR) -p $(BT_ROOT_DIR)
	cd $(BT_ROOT_DIR) ; \
	repo init -u $(BT_DRIVER_MANIFEST_DIR) -b $(BT_DRIVER_MANIFEST_BRANCH) -m $(BT_DRIVER_MANIFEST_NAME) $(REPO_INIT_DEF_PARAMS) ; \
	repo sync --no-repo-verify

	export GIT_TREE=$(BT_GIT_TREE) ; \
	export GIT_COMPAT_TREE=$(BT_GIT_COMPAT_TREE) ; \
	cd $(BT_COMPAT_WIRELESS_DIR) ; sh ./scripts/admin-refresh.sh ; \
	cd $(BT_COMPAT_WIRELESS_DIR) ; ./scripts/driver-select bt
	@$(ECHO) "...done"

bt-make-private:
	@$(ECHO) "bt make..."
	export GIT_TREE=$(BT_GIT_TREE) ; \
	export GIT_COMPAT_TREE=$(BT_GIT_COMPAT_TREE) ; \
	cd $(BT_COMPAT_WIRELESS_DIR) ; sh ./scripts/admin-refresh.sh ; \
	cd $(BT_COMPAT_WIRELESS_DIR) ; ./scripts/driver-select bt
	export KLIB=$(KERNEL_DIR) ; \
	export KLIB_BUILD=$(KERNEL_DIR) ; \
	cd $(BT_COMPAT_WIRELESS_DIR) ; ./tibluez.sh
#	$(MAKE) -C $(BT_COMPAT_WIRELESS_DIR) KLIB=$(KERNEL_DIR) KLIB_BUILD=$(KERNEL_DIR) -j$(NTHREADS)
	@$(ECHO) "...done"
	
bt-install-private:
	@$(ECHO) "bt install..."
	@$(ECHO) "...done"
	
#	@$(ECHO) "<<<BLUEZ>>> Modifying init.rc."
#	@$(CAT) $(INITRC_PATH)/BLUEZ.rc.addon >> $(MYFS_ROOT_PATH)/init.rc
#
#	@$(ECHO) "<<<BLUEZ>>> Copying BT scripts"
#	@$(MKDIR) -p $(MYFS_SYSTEM_PATH)/etc/firmware/
#	@$(COPY) -vf $(FIRMWARE_PATH)/bt/* $(MYFS_SYSTEM_PATH)/etc/firmware/

bt-clean-private:
	@$(ECHO) "bt clean..."
	@$(ECHO) "...done"

bt-distclean-private:
	@$(ECHO) "bt softap distclean..."
	@$(ECHO) "...done"
