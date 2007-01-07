# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit versionator

MY_P="linunace$(delete_all_version_separators)"
MY_PN="unace"

DESCRIPTION="ACE unarchiver"
HOMEPAGE="http://www.winace.com/"
SRC_URI="http://www.winace.com/files/${MY_P}.tgz"

LICENSE="UNACE"
SLOT="0"
KEYWORDS="~x86"
IUSE=""

DEPEND=""

RESTRICT="strip"

S="${WORKDIR}"

src_install() {
	into /opt/${MY_PN}
	newbin ${MY_PN} ${PN}
	dodir /opt/bin
	dosym /opt/${MY_PN}/bin/${PN} /opt/bin/${PN}
}

pkg_postinst() {
	elog "This version of UnAce is installed as unace-bin to make possible to use both"
	elog "source and binary packages at the same time"
}
