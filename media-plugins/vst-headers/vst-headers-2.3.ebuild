# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

MY_P="vst_sdk${PV/./_}"
MY_P2="vstsdk${PV}"

DESCRIPTION="Headers from VST SDK. Needed to compile some programs."
HOMEPAGE="http://ygrabit.steinberg.de/~ygrabit/public_html/index.html"
SRC_URI="${MY_P}.zip"

LICENSE="SVPSLA"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND="app-arch/unzip"
RDEPEND=""

RESTRICT="fetch"

pkg_nofetch() {
	einfo "You need to fetch VST Plug-Ins SDK ${PV}"
	einfo "from http://www.steinberg.de/532+M52087573ab0.html"
	einfo "and place it on ${DISTDIR}"
}

src_unpack() {
	unpack ${A}
	cd "${WORKDIR}"
	unzip ${MY_P2}.zip
}

src_install() {
	cd "${WORKDIR}"/${MY_P2}
	insinto /usr/include/vst
	doins source/common/AEffect.h
	doins source/common/aeffectx.h
}
