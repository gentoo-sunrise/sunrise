# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit eutils cmake-utils

DESCRIPTION="A spam-resistant message board application for Freenet"
HOMEPAGE="http://freenetproject.org/tools.html"
SRC_URI="http://dev.gentooexperimental.org/~tommy/distfiles/${PN}-src-${PV}.zip"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND="virtual/libiconv
	>=dev-libs/poco-1.2.9
	dev-db/sqlite"
RDEPEND="${DEPEND}
	net-p2p/freenet"

S=${WORKDIR}

pkg_setup() {
	enewgroup freenet
	enewuser freenet -1 -1 /var/freenet freenet
}

src_compile() {
	local mycmakeargs="-DI_HAVE_READ_THE_README=ON
		-DUSE_BUNDLED_SQLITE=OFF
		-DDO_CHARSET_CONVERSION=ON"
	cmake-utils_src_compile
}

src_install() {
	insinto /var/freenet/fms
	doins ${PN}_build/fms {forum-,}template.htm || die "doinstall failed"
	insinto /var/freenet/fms/fonts
	doins fonts/*.bmp || die "doinstall of fonts failed"
	insinto /var/freenet/fms/images
	doins images/*png || die "doinstall of images failed"
	fperms +x /var/freenet/fms/fms
	fperms -R o-rwx /var/freenet/fms/
	fowners -R freenet:freenet /var/freenet/fms/
	doinitd "${FILESDIR}/fms"
	dodoc readme.txt
}

pkg_postinst() {
	elog "By default, the FMS NNTP server will listen on port 1119,"
	elog "and the web configuration interface will be running at"
	elog "http://localhost:8080. For more information, readme.txt."
}
