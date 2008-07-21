# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit eutils flag-o-matic multilib toolchain-funcs

DESCRIPTION="NativeBigInteger libs for Freenet taken from i2p"
HOMEPAGE="http://www.i2p.net"
SRC_URI="http://dev.gentooexperimental.org/~tommy/${P}.tar.bz2"

LICENSE="|| ( public-domain BSD MIT )"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND="dev-libs/gmp
	virtual/jdk
	!net-p2p/nativebiginteger"
RDEPEND="dev-libs/gmp"

QA_TEXTRELS="opt/freenet/lib/libjcpuid-x86-linux.so"

src_compile() {
	append-flags -fPIC
	tc-export CC
	cp "${FILESDIR}"/Makefile .

	#workaround, if current system-vm is a jre
	if has_version =dev-java/sun-jdk-1.6*; then
		einfo "Using sun-jdk-1.6"
		GENTOO_VM="sun-jdk-1.6" make libjbigi || die
	elif has_version =dev-java/sun-jdk-1.5*; then
		einfo "Using sun-jdk-1.5"
		GENTOO_VM="sun-jdk-1.5" make libjbigi || die
	else
		ewarn "Using system vm, make sure it is a JDK!!!"
		make libjbigi || die
	fi
	use amd64 || filter-flags -fPIC
	if has_version =dev-java/sun-jdk-1.6*; then
		einfo "Using sun-jdk-1.6"
		GENTOO_VM="sun-jdk-1.6" make libjcpuid || die
	elif has_version =dev-java/sun-jdk-1.5*; then
		einfo "Using sun-jdk-1.5"
		GENTOO_VM="sun-jdk-1.5" make libjcpuid || die
	else
		ewarn "Using system vm, make sure it is a JDK!!!"
		make libjcpuid || die
	fi
}

src_install() {
	make DESTDIR="${D}" LIBDIR=$(get_libdir) install || die
}
