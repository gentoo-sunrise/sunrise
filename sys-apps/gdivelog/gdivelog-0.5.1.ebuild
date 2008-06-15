# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

DESCRIPTION="SCUBA dive logging application, with extendable plugin support."
HOMEPAGE="http://gdivelog.sourceforge.net/"
SRC_URI="mirror://sourceforge/gdivelog/${P}.tar.bz2"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~x86"
IUSE=""

DEPEND=">=gnome-base/libgnomeui-2.10
	>=dev-db/sqlite-3.1.2"
RDEPEND="${DEPEND}"

src_install() {
	emake DESTDIR="${D}" install || die "emake install failed"
}

pkg_postinst() {
	elog "For extendable plugins support just emerge the appropriate ebuild"
	elog ""
	elog "x11-plugins/gdivelog-hyperaqualand-plugin		Citizen Hyperaqualand."
	elog "x11-plugins/gdivelog-sensuspro-plugin			Reefnet Sensus Pro."
	elog "x11-plugins/gdivelog-suunto-plugin			Suunto Cobra, Mosquito, Spyder,	Stinger, Vyper and Vytec."
	elog ""
}
