# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=4

inherit eutils versionator

MY_P=${PN}-$(version_format_string '$1.$2.x-dev2')

DESCRIPTION="A GTK+ CPU and Battery Tray Tool"
HOMEPAGE="http://trayfreq.sourceforge.net/"
SRC_URI="mirror://sourceforge/${PN}/${MY_P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64"
IUSE="autostart suid"

DEPEND="x11-libs/gtk+:2"
RDEPEND="${DEPEND}"

S=${WORKDIR}/${MY_P}

src_configure() {
	econf $(use_enable suid setsuid) \
		$(use_enable autostart)
}

src_install() {
	emake DESTDIR="${D}" install

	dodoc AUTHORS README data/trayfreq.config
	newicon data/cpufreq-0.png ${PN}.png
	make_desktop_entry ${PN} "Tray Tool for cpufreq" ${PN}
}

pkg_postinst() {
	if ! use suid; then
		elog "trayfreq requires root privileges"
		elog "if you use sudo you may have to edit sudoers"
		elog "config file will be read from root directory"
	fi
	elog "a sample config file resides in documentation"
}
