# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

DESCRIPTION="Wifi for Nintendo DS Homebrew Development"
HOMEPAGE="http://akkit.org/dswifi/"
SRC_URI="mirror://sourceforge/devkitpro/dswifi-src-${PV}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86"
IUSE=""

DEPEND=">=dev-util/devkitarm-bin-21
		>=dev-libs/libnds-20071023"
RDEPEND="${DEPEND}"

S=${WORKDIR}
RESTRICT="strip"

DEVKITPRO=/opt/devkitpro

src_compile() {
	local DEVKITARM=${DEVKITPRO}/devkitARM
	local PATH=${PATH}:"${DEVKITARM}/bin"
	emake || die "make failed"
}

src_install() {
	local INSTDIR=/opt/devkitpro/libnds

	# libs installation
	insinto "${INSTDIR}"/lib
	doins lib/*.a

	# headers installation
	insinto "${INSTDIR}"
	doins -r include/
}
