# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=4

DESCRIPTION="Submenu that provides cdemu-controls"
HOMEPAGE="http://sourceforge.net/projects/spacefm-cdemu/?source=directory"
SRC_URI="mirror://sourceforge/spacefm-cdemu/${P}.tar.gz"

LICENSE="public-domain"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND="x11-misc/spacefm
	app-cdr/cdemu[cdemud]
	|| ( x11-misc/xdialog gnome-extra/zenity )"

S=${WORKDIR}

src_unpack() {
	unpack ${A}
	unpack ./cdemu.spacefm-plugin.tar.gz 
}

src_install() {
	insinto /usr/share/spacefm/plugins/cdemu
	doins -r cstm_* plugin
	insinto /usr/share/spacefm/plugin-files
	doins cdemu.spacefm-plugin.tar.gz
}

pkg_postinst() {
	einfo ""
	einfo "You might need to restart spacefm for the changes to take effect."
	einfo ""
	elog "If you want to add a plugin to a different menu via design-mode"
	elog "use the plugin-files from '/usr/share/spacefm/plugin-files'."
	einfo ""
}

pkg_postrm() {
	einfo ""
	elog "If you have copied the plugin to a different menu using the"
	elog "design mode you might want to remove it from there as well."
	einfo ""
}
