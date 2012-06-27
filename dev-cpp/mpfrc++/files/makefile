LNAME=mpfrc++
LIBRARY=lib$(LNAME).so
REALNAME=$(LIBRARY).$(VER)
CXX ?= g++
DESTDIR ?=
LIBDIR ?= $(DESTDIR)/usr/lib
INCLUDEDIR ?= $(DESTDIR)/usr/include

INSTALL ?= install
INSTALL_PROG ?= $(INSTALL) -m755

all : $(REALNAME)

$(REALNAME) : mpreal.o
	$(CXX) $(CXXFLAGS) $(LDFLAGS) -shared -o $@ $? -lmpfr

mpreal.o: mpreal.cpp mpreal.h
	$(CXX) $(CXXFLAGS) -fPIC -c mpreal.cpp

install: all
	$(INSTALL) -d $(LIBDIR)
	$(INSTALL) -d $(INCLUDEDIR)
	$(INSTALL_PROG) $(REALNAME) $(LIBDIR)/$(REALNAME)
	$(INSTALL) mpreal.h $(INCLUDEDIR)/mpreal.h
	cd $(LIBDIR) && ln -s $(REALNAME) $(LIBRARY)

uninstall: .FORCE
	rm -f $(LIBDIR)/$(LIBRARY)
	rm -f $(LIBDIR)/$(REALNAME)
	rm -f $(INCLUDEDIR)/mpreal.h


.PHONY: clean

clean:
	rm -f *.o $(REALNAME)

.FORCE:
