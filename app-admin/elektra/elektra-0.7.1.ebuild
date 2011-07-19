# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=4

inherit autotools

DESCRIPTION="universal and secure framework to store config parameters in a hierarchical key-value pair mechanism"
HOMEPAGE="http://sourceforge.net/projects/elektra/"
SRC_URI="ftp://ftp.markus-raab.org/${PN}/${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="iconv static-libs"

RDEPEND="dev-libs/libxml2"
DEPEND="${RDEPEND}
	sys-devel/libtool
	iconv? ( virtual/libiconv )"

src_prepare() {
	einfo 'Removing bundled libltdl'
	rm -rf libltdl || die
	sed -i -e '/^SUBDIRS/s:libltdl::' Makefile.am || die
	sed -i -e '1adeveldocDATA_INSTALL = install' doc/Makefile.am || die

	touch config.rpath
	eautoreconf
}

src_configure() {
	# berkeleydb, daemon, fstab, gconf, python do not work
	econf \
		--enable-filesys \
		--enable-hosts \
		--enable-ini \
		--enable-passwd \
		--disable-berkeleydb \
		--disable-fstab \
		--disable-gconf \
		--disable-daemon \
		--enable-cpp \
		--disable-python \
		--enable-gcov \
		$(use_enable iconv) \
		$(use_enable static-libs static) \
		--with-docdir=/usr/share/doc/${PF} \
		--with-develdocdir=/usr/share/doc/${PF}
}

src_install() {
	emake DESTDIR="${D}" install

	if ! use static-libs; then
		find "${D}" -name "*.a" -delete || die
	fi

	dodoc AUTHORS ChangeLog NEWS README TODO
}
