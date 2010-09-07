# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

DESCRIPTION="The Fluid R3 soundfont"
HOMEPAGE="http://archive.ubuntu.com/ubuntu/pool/universe/f/${PN}"
SRC_URI="mirror://ubuntu/pool/universe/f/${PN}/${PN}_${PV}.orig.tar.gz
	 http://dev.gentoo.org/~hwoarang/distfiles/timidity.cfg.bz2"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

src_install() {
	insinto /usr/share/sounds/sf2/
	doins *.sf2 || die
	insinto /usr/share/timidity/${PN}/
	doins ${WORKDIR}/timidity.cfg || die
}

pkg_postinst() {
	elog "If you wish to use this soundfont with timidity++ you must run"
	elog "cd /usr/share/timidity && ln -sTf ${PN} current"
}
