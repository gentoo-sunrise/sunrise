# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

DESCRIPTION="Nintendo DS Libraries for devkitPro ARM"
HOMEPAGE="http://devkitpro.org/"
SRC_URI="mirror://sourceforge/devkitpro/libnds-src-${PV}.tar.bz2"

LICENSE="as-is"
SLOT="0"
KEYWORDS="~x86"
IUSE=""

DEPEND="dev-util/devkitarm-bin"
RDEPEND=${DEPEND}

S=${WORKDIR}
RESTRICT="strip"

DEVKITPRO=/opt/devkitpro

src_compile() {
	local DEVKITARM=${DEVKITPRO}/devkitARM
	local PATH=${PATH}:"${DEVKITARM}/bin"
	emake -j1 || die "make failed"
}

src_install() {
	insinto "${DEVKITPRO}"/libnds
	into "${DEVKITPRO}"/libnds

	# libs installation
	dolib.a lib/*.a || die "lib.a files installation failed"

	# headers installation
	doins -r include/ || die "include files installation failed"
}
