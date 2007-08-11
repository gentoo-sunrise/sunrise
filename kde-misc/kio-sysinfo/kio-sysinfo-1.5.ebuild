# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $
 
inherit kde eutils
 
MY_P="${P/kio-/}"
 
DESCRIPTION="kioslave to display system information in konqueror (pardus port)"
HOMEPAGE="http://www.kde-apps.org/content/show.php?content=58704"
SRC_URI="http://download.tuxfamily.org/kiosysinfo/Sources/old/${P}.tar.gz
	branding? ( http://users.electrostorm.net/~krf/files/static/kio-sysinfo-background_gentoo.png )"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="branding"
 
DEPEND=""
RDEPEND="${DEPEND}"
 
need-kde 3.2

S="${WORKDIR}/${MY_P}"

src_unpack() {
	unpack "${P}.tar.gz"
	cd "${S}"

	if use branding ; then
		cp ${DISTDIR}/kio-sysinfo-background_gentoo.png ${S}/about/images/background.png
	fi

	epatch "${FILESDIR}/kio-sysinfo-1.5-de-translation.patch" # update some ugly translations
}
