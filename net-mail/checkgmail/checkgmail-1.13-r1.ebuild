# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="2"

inherit eutils

DESCRIPTION="a Gmail Notifier for Linux"
HOMEPAGE="http://checkgmail.sourceforge.net/"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="clickurl savepwd"

RDEPEND="dev-lang/perl[ithreads]
	dev-perl/gtk2-perl
	dev-perl/gtk2-trayicon
	dev-perl/libwww-perl
	dev-perl/Crypt-SSLeay
	dev-perl/XML-Simple
        clickurl? ( dev-perl/Gtk2-Sexy )
	savepwd? ( dev-perl/Crypt-Simple )"

src_prepare() {
	# This patch combines changes from svn revisions r30, r33 and r36
	epatch "${FILESDIR}"/gmail-login-procedure-fix.patch
}

src_install() {
	dobin checkgmail || die "dobin failed"
	dodoc ChangeLog Readme todo || die "dodoc failed"
	doman man/checkgmail.1.gz || die "doman failed"
}
