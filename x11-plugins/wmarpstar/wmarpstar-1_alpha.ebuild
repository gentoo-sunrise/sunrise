# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit toolchain-funcs

DESCRIPTION="Arpstar dockapp for alert visualization"
HOMEPAGE="http://arpstar.sourceforge.net"
SRC_URI="mirror://sourceforge/arpstar/${PN}-alpha1.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86"
IUSE=""

DEPEND="virtual/logger
	x11-libs/libX11
	x11-libs/libXpm
	x11-proto/xextproto"
RDEPEND="${DEPEND}
	net-misc/arpstar"

S="${WORKDIR}/${PN}_wa_alpha1"

src_compile() {
	sed -i \
		-e "/^CXX=/s:c++:$(tc-getCXX):" \
		Makefile

	emake || die "emake failed"
}

src_install() {
	dobin wmarpstar
	dodoc arpstar-syslog-ng.conf
}

pkg_postinst() {
	elog "You have to change your system logger's configuration"
	elog "to make wmarpstar work. Have a look at"
	elog "/usr/share/doc/${PF}/ for a sample configuration for syslog-ng."
}
