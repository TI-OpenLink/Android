################################################################################
#
# repo.mk
#
# Makefile for Android project integrated with NLCP
# repositories definitions
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

OMAP_REPO_TOOL:=git://git.omapzoom.org/tools/repo
OMAP_REPO_BRANCH:=master

# -----------------------------------------------------------------------------
# mydroid repository definitions
# -----------------------------------------------------------------------------

OMAPMANIFEST_REPO:=git://git.omapzoom.org/platform/omapmanifest.git
OMAPMANIFEST_BRANCH:=27.x
#ics-mr0
OMAPMANIFEST_XMLFILE:=RLS27.I.ENG.2_IcecreamSandwich.xml
OMAPMANIFEST_HASH:= 

# -----------------------------------------------------------------------------
# kernel repository definitions
# -----------------------------------------------------------------------------
KERNEL_REPO:=git://git.omapzoom.org/kernel/omap.git
KERNEL_TAG_HASH:=c738ec9855aad23216fbddf72265613a23a00cb9

# -----------------------------------------------------------------------------
# x-loader repository definitions
# -----------------------------------------------------------------------------
XLOADER_REPO:=git://git.omapzoom.org/repo/x-loader.git
XLOADER_TAG_HASH:=4361857120dc8b3fae5ee9861fe406a9aae67c8b

# -----------------------------------------------------------------------------
# u-boot repository definitions
# -----------------------------------------------------------------------------
# Note: 
# L27.INC1.11.1 u-boot release is corrupted - sd card boot is not available,
# we are using an older version (L27.INC1.10.1) 
UBOOT_REPO:=git://git.omapzoom.org/repo/u-boot.git
UBOOT_TAG_HASH:=0b595b50d298d58933227c2ded3bffac677a6f91
