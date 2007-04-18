# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit eutils

DESCRIPTION="A tool for tracking amateur radio satellites"
HOMEPAGE="http://groundstation.sourceforge.net/gpredict/"
SRC_URI="mirror://sourceforge/groundstation/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~ppc ~x86-fbsd"
IUSE=""

DEPEND=">=dev-libs/glib-2.10.0
	>=x11-libs/gtk+-2.8"
RDEPEND="${DEPEND}"

src_install() {
	emake DESTDIR="${D}" install || die "emake install failed"
	make_desktop_entry ${PN} "GPredict" "/usr/share/pixmaps/gpredict/icons/gpredict-icon.png" Science
}
