libjbigi:
	cd jbigi && rm -f jbigi.o libjbigi.so && $(CC) $(CFLAGS) -c -I. -Ijbigi/include -I$(JAVA_HOME)/include -I$(JAVA_HOME)/include/linux \
	jbigi/src/jbigi.c && $(CC) -shared -Wl,-soname,libjbigi.so -I. -Ijbigi/include -I$(JAVA_HOME)/include -I$(JAVA_HOME)/include/linux -lgmp \
	-o libjbigi.so jbigi.o


libjcpuid:
	cd jcpuid && $(CC) $(CFLAGS) -shared -Wl,-soname,libjbigi-x86-linux.so -I. -Iinclude -I$(JAVA_HOME)/include -I$(JAVA_HOME)/include/linux \
	src/*.c -o libjcpuid-x86-linux.so

install:
	mkdir -p "${DESTDIR}"opt/freenet/lib/
	/usr/bin/install -o freenet -g freenet -m 700 jbigi/libjbigi.so "${DESTDIR}"opt/freenet/lib/
	/usr/bin/install -o freenet -g freenet -m 700 jcpuid/libjcpuid-x86-linux.so "${DESTDIR}"opt/freenet/lib/
	/bin/ln -s libjbigi.so "${DESTDIR}"/opt/freenet/lib/libjbigi-linux-none.so
	/bin/ln -s libjbigi.so "${DESTDIR}"/opt/freenet/lib/libjbigi-linux-pentium.so
	/bin/ln -s libjbigi.so "${DESTDIR}"/opt/freenet/lib/libjbigi-linux-pentiummmx.so
	/bin/ln -s libjbigi.so "${DESTDIR}"/opt/freenet/lib/libjbigi-linux-pentium2.so
	/bin/ln -s libjbigi.so "${DESTDIR}"/opt/freenet/lib/libjbigi-linux-pentium3.so
	/bin/ln -s libjbigi.so "${DESTDIR}"/opt/freenet/lib/libjbigi-linux-pentium4.so
	/bin/ln -s libjbigi.so "${DESTDIR}"/opt/freenet/lib/libjbigi-linux-k6.so
	/bin/ln -s libjbigi.so "${DESTDIR}"/opt/freenet/lib/libjbigi-linux-k62.so
	/bin/ln -s libjbigi.so "${DESTDIR}"/opt/freenet/lib/libjbigi-linux-k63.so
	/bin/ln -s libjbigi.so "${DESTDIR}"/opt/freenet/lib/libjbigi-linux-athlon.so

