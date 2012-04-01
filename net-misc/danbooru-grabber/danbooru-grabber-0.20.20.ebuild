# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=4

MY_PN=danbooru-v7sh-grabber
MY_P=${MY_PN}-v${PV}

DESCRIPTION="POSIX-compliant shell script to download images from Danbooru and Gelbooru"
HOMEPAGE="http://code.google.com/p/danbooru-v7sh-grabber"
SRC_URI="http://${MY_PN}.googlecode.com/files/${MY_P}.tar.gz"

LICENSE="WTFPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

S=${WORKDIR}/${MY_P}

src_install() {
	newbin ${MY_PN} ${PN}
	#dodoc README
}

pkg_postinst() {
	elog "If you need a crash-course on how to use the script, please"
	elog "visit ${HOMEPAGE}/wiki/Main"
}
