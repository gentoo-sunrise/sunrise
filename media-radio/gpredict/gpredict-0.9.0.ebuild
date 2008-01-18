# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit autotools eutils

DESCRIPTION="A tool for tracking amateur radio satellites"
HOMEPAGE="http://groundstation.sourceforge.net/gpredict/"
SRC_URI="mirror://sourceforge/groundstation/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~ppc ~x86"
IUSE="coverage"

DEPEND=">=dev-libs/glib-2.12.0
	>=x11-libs/gtk+-2.10
	>=x11-libs/goocanvas-0.8
	net-misc/curl"
RDEPEND="${DEPEND}"

src_unpack() {
	unpack ${A}
	cd "${S}"
	# Patch to prevent gpredict from building goocanvas itself
	epatch "${FILESDIR}/${P}-goocanvas.patch"
	eautoreconf
}

src_compile() {
	econf $(use_enable coverage ) || die "econf failed!"
	emake || die "emake failed!"
}

src_install() {
	emake DESTDIR="${D}" install || die "emake install failed"
	make_desktop_entry ${PN} "GPredict" "/usr/share/pixmaps/gpredict/icons/gpredict-icon.png" Science
}
