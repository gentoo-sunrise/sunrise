# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit eutils python multilib

DESCRIPTION="Python based jabber transport for AIM"
HOMEPAGE="http://pyaim-t.blathersource.org/"
SRC_URI="http://www.blathersource.org/download.php/${PN}/${P}.tar.gz"
LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86"
IUSE="web"
NEED_PYTHON=2.3

DEPEND=">=net-im/jabber-base-0.0"
RDEPEND="${DEPEND}
	>=dev-python/twisted-1.3.0
	>=dev-python/twisted-words-0.1.0
	>=dev-python/twisted-xish-0.1.0
	>=dev-python/twisted-web-0.5.0
	web? ( >=dev-python/nevow-0.4.1 )
	>=dev-python/imaging-1.1"

src_install() {
	python_version
	insinto /usr/$(get_libdir)/python${PYVER}/site-packages/${PN}/
	doins -r tools src data
	newins PyAIMt.py ${PN}.py

	insinto /etc/jabber
	newins config_example.xml ${PN}.xml
	fperms 600 /etc/jabber/${PN}.xml
	fowners jabber:jabber /etc/jabber/${PN}.xml
	dosed \
		"s:<spooldir>[^\<]*</spooldir>:<spooldir>/var/spool/jabber/</spooldir>:" \
		/etc/jabber/${PN}.xml
	dosed \
		"s:<pid>[^\<]*</pid>:<pid>/var/run/jabber/${PN}.pid</pid>:" \
		/etc/jabber/${PN}.xml

	newinitd "${FILESDIR}/${P}.initd" ${PN}
	dosed "s/PATH/python${PYVER}/" /etc/init.d/${PN}
}

pkg_postinst() {
	elog "A sample configuration file has been installed in /etc/jabber/${PN}.xml."
	elog "Please edit it and the configuration of your Jabber server to match."
	elog "You also need to create a directory aim.yourjabberhostname.tld in"
	elog "/var/spool/jabber and chown it to jabber:jabber."
}
