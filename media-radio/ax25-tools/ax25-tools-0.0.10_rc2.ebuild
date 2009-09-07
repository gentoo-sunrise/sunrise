# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

MY_P=${P/_/-}

DESCRIPTION="Basic AX.25 (Amateur Radio) administrative tools and daemons"
HOMEPAGE="http://www.linux-ax25.org/"
SRC_URI="http://www.linux-ax25.org/pub/${PN}/${MY_P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86"
IUSE="X"

S=${WORKDIR}/${MY_P}

DEPEND="dev-libs/libax25
	X? ( x11-libs/libX11
		media-libs/mesa
		x11-libs/fltk )"
RDEPEND=${DEPEND}

src_compile() {
	econf $(use_with X x)
	emake || die "emake failed"
}

src_install() {
	emake -j1 DESTDIR="${D}" install installconf || die "emake install failed"

	# Make the document installation more Gentoo like
	rm -rf "${D}"/usr/share/doc/ax25-tools || die "clean-up doc failed"
	dodoc AUTHORS ChangeLog NEWS README tcpip/ttylinkd.README \
	user_call/README.user_call yamdrv/README.yamdrv dmascc/README.dmascc \
	tcpip/ttylinkd.INSTALL || die "dodoc failed"

	newinitd "${FILESDIR}"/ax25d.rc ax25d || die "ax25d rc install failed"
	newinitd "${FILESDIR}"/mheardd.rc mheardd || die "mheardd rc install failed"
	newinitd "${FILESDIR}"/netromd.rc netromd || die "netromd rc install failed"
	newinitd "${FILESDIR}"/rip98d.rc rip98d || die "rip98d rc install failed"
	newinitd "${FILESDIR}"/rxecho.rc rxecho || die "rxecho rc install failed"
	newinitd "${FILESDIR}"/ttylinkd.rc ttylinkd || die "ttylinkd install failed"
}
