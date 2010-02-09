# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

DESCRIPTION="Command line tool to interface with RememberTheMilk"
HOMEPAGE="http://www.rutschle.net/rtm/"
SRC_URI="http://www.rutschle.net/${PN}/${P}.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND="dev-lang/perl
	dev-perl/DateManip
	>=dev-perl/WebService-RTMAgent-0.5"

src_install() {
	newbin ${P} ${PN} || die "newbin failed"
}

pkg_postinst() {
	elog "You will need to run ${PN} --authorise before running ${PN} for the first"
	elog "time. Visit the URL it gives you and follow the steps"
}
