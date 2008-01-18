# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit eutils

DESCRIPTION="An intuitive, GUI based Xen management tool covering all phases of the operational lifecycle."
HOMEPAGE="http://sourceforge.net/projects/xenman/"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.gz"

LICENSE="LGPL-2"
SLOT="0"
IUSE="lvm2"
KEYWORDS="~x86"

DEPEND=""
RDEPEND=">=app-emulation/xen-3.0.2
		>=app-emulation/xen-tools-3.0.2
		>=app-arch/rpm-4.4.6
		>=dev-python/pygtk-2.8.6
		>=x11-libs/vte-0.12.2
		lvm2? ( sys-fs/lvm2 )
		dev-lang/python"

pkg_setup() {
	if ! built_with_use app-arch/rpm python; then
		eerror "app-arch/rpm has to be built with python support."
		die "Missing python USE-flag for app-arch/rpm"
	fi
	if ! built_with_use x11-libs/vte python; then
		eerror "x11-libs/vte has to be built with python support."
		die "Missing python USE-flag for x11-libs/vte"
	fi
}

src_install() {
	insinto /usr/share/${PN}
	doins -r pixmaps/ xenman.glade

	newsbin xenman.py xenman

	dodoc changelog.txt README xenman.conf-*
}
