LOCAL_PATH:= $(call my-dir)

include $(CLEAR_VARS)

LOCAL_SRC_FILES := \
	iw.c \
	commands.c

LOCAL_C_INCLUDES := \
	$(LOCAL_PATH) \
	external/libnl/include


LOCAL_NO_DEFAULT_COMPILER_FLAGS := true
LOCAL_C_INCLUDES += $(LOCAL_PATH)/../libnl/include \
	$(TARGET_PROJECT_INCLUDES) $(TARGET_C_INCLUDES)
LOCAL_CFLAGS := $(TARGET_GLOBAL_CFLAGS) $(PRIVATE_ARM_CFLAGS)

LOCAL_LDFLAGS := -Wl,--no-gc-sections
LOCAL_MODULE_TAGS := eng
LOCAL_SHARED_LIBRARIES := libnl
LOCAL_MODULE := testcmd

include $(BUILD_EXECUTABLE)
