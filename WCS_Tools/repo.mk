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

ifndef REPO_MK_INCLUDED
REPO_MK_INCLUDED:=included

include defs.mk

OMAP_REPO_TOOL:=git://git.omapzoom.org/tools/repo
OMAP_REPO_BRANCH:=master

#REPO_INIT_DEF_PARAMS:=--repo-branch=$(OMAP_REPO_BRANCH) --repo-url=$(OMAP_REPO_TOOL) --quiet --no-repo-verify
REPO_INIT_DEF_PARAMS:=--quiet --no-repo-verify
REPO_SYNC_NTHREADS:=16
REPO_SYNC_DEF_PARAMS:=-j$(REPO_SYNC_NTHREADS)

# -----------------------------------------------------------------------------
# x-loader repository definitions
# -----------------------------------------------------------------------------
XLOADER_REPO:=git://git.omapzoom.org/repo/x-loader.git
XLOADER_TAG_HASH:=83cc7f5e242ab82f64f7a868df0fb5ed88830971

# -----------------------------------------------------------------------------
# u-boot repository definitions
# -----------------------------------------------------------------------------
UBOOT_REPO:=git://git.omapzoom.org/repo/u-boot.git
UBOOT_TAG_HASH:=375e17deb1855185f429e36713b31f5ee453c443

# -----------------------------------------------------------------------------
# kernel repository definitions
# -----------------------------------------------------------------------------
KERNEL_REPO:=git://git.omapzoom.org/kernel/omap.git
KERNEL_TAG_HASH:=358ad6f8ca2bb5939d12f0d26b32aed92d70caef

# -----------------------------------------------------------------------------
# mydroid repository definitions
# -----------------------------------------------------------------------------

OMAPMANIFEST_REPO:=git://git.omapzoom.org/platform/omapmanifest.git
OMAPMANIFEST_BRANCH:=27.x
OMAPMANIFEST_XMLFILE:=RLS27.IS.2.P1_IcecreamSandwich.xml
OMAPMANIFEST_HASH:=

# -----------------------------------------------------------------------------
# wlan repository definitions
# -----------------------------------------------------------------------------
WLAN_MANIFEST_REPO:=git://github.com/TI-OpenLink/ti-ol-manifest.git
WLAN_MANIFEST_BRANCH:=int
WLAN_MANIFEST_DIR:=$(WORKSPACE_DIR)/ti-ol-manifest
WLAN_MANIFEST_HASH?=
WLAN_MANIFEST_EXT?=xx
WLAN_DRIVER_MANIFEST_NAME:=ti-ol-driver-manifest.R5.$(WLAN_MANIFEST_EXT).xml
WLAN_ANDROID_MANIFEST_NAME:=ti-ol-android-manifest.R5.$(WLAN_MANIFEST_EXT).xml

# -----------------------------------------------------------------------------
# bt repository definitions
# -----------------------------------------------------------------------------
BT_MANIFEST_REPO:=/tmp/.idor/ti-bt-manifest
BT_MANIFEST_BRANCH:=master
BT_MANIFEST_DIR:=$(WORKSPACE_DIR)/ti-bt-manifest
BT_MANIFEST_HASH?=
BT_MANIFEST_EXT?=xx
BT_DRIVER_MANIFEST_NAME:=blueti-driver-1.1.0.xml
BT_ANDROID_MANIFEST_NAME:=blueti-android-1.1.0.xml

# -----------------------------------------------------------------------------
# fm repository definitions
# -----------------------------------------------------------------------------
FM_ANDROID_MANIFEST_REPO:=
FM_ANDROID_MANIFEST_BRANCH:=
FM_ANDROID_MANIFEST_HASH:=
FM_ANDROID_MANIFEST_DIR:=
FM_ANDROID_MANIFEST_NAME:=

endif #REPO_MK_INCLUDED
