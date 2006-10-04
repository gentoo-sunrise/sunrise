# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit eutils

DESCRIPTION="Nullsoft Scriptable Install System"
HOMEPAGE="http://nsis.sourceforge.net/"
SRC_URI="mirror://sourceforge/${PN}/${P}-src.tar.bz2"

LICENSE="as-is"
SLOT="0"
KEYWORDS="~x86"
DEPEND=">=dev-util/scons-0.96.91"
S=${WORKDIR}/${P}-src

pkg_setup() {
	has_version cross-mingw32/gcc || die "cross-mingw32/gcc is needed"
}

src_unpack() {
	unpack ${A}
	cd "${S}"

	epatch "${FILESDIR}"/${P}-config.patch
}

src_compile() {
	scons PREFIX=/usr PREFIX_CONF=/etc PREFIX_DOC="/usr/share/doc/${P}" \
		PREFIX_DEST="${D}" SKIPPLUGINS=System || die "scons failed"
}

src_install() {
	scons PREFIX=/usr PREFIX_CONF=/etc PREFIX_DOC="/usr/share/doc/${P}" \
		PREFIX_DEST="${D}" SKIPPLUGINS=System install || die "scons install failed"
	fperms -R go-w,a-x,a+X "/usr/share/{${PN}/,doc/${P}/}" /etc/nsisconf.nsh
}
