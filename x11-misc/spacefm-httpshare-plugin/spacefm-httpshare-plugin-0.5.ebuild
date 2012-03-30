# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=4

DESCRIPTION="Plugin to quickly share files/folders via http server"
HOMEPAGE="http://code.google.com/p/bashscripts/source/browse/trunk/spacefm-plugin/share-via-http-server/share-via-http-server"
SRC_URI="http://bashscripts.googlecode.com/files/Share_v${PV}.spacefm-plugin.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND="dev-lang/python
	x11-misc/spacefm"

S=${WORKDIR}

src_install() {
	find -name COPYING -delete
	insinto /usr/share/spacefm/plugins/httpshare
	doins -r cstm_* plugin
	insinto /usr/share/spacefm/plugin-files
	doins "${DISTDIR}"/Share_v${PV}.spacefm-plugin.tar.gz

	cd "${D}"
	find . -name "exec.sh" -exec fperms +x '{}' + || die
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
