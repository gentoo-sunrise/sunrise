# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="4"

# Require python-2 with sqlite USE flag
PYTHON_DEPEND="2:2.6"
PYTHON_USE_WITH="sqlite"

inherit eutils python user

MY_P="${P/sab/SAB}"

DESCRIPTION="Binary newsgrabber in Python, with web-interface. Successor of old SABnzbd project"
HOMEPAGE="http://www.sabnzbd.org/"
SRC_URI="mirror://sourceforge/sabnzbdplus/${MY_P}-src.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

RDEPEND="
	app-arch/par2cmdline
	app-arch/unrar
	app-arch/unzip
	dev-python/cheetah
	dev-python/pyopenssl
	dev-python/yenc
"

S="${WORKDIR}/${MY_P}"
DHOMEDIR="/var/lib/${PN}"

pkg_setup() {
	# Control PYTHON_USE_WITH
	python_set_active_version 2
	python_pkg_setup

	# Create sabnzbd group
	enewgroup ${PN}
	# Create sabnzbd user, put in sabnzbd group
	enewuser ${PN} -1 -1 "${DHOMEDIR}" ${PN}
}

src_install() {
	dodoc {ABOUT,CHANGELOG,ISSUES,README}.txt Sample-PostProc.sh

	newconfd "${FILESDIR}/${PN}.conf" ${PN}

	newinitd "${FILESDIR}/${PN}.init" ${PN}

	# Default configuration file
	insinto "${DHOMEDIR}/config"
	doins "${FILESDIR}/${PN}.ini"

	# Assign ownership of SABnzbd default directory
	fowners -R root:${PN} "${DHOMEDIR}"
	fperms -R 770 "${DHOMEDIR}"

	# Rotation of logfile
	insinto /etc/logrotate.d
	newins "${FILESDIR}/${PN}.logrotate" ${PN}

	# Add themes & code into /usr/share
	insinto /usr/share/${PN}
	doins -r cherrypy email gntp interfaces locale po sabnzbd SABnzbd.py tools util

	# Adjust permissions in python source directory for root:sabnzbd
	fowners -R root:${PN} /usr/share/${PN}
	fperms -R 770 /usr/share/${PN}
}

pkg_postinst() {
	python_mod_optimize /usr/share/${PN}

	elog "SABnzbd has been installed with default directories in ${DHOMEDIR}"
	elog
	elog "Please configure /etc/conf.d/${PN} before starting as daemon!"
	elog "If you use SSL connection for SABnzbd WebUi, you have to change SAB_PORT with \"9090\"."
	elog
	elog "Start with ${ROOT}etc/init.d/${PN} start"
	elog "Visit http://<host ip>:8080 to configure SABnzbd"
	elog "Default web username/password : sabnzbd/secret"
	elog
	elog "Add CONFIG_PROTECT=\"${DHOMEDIR}/config\" to your make.conf. Otherwise, we will lose your personal configuration"
}

pkg_postrm() {
	python_mod_cleanup /usr/share/${PN}
}
