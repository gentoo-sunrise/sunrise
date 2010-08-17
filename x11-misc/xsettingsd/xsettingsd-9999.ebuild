# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EGIT_REPO_URI="git://github.com/derat/xsettingsd.git"

inherit git toolchain-funcs

DESCRIPTION="A daemon that implements the XSETTINGS specification."
HOMEPAGE="http://code.google.com/p/xsettingsd/"
SRC_URI=""

LICENSE="BSD-2"
SLOT="0"
KEYWORDS=""
IUSE=""

RDEPEND="x11-libs/libX11"
DEPEND="dev-util/scons
	${RDEPEND}"

src_compile() {
	# scons options differ from make options -> remove everything except "-jX" and "-j X"
	local sconsopts=$(echo "${MAKEOPTS}" | sed -ne "/-j/ { s/.*\(-j[[:space:]]*[0-9]\+\).*/\1/; p }")
	scons CC="$(tc-getCC)" CXX="$(tc-getCXX)" CFLAGS="${CFLAGS}" CXXFLAGS="${CXXFLAGS}" \
		${sconsopts} DESTDIR="${D}" PREFIX="/usr" xsettingsd dump_xsettings \
		|| die 'Please add "${S}/config.opts" when filing bugs reports!'
}

src_install() {
	dobin xsettingsd dump_xsettings || die
}
