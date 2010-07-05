# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

DESCRIPTION="Wifi for Nintendo DS Homebrew Development"
HOMEPAGE="http://akkit.org/dswifi/"
SRC_URI="mirror://sourceforge/devkitpro/${PN}-src-${PV}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86"
IUSE=""

DEPEND=">=dev-util/devkitarm-bin-21
	dev-libs/libnds"
RDEPEND="${DEPEND}"

S=${WORKDIR}
RESTRICT="strip"

src_compile() {
	export DEVKITPRO=/opt/devkitpro
	export DEVKITARM=${DEVKITPRO}/devkitARM

	local PATH=${PATH}:${DEVKITARM}/bin
	emake || die "make failed"
}

src_install() {
	insinto "${DEVKITPRO}"/libnds
	into "${DEVKITPRO}"/libnds

	# libs installation
	dolib.a lib/*.a || die

	# headers installation
	doins -r include/ || die
}
