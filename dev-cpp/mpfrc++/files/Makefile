LNAME=mpfrc++
VER=20120116
LIBRARY=lib$(LNAME).so
REALNAME=$(LIBRARY).$(VER)
CXX ?= g++

ALL : $(REALNAME)

$(REALNAME) : dlmalloc.o mpreal.o
	$(CXX) $(CXXFLAGS) $(LDFLAGS) -shared -o $@ $? -lmpfr

mpreal.o: mpreal.cpp mpreal.h
	$(CXX) $(CXXFLAGS) -fPIC -c mpreal.cpp

dlmalloc.o: dlmalloc.c dlmalloc.h
	$(CXX) $(CXXFLAGS) -fPIC -c dlmalloc.c

.PHONY: clean

clean:
	rm -f *.o $(REALNAME)
