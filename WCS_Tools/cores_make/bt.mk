################################################################################
#
# bt.mk
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

bt-private-pre-bringup-validation:

bt-bringup-private:
	@$(ECHO) "<<<BLUEZ>>> bt bringup..."

bt-make-private:
	@$(ECHO) "<<<BLUEZ>>> bt make..."
	
bt-install-private:
	@$(ECHO) "<<<BLUEZ>>> Modifying init.rc."
	@$(CAT) $(INITRC_PATH)/BLUEZ.rc.addon >> $(MYFS_ROOT_PATH)/init.rc

	@$(ECHO) "<<<BLUEZ>>> Copying BT scripts"
	@$(MKDIR) -p $(MYFS_SYSTEM_PATH)/system/etc/firmware/
	@$(COPY) -vf $(FIRMWARE_PATH)/bt/* $(MYFS_SYSTEM_PATH)/system/etc/firmware/

bt-clean-private:
	@$(ECHO) "<<<BLUEZ>>> bt clean..."

bt-distclean-private:
	@$(ECHO) "<<<BLUEZ>>> bt softap distclean..."

