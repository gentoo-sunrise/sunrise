# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit kde eutils

DESCRIPTION="kioslave to display system information in konqueror (pardus port)"
HOMEPAGE="http://www.kde-apps.org/content/show.php?content=58704"
SRC_URI="http://download.tuxfamily.org/kiosysinfo/Sources/${P}.tar.gz
	branding? ( http://users.electrostorm.net/~krf/files/static/${PN}-background_gentoo.png )"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="branding"

DEPEND=">=sys-apps/hwinfo-13.28"
RDEPEND="${DEPEND}"

need-kde 3.2

src_unpack() {
	unpack ${A}
	cd "${S}"

	if use branding ; then
		cp "${DISTDIR}"/${PN}-background_gentoo.png "${S}"/about/images/background.png
	fi

	# update some ugly translations
	epatch "${FILESDIR}"/kio-sysinfo-${PV}-de-translation.patch
}
