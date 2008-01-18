# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

DESCRIPTION="lists system information available to the OS"
HOMEPAGE="http://osinfo.berlios.de"
SRC_URI="ftp://ftp.berlios.de/pub/${PN}/${P}.tar.bz2"

S="${WORKDIR}/${PN}"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~x86"
#IUSE="devices hdd html tcp"
IUSE="" #no use flags until Makefile understands to drop a module

DEPEND=""
RDEPEND="sys-devel/bc
		|| ( sys-apps/gawk sys-apps/mawk )
		dev-libs/libxslt
		sys-apps/lshw
		sys-apps/pciutils
		sys-apps/usbutils
		sys-apps/hdparm
		app-admin/hddtemp
		>=sys-apps/smartmontools-5.36
		|| ( net-analyzer/netcat net-analyzer/netcat6 net-analyzer/gnu-netcat )"

src_install() {
	dobin osinfo
	doman man/osinfo.1
	dodoc docs/*
}

pkg_postinst() {
	elog
	elog "Osinfo is still a beta application - you can help fix bugs by joining"
	elog "the osinfo mailinglist: osinfo@lists.berlios.de"
	elog
#	elog "Osinfo has some nice features that are not obvious at first:"
#	elog "-  Create an HTML document of the computers in your LAN"
#	elog "-  Run osinfo in daemon mode on a box with an Apache server."
#	elog "-  Send the xml sheet to the daemon with the --tcpsend option."
#	elog "These features are still incomplete and are not yet installed by the ebuild,"
#	elog "but you can help to improve them!"
#	elog
#	elog "You can freely add more modules to osinfo. Check the source"
#	elog "code inside the tarball. Thank you for interest."
#	elog
}
