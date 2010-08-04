# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=2

inherit base versionator

DESCRIPTION="a high-speed network authentication cracking tool"
HOMEPAGE="http://nmap.org/ncrack/"
MY_P="${PN}-$(get_version_component_range 1-2)ALPHA"
SRC_URI="http://nmap.org/${PN}/dist/${MY_P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64"
IUSE="ssl"

RDEPEND="ssl? ( dev-libs/openssl )"
DEPEND="${RDEPEND}"

S=${WORKDIR}/${MY_P}

src_prepare() {
	sed -i -e '/STRIP =/s:= .*:= echo:' Makefile.in || die
}

src_configure() {
	econf --with-openssl=$(use ssl && echo yes || echo no)
}

DOCS=( CHANGELOG docs/{AUTHORS,TODO,{engine,mirror_pool,openssh-library}.txt} )
