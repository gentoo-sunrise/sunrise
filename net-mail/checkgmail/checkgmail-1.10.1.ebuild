# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

DESCRIPTION="CheckGmail is an alternative Gmail Notifier for Linux"
HOMEPAGE="http://checkgmail.sourceforge.net/"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.bz2"
LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86"

IUSE="savepwd"

DEPEND=">=dev-perl/gtk2-perl-1.100
	>=dev-perl/gtk2-trayicon-0.03
	>=dev-perl/libwww-perl-5.800
	>=dev-perl/Crypt-SSLeay-0.49
	>=dev-perl/XML-Simple-2.12
	>=x11-libs/gtk+-2.6
	savepwd? ( >=dev-perl/Crypt-Simple-0.06 )"

src_install() {
	dobin checkgmail || die "dobin failed"
	dodoc COPYING ChangeLog README TODO
}
