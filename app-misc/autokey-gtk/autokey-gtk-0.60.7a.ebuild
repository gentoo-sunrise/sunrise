# Copyright 1999-2009  Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit distutils

DESCRIPTION="A programm for automating tasks in Linux"
HOMEPAGE="http://autokey.sourceforge.net/"
SRC_URI="http://autokey.googlecode.com/files/${PN}_${PV}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~x86"
IUSE=""

DEPEND=">=dev-python/python-xlib-0.14
	dev-python/notify-python
	dev-python/pygtk"

RDEPEND="${DEPEND}"

S="${WORKDIR}/build"

src_install(){
	distutils_src_install
	newinitd "${S}"/debian/autokey-gtk.init autokey || die
}

pkg_postinst () {
	einfo "You should now run /etc/init.d/dbus reload"
	einfo " You may now start the ${PN} deamon with /etc/init.d/autokey start."
	einfo " If you want to start the deamon every time Gentoo starts,"
	einfo " you should run rc-update add autokey default"
}

