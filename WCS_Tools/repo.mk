################################################################################
#
# repo.mk
#
# Makefile for Android project integrated with NLCP
# repositories definitions
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

include defs.mk

OMAP_REPO_TOOL:=git://git.omapzoom.org/tools/repo
OMAP_REPO_BRANCH:=master

REPO_INIT_DEF_PARAMS:=--repo-branch=$(OMAP_REPO_BRANCH) --repo-url=$(OMAP_REPO_TOOL) --quiet --no-repo-verify

# -----------------------------------------------------------------------------
# x-loader repository definitions
# -----------------------------------------------------------------------------
XLOADER_REPO:=git://git.omapzoom.org/repo/x-loader.git
XLOADER_TAG_HASH:=7e049cfbf85735a34633581141e8bd568cefce34

# -----------------------------------------------------------------------------
# u-boot repository definitions
# -----------------------------------------------------------------------------
UBOOT_REPO:=git://git.omapzoom.org/repo/u-boot.git
UBOOT_TAG_HASH:=3a7cc9ef9dcaeda2715a2c864293eadb4fef0afc

# -----------------------------------------------------------------------------
# kernel repository definitions
# -----------------------------------------------------------------------------
KERNEL_REPO:=git://git.omapzoom.org/kernel/omap.git
KERNEL_TAG_HASH:=042a2c41c2445220892ac0562de286dd955ebed9

# -----------------------------------------------------------------------------
# mydroid repository definitions
# -----------------------------------------------------------------------------

OMAPMANIFEST_REPO:=git://git.omapzoom.org/platform/omapmanifest.git
OMAPMANIFEST_BRANCH:=27.x
OMAPMANIFEST_XMLFILE:=RLS27.IS.2.P1_IcecreamSandwich.xml
#RLS27.IS.1_IcecreamSandwich.xml
OMAPMANIFEST_HASH:=

# -----------------------------------------------------------------------------
# wlan repository definitions
# -----------------------------------------------------------------------------
WLAN_DRIVER_MANIFEST_REPO:=git://github.com/TI-OpenLink/ti-ol-driver-manifest.git
WLAN_DRIVER_MANIFEST_BRANCH:=master
WLAN_DRIVER_MANIFEST_HASH:=
WLAN_DRIVER_MANIFEST_DIR:=$(WORKSPACE_DIR)/wlan-driver-manifest
WLAN_DRIVER_MANIFEST_NAME:=TI-OpenLink-driver-R5.00.xx.xml

WLAN_ANDROID_MANIFEST_REPO:=git://github.com/TI-OpenLink/ti-ol-android-manifest.git
WLAN_ANDROID_MANIFEST_BRANCH:=master
WLAN_ANDROID_MANIFEST_HASH:=
WLAN_ANDROID_MANIFEST_DIR:=$(WORKSPACE_DIR)/wlan-android-manifest
WLAN_ANDROID_MANIFEST_NAME:=TI-OpenLink-android-R5.00.xx.xml

# -----------------------------------------------------------------------------
# bt repository definitions
# -----------------------------------------------------------------------------
BT_DRIVER_MANIFEST_REPO:=git://gitorious.tif.ti.com/tibluez-ws/tibluez-driver-manifest.git
BT_DRIVER_MANIFEST_BRANCH:=master
BT_DRIVER_MANIFEST_HASH:=
BT_DRIVER_MANIFEST_DIR:=$(WORKSPACE_DIR)/bt-driver-manifest
BT_DRIVER_MANIFEST_NAME:=blueti-driver-1.1.0.xml

BT_ANDROID_MANIFEST_REPO:=git://gitorious.tif.ti.com/tibluez-ws/tibluez-android-manifest.git
BT_ANDROID_MANIFEST_BRANCH:=master
BT_ANDROID_MANIFEST_HASH:=
BT_ANDROID_MANIFEST_DIR:=$(WORKSPACE_DIR)/bt-android-manifest
BT_ANDROID_MANIFEST_NAME:=blueti-android-1.1.0.xml

# -----------------------------------------------------------------------------
# fm repository definitions
# -----------------------------------------------------------------------------
FM_ANDROID_MANIFEST_REPO:=
FM_ANDROID_MANIFEST_BRANCH:=
FM_ANDROID_MANIFEST_HASH:=
FM_ANDROID_MANIFEST_DIR:=
FM_ANDROID_MANIFEST_NAME:=


