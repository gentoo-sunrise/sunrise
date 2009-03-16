# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="2"

inherit eutils

DESCRIPTION="An intuitive, GUI based Xen management tool covering all phases of the operational lifecycle."
HOMEPAGE="http://sourceforge.net/projects/xenman/"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.gz"

LICENSE="LGPL-2"
SLOT="0"
IUSE="lvm2"
KEYWORDS="~amd64 ~x86"

DEPEND=""
RDEPEND=">=app-emulation/xen-3.0.2
		>=app-emulation/xen-tools-3.0.2
		>=app-arch/rpm-4.4.6[python]
		>=dev-python/pygtk-2.8.6
		>=x11-libs/vte-0.12.2[python]
		lvm2? ( sys-fs/lvm2 )
		dev-lang/python"

src_install() {
	insinto /usr/share/${PN}
	doins -r pixmaps/ xenman.glade

	newsbin xenman.py xenman

	dodoc changelog.txt README xenman.conf-*
}
