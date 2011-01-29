hid-objs := hid-core.o hid-input.o hid-debug.o hidraw.o
obj-m := hid.o hid-g13.o hid-g15.o hid-g19.o hid-gfb.o hid-g110.o
KDIR := /lib/modules/$(shell uname -r)/build
MODULE_INSTALL_DIR := /lib/modules/$(shell uname -r)/updates/g-series
MODS := hid.ko hid-g13.ko hid-g15.ko hid-g19.ko hid-gfb.ko hid-g110.ko
PWD := $(shell pwd)
default:
	$(MAKE) -C $(KDIR) SUBDIRS=$(PWD) modules

clean:
	find \( -name '*.[oas]' -o -name '*.ko' -o -name '.*.cmd' \
        -o -name '.*.d' -o -name '.*.tmp' -o -name '*.mod.c' \
        -o -name '*.symtypes' -o -name 'modules.order' \
        -o -name modules.builtin -o -name '.tmp_*.o.*' \
        -o -name 'Module.symvers' \
        -o -name '*.gcno' \) -type f -delete
	rm -rf .tmp_versions


install:
	mkdir -p $(MODULE_INSTALL_DIR)
	cp $(MODS) $(MODULE_INSTALL_DIR)
	depmod -a

uninstall:
	rm $(MODULE_INSTALL_DIR)/*
	depmod -a

g110test:
	sudo rmmod hid-g110 || true
	sudo rmmod hid-gfb || true
	make
	sudo make install
