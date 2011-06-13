LOCAL_PATH:= $(call my-dir)

include $(CLEAR_VARS)

LOCAL_SRC_FILES := \
	netlatency.c


LOCAL_C_INCLUDES += $(TARGET_PROJECT_INCLUDES) $(TARGET_C_INCLUDES)
LOCAL_CFLAGS := $(TARGET_GLOBAL_CFLAGS) $(PRIVATE_ARM_CFLAGS)

LOCAL_LDFLAGS := -Wl,--no-gc-sections
LOCAL_MODULE_TAGS := eng
LOCAL_MODULE := netlatency

include $(BUILD_EXECUTABLE)
