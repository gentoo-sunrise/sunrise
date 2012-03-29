# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=4

DESCRIPTION="Allows user to open files with any command in the user's \$PATH via dmenu"
HOMEPAGE="http://code.google.com/p/bashscripts/source/browse/trunk/spacefm-plugin/share-via-http-server/share-via-http-server"
SRC_URI="http://bashscripts.googlecode.com/files/Open-with_v${PV}.spacefm-plugin.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND="x11-misc/dmenu
	x11-misc/spacefm"

src_install() {
	find -name COPYING -delete
	insinto /usr/share/spacefm/plugins/dmenu
	doins -r cstm_* plugin
	insinto /usr/share/spacefm/plugin-files
	doins "${DISTDIR}"/Open-with_v${PV}.spacefm-plugin.tar.gz
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
