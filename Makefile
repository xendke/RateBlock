include $(THEOS)/makefiles/common.mk
export RateBlock_FRAMEWORKS = UIKit
TWEAK_NAME = RateBlock

RateBlock_FILES = Tweak.xm

include $(THEOS_MAKE_PATH)/tweak.mk

after-install::
	install.exec "killall -9 SpringBoard"
