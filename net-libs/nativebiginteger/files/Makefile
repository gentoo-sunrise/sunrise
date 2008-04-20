libjbigi:
	cd jbigi && rm -f jbigi.o libjbigi.so && $(CC) $(CFLAGS) -c -I. -Ijbigi/include -I$(JAVA_HOME)/include -I$(JAVA_HOME)/include/linux \
	jbigi/src/jbigi.c && $(CC) -shared -Wl,-soname,libjbigi.so -I. -Ijbigi/include -I$(JAVA_HOME)/include -I$(JAVA_HOME)/include/linux -lgmp \
	-o libjbigi.so jbigi.o


libjcpuid:
	cd jcpuid && $(CC) $(CFLAGS) -shared -Wl,-soname,libjbigi-x86-linux.so -I. -Iinclude -I$(JAVA_HOME)/include -I$(JAVA_HOME)/include/linux \
	src/*.c -o libjcpuid-x86-linux.so

install:
	mkdir -p "${DESTDIR}"opt/freenet/${LIBDIR}/
	/usr/bin/install jbigi/libjbigi.so "${DESTDIR}"opt/freenet/${LIBDIR}/
	/usr/bin/install jcpuid/libjcpuid-x86-linux.so "${DESTDIR}"opt/freenet/${LIBDIR}/
	/bin/ln -s libjbigi.so "${DESTDIR}"/opt/freenet/${LIBDIR}/libjbigi-linux-none.so
	/bin/ln -s libjbigi.so "${DESTDIR}"/opt/freenet/${LIBDIR}/libjbigi-linux-pentium.so
	/bin/ln -s libjbigi.so "${DESTDIR}"/opt/freenet/${LIBDIR}/libjbigi-linux-pentiummmx.so
	/bin/ln -s libjbigi.so "${DESTDIR}"/opt/freenet/${LIBDIR}/libjbigi-linux-pentium2.so
	/bin/ln -s libjbigi.so "${DESTDIR}"/opt/freenet/${LIBDIR}/libjbigi-linux-pentium3.so
	/bin/ln -s libjbigi.so "${DESTDIR}"/opt/freenet/${LIBDIR}/libjbigi-linux-pentium4.so
	/bin/ln -s libjbigi.so "${DESTDIR}"/opt/freenet/${LIBDIR}/libjbigi-linux-k6.so
	/bin/ln -s libjbigi.so "${DESTDIR}"/opt/freenet/${LIBDIR}/libjbigi-linux-k62.so
	/bin/ln -s libjbigi.so "${DESTDIR}"/opt/freenet/${LIBDIR}/libjbigi-linux-k63.so
	/bin/ln -s libjbigi.so "${DESTDIR}"/opt/freenet/${LIBDIR}/libjbigi-linux-athlon.so
	/bin/ln -s libjbigi.so "${DESTDIR}"/opt/freenet/${LIBDIR}/libjbigi-linux-x86_64.so

