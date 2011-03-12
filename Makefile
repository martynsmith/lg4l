ifneq ($(KERNELRELEASE),)
# kbuild part

KVERSION = $(shell uname -r)
#EXTRA_CFLAGS=-I$(KDIR)/drivers/hid

ifneq ($(BUILD_HID),Y)
obj-m := hid-g13.o hid-g15.o hid-g19.o hid-gfb.o hid-g110.o
else
hid-objs := hid-core.o hid-input.o hid-debug.o hidraw.o
obj-m := hid.o hid-g13.o hid-g15.o hid-g19.o hid-gfb.o hid-g110.o
endif

else

KVERSION = $(shell uname -r)
KDIR := /lib/modules/$(KVERSION)/build
MODULE_INSTALL_DIR := /lib/modules/$(KVERSION)/updates/g-series
MODS := hid.ko hid-g13.ko hid-g15.ko hid-g19.ko hid-gfb.ko hid-g110.ko
PWD := $(shell pwd)

default:
	$(MAKE) -C $(KDIR) M=$(PWD)

clean:
	$(MAKE) -C $(KDIR) M=$(PWD) clean

install:
	$(MAKE) -C $(KDIR) M=$(PWD) modules_install

TAGS:
	$(MAKE) -C $(KDIR) M=$(PWD) TAGS

# mkdir -p $(MODULE_INSTALL_DIR)
# cp $(MODS) $(MODULE_INSTALL_DIR)
# depmod -a

# uninstall:
# 	rm $(MODULE_INSTALL_DIR)/*
# 	depmod -a

g110test:
	sudo rmmod hid-g110 || true
	sudo rmmod hid-gfb || true
	make
	sudo make install

g19rmmod:
	sudo rmmod hid-g19 hid-gfb

g19insmod:
	sudo modprobe hid-g19

endif