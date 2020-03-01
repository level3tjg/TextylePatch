THEOS_DEVICE_IP = 192.168.1.102

ARCHS = arm64 arm64e

INSTALL_TARGET_PROCESSES = SpringBoard

include $(THEOS)/makefiles/common.mk

TWEAK_NAME = TextylePatch

TextylePatch_FILES = Tweak.xm fishhook/fishhook.c
#TextylePatch_LIBRARIES = substitute
#TextylePatch_CFLAGS = -fobjc-arc

include $(THEOS_MAKE_PATH)/tweak.mk

#before-package::
#	mv $(THEOS_STAGING_DIR)/Library/MobileSubstrate/DynamicLibraries/TextylePatch.dylib "$(THEOS_STAGING_DIR)/Library/MobileSubstrate/DynamicLibraries/ _TextylePatch.dylib"
#	mv $(THEOS_STAGING_DIR)/Library/MobileSubstrate/DynamicLibraries/TextylePatch.plist "$(THEOS_STAGING_DIR)/Library/MobileSubstrate/DynamicLibraries/ _TextylePatch.plist"
