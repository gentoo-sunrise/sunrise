# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

DESCRIPTION="DevKitPro toolchain for ARM processors"
HOMEPAGE="http://devkitpro.org/"
SRC_URI="mirror://sourceforge/devkitpro/devkitARM_r${PV}-i686-linux.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86"
IUSE=""

S="${WORKDIR}/devkitARM"
RESTRICT="strip"

dir=/opt/devkitpro/devkitARM

QA_EXECSTACK="${dir:1}/lib/gcc/arm-eabi/4.3.0/thumb/*.o
	${dir:1}/lib/gcc/arm-eabi/4.3.0/*.o
	${dir:1}/arm-eabi/lib/*.o
	${dir:1}/libexec/gcc/arm-eabi/4.3.0/cc1*"

src_install() {
	insinto /opt/devkitpro/devkitARM
	insopts -m0755
	doins -r *

	doenvd "${FILESDIR}/99devkitpro"
}
