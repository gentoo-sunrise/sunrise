# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit autotools eutils

MY_PV=${PV/_beta/b}

DESCRIPTION="A tool for tracking amateur radio satellites"
HOMEPAGE="http://gpredict.oz9aec.net"
SRC_URI="mirror://sourceforge/${PN}/${PN}-${MY_PV}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~ppc ~x86"
IUSE=""

RDEPEND=">=dev-libs/glib-2.14.0
	>=x11-libs/gtk+-2.12
	>=x11-libs/goocanvas-0.8
	net-misc/curl"
DEPEND="${RDEPEND}
	dev-util/pkgconfig
	sys-devel/gettext"

S="${WORKDIR}/${PN}-${MY_PV}"

src_unpack() {
	unpack ${A}
	cd "${S}"

	# prevent gpredict from building goocanvas itself
	epatch "${FILESDIR}/${P}-goocanvas.patch"
	rm -rf goocanv8

	# remove wrong doc location
	epatch "${FILESDIR}/${P}-doc.patch"

	eautoreconf
}

src_compile() {
	econf --disable-coverage
	emake || die "emake failed!"
}

src_install() {
	emake DESTDIR="${D}" install || die "emake install failed"
	make_desktop_entry ${PN} "GPredict" "/usr/share/pixmaps/gpredict/icons/gpredict-icon.png" Science
	dodoc AUTHORS ChangeLog NEWS README TODO  || die "dodoc died"
}
