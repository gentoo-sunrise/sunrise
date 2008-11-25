# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit autotools eutils

DESCRIPTION="Basic AX.25 (Amateur Radio) administrative tools and daemons"
HOMEPAGE="http://www.linux-ax25.org/"
SRC_URI="http://omploader.org/veWxk/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~ppc ~x86"
IUSE="X"

S=${WORKDIR}/${PN}

DEPEND=">=dev-libs/libax25-0.0.5
	X? ( x11-libs/libX11
	    media-libs/mesa
	    x11-libs/fltk )"

src_unpack() {
	unpack ${A}
	cd "${S}"
	eautoreconf
}

src_compile() {
	econf $(use_with X x)
	emake || die "emake failed"
}

src_install() {
	emake DESTDIR="${D}" install installconf || die "emake install failed"

	# Make the document installation more Gentoo like
	rm -rf "${D}"/usr/share/doc/ax25-tools
	dodoc AUTHORS ChangeLog NEWS README tcpip/ttylinkd.README \
	user_call/README.user_call yamdrv/README.yamdrv dmascc/README.dmascc \
	tcpip/ttylinkd.INSTALL || die "dodoc failed"

	newinitd "${FILESDIR}"/ax25d.rc ax25d
	newinitd "${FILESDIR}"/mheardd.rc mheardd
	newinitd "${FILESDIR}"/netromd.rc netromd
	newinitd "${FILESDIR}"/rip98d.rc rip98d
	newinitd "${FILESDIR}"/rxecho.rc rxecho
	newinitd "${FILESDIR}"/ttylinkd.rc ttylinkd
}
