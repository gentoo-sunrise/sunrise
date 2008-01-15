# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit autotools

DESCRIPTION="exempi is a port of the Adobe XMP SDK to work on UNIX"
HOMEPAGE="http://libopenraw.freedesktop.org/wiki/Exempi"
SRC_URI="http://libopenraw.freedesktop.org/download/${P}.tar.gz"

LICENSE="BSD"
SLOT="2"
KEYWORDS="~amd64 ~x86"
IUSE="examples test"

RDEPEND="dev-libs/expat
	virtual/libiconv"
DEPEND="${RDEPEND}
	test? ( >=dev-libs/boost-1.33.1 dev-util/valgrind )"

src_unpack() {
	unpack "${A}"
	cd "${S}"
	if use test ; then
		epatch "${FILESDIR}/${P}-boost_mt.patch"
	else
		sed -e '/^BOOST/ D' -i configure.ac
	fi
	AT_M4DIR=m4 eautoreconf
}

src_compile() {
	econf $(use_with test unit-test) || die "./configure failed"
	emake || die "emake failed"
}

src_install() {
	emake DESTDIR="${D}" install || die "install failed"
	dodoc AUTHORS ChangeLog NEWS README
	if use examples ; then
		cd samples/source
		emake distclean
		cd "${S}"
		rm samples/Makefile* samples/source/Makefile* \
			samples/BlueSquares/Makefile*
		insinto "/usr/share/doc/${PF}"
		doins -r samples
	fi
}
