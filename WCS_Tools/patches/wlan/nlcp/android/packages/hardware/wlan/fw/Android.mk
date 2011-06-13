local_target_dir := $(TARGET_OUT)/etc/firmware/ti-connectivity
LOCAL_PATH:= $(call my-dir)

include $(CLEAR_VARS)
LOCAL_MODULE := wl1271-nvs.bin
LOCAL_MODULE_TAGS := eng
LOCAL_MODULE_PATH := $(local_target_dir)
LOCAL_SRC_FILES := $(LOCAL_MODULE)
LOCAL_MODULE_CLASS := FIRMWARE
include $(BUILD_PREBUILT)

include $(CLEAR_VARS)
LOCAL_MODULE := wl128x-fw.bin
LOCAL_MODULE_TAGS := eng
LOCAL_MODULE_PATH := $(local_target_dir)
LOCAL_SRC_FILES := $(LOCAL_MODULE)
LOCAL_MODULE_CLASS := FIRMWARE
include $(BUILD_PREBUILT)

include $(CLEAR_VARS)
LOCAL_MODULE := wl128x-fw-ap.bin
LOCAL_MODULE_TAGS := eng
LOCAL_MODULE_PATH := $(local_target_dir)
LOCAL_SRC_FILES := $(LOCAL_MODULE)
LOCAL_MODULE_CLASS := FIRMWARE
include $(BUILD_PREBUILT)

include $(CLEAR_VARS)
LOCAL_MODULE := wl1271-fw-2.bin
LOCAL_MODULE_TAGS := eng
LOCAL_MODULE_PATH := $(local_target_dir)
LOCAL_SRC_FILES := $(LOCAL_MODULE)
LOCAL_MODULE_CLASS := FIRMWARE
include $(BUILD_PREBUILT)

include $(CLEAR_VARS)
LOCAL_MODULE := wl1271-fw-ap.bin
LOCAL_MODULE_TAGS := eng
LOCAL_MODULE_PATH := $(local_target_dir)
LOCAL_SRC_FILES := $(LOCAL_MODULE)
LOCAL_MODULE_CLASS := FIRMWARE
include $(BUILD_PREBUILT)

include $(CLEAR_VARS)
LOCAL_MODULE := TIInit_10.6.15.bts
LOCAL_MODULE_TAGS := eng
LOCAL_MODULE_PATH := $(TARGET_OUT)/etc/firmware
LOCAL_SRC_FILES := $(LOCAL_MODULE)
LOCAL_MODULE_CLASS := FIRMWARE
include $(BUILD_PREBUILT)
