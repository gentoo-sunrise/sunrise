# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="1"
inherit autotools eutils

DESCRIPTION="A tool for controlling amateur radios"
HOMEPAGE="http://groundstation.sourceforge.net/grig/"
SRC_URI="mirror://sourceforge/groundstation/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86"
IUSE="+hardware"

DEPEND=">=dev-libs/glib-2.6
	>=x11-libs/gtk+-2.6
	>=media-libs/hamlib-1.2.5"
RDEPEND="${DEPEND}"

src_unpack() {
	unpack ${A}
	cd "${S}"
	#patch to support old GtkTooltips above gtk+-2.12
	epatch "${FILESDIR}/${P}-Tooltip.patch"
	eautoreconf
}

src_compile() {
	econf $(use_enable hardware )
	emake || die "emake failed!"
}

src_install() {
	emake DESTDIR="${D}" install || die "emake install failed"
	make_desktop_entry ${PN} "GRig" "/usr/share/pixmaps/grig/grig-logo.png" "Application;HamRadio"
	# make document installation more Gentoo like
	rm -rf "${D}/usr/share/grig" || die "cleanup docs failed"
	dodoc AUTHORS ChangeLog NEWS README || die "dodoc failed"
}
