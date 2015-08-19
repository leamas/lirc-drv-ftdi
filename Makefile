
driver          = ftdi
version         = 1.0

CFLAGS          += $(shell pkg-config --cflags libftdi1)
LDFLAGS         += $(shell pkg-config --libs libftdi1)


CFLAGS          += $(shell pkg-config --cflags lirc-driver)
LDFLAGS         += $(shell pkg-config --libs lirc-driver)
plugindir       =  $(shell pkg-config --variable=plugindir lirc-driver)
configdir       =  $(shell pkg-config --variable=configdir lirc-driver)
plugindocs      =  $(shell pkg-config --variable=plugindocs lirc-driver)


all:  $(driver).so

$(driver).tmp.c: $(driver).c
	sed -e 's|@plugindocs@|$(plugindocs)|' \
	    -e 's/@version@/$(version)/' < $? > $(driver).tmp.c

$(driver).tmp.o: $(driver).tmp.c

$(driver).so: $(driver).tmp.o
	gcc --shared -fpic $(LDFLAGS) -o $@ $<

install: $(driver).so
	install  $<  $(plugindir)
	install -pDm 644 $(driver).txt $(plugindocs)/$(driver).txt
	install -pDm 644 $(driver).conf $(configdir)/$(driver).conf

clean:
	rm -f *.o *.so *.tmp.c *.gz

dist:
	tar czf lirc-drv-$(driver)-$(version).tar.gz $$(git ls-files)
