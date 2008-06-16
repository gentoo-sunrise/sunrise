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

# Configure Options from http://scratchpad.wikia.com/wiki/Installing_gdivelog I haven't checked or added yet.
#--enable-all-plugins
#--enable-plugin-dump
#--disable-utils
#--disable-mdbtools          # needs to be added, don't want to overwrite the regular mdbtools which resides in portage
#--with-mdbtools=DIR
#--enable-smart-plugin       # smart needs IrDA kernel support and/or irda.h header file avalible to compile
#--enable-smarttrak-plugin   # relies on MDB tools, patched?
#--enable-suuntodm2-plugin   # relies on a patched version of MDB tools
# BUGS
#* When installing a plugin I get a duplicate in the application list, upstream?

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
