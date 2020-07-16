THEOS_DEVICE_IP = localhost
THEOS_DEVICE_PORT = 2222

ARCHS = arm64 arm64e

INSTALL_TARGET_PROCESSES = SpringBoard

include $(THEOS)/makefiles/common.mk

TWEAK_NAME = TextylePatch

TextylePatch_FILES = Tweak.x fishhook/fishhook.c
TextylePatch_CFLAGS = -fobjc-arc

include $(THEOS_MAKE_PATH)/tweak.mk
