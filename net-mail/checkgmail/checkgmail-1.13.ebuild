# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit eutils

DESCRIPTION="a Gmail Notifier for Linux"
HOMEPAGE="http://checkgmail.sourceforge.net/"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="clickurl savepwd"

DEPEND=">=dev-perl/gtk2-perl-1.100
	>=dev-perl/gtk2-trayicon-0.03
	>=dev-perl/libwww-perl-5.800
	>=dev-perl/Crypt-SSLeay-0.49
	>=dev-perl/XML-Simple-2.12
	>=x11-libs/gtk+-2.6
	clickurl? ( >=x11-libs/libsexy-0.1.11
			>=dev-perl/Gtk2-Sexy-0.02 )
	savepwd? ( >=dev-perl/Crypt-Simple-0.06 )"
RDEPEND="${DEPEND}"

pkg_setup() {
	if ! built_with_use dev-lang/perl ithreads ; then
		local msg="Please (re)emerge dev-lang/perl with the ithreads USE flag on"
		eerror "${msg}"
		die "${msg}"
	fi
}

src_install() {
	dobin checkgmail || die "dobin failed"
	dodoc ChangeLog Readme todo
	doman man/checkgmail.1.gz
}
