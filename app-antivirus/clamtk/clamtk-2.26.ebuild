# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit eutils

DESCRIPTION="A frontend for ClamAV using Gtk2-perl."
HOMEPAGE="http://clamtk.sourceforge.net/"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.gz"

LICENSE="Artistic GPL-2"
SLOT="0"
KEYWORDS="~x86"
IUSE=""

DEPEND="dev-perl/gtk2-perl
	dev-perl/File-Find-Rule
	dev-perl/libwww-perl
	dev-perl/Date-Calc
	app-antivirus/clamav"

RDEPEND="${DEPEND}"

src_install() {
	dobin clamtk

	doicon clam.xpm
	domenu ${PN}.desktop

	dodoc CHANGES DISCLAIMER README
}
