# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

DESCRIPTION="Nigel's Monitor - provided by IBM"
HOMEPAGE="http://www.ibm.com/collaboration/wiki/display/WikiPtype/nmon"
SRC_URI="amd64? ( http://www.ibm.com/developerworks/wikis/download/attachments/53871937/${PN}_x86_64_${PV}.zip )
	x86? ( http://www.ibm.com/developerworks/wikis/download/attachments/53871937/${PN}_x86_${PV}.zip )"

LICENSE="as-is"
SLOT="0"
KEYWORDS="~x86 ~amd64"
IUSE=""

DEPEND="app-arch/unzip"
RDEPEND="sys-apps/lsb-release
	sys-libs/ncurses"

S=${WORKDIR}

src_install() {
	# also supports ppc?
	use x86 && ARCH=x86
	use amd64 && ARCH=x86_64

	newbin nmon_${ARCH}_ubuntu810 nmon || die "newbin failed"
}
