# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="2"
inherit eutils

DESCRIPTION="Modern AJAX-style web interface for Citadel"
HOMEPAGE="http://www.citadel.org/"
SRC_URI="http://easyinstall.citadel.org/${P}.tar.gz"

LICENSE="GPL-2 MIT LGPL-3 LGPL-2.1"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="ssl"

DEPEND=">=dev-libs/libical-0.43
	>=dev-libs/libcitadel-${PV}
	ssl? ( >=dev-libs/openssl-0.9.6 )"
RDEPEND="${DEPEND}"

WWWDIR="/usr/share/citadel-webcit"

pkg_setup() {
	#Homedir needs to be the same as --with-datadir
	einfo "Adding Citadel User/Group"
	enewgroup webcit
	enewuser webcit -1 -1 ${WWWDIR} webcit
}

src_configure() {
	econf \
		$(use_with ssl) \
		--with-libical \
		--without-newt \
		--prefix=/usr/sbin/ \
		--with-wwwdir="${WWWDIR}" \
		--with-localedir=/usr/share/ \
		--with-editordir=/usr/share/citadel-webcit/tiny_mce/ \
		--with-rundir=/var/run/citadel \
		--with-ssldir=/etc/ssl/webcit/ \
		--with-datadir=/var/run/citadel
}

src_install() {
	emake DESTDIR="${D}" install || die "make install failed"
	newinitd "${FILESDIR}"/webcit.init.d webcit || die "Installing initscript failed"
	newconfd "${FILESDIR}"/webcit.conf.d webcit || die "Installing conf for initscript failed"

	##House cleaning...
	#We don't use Webcit's setup program
	#Settings are in /etc/conf.d/webcit
	rm "${D}"/usr/sbin/setup || "Removing upstreams setup bin failed"

	dodoc *.txt || die "dodoc failed"
}

pkg_postinst() {
	einfo "Make sure to configure webcit under /etc/conf.d/webcit."
	einfo "Then start the server with /etc/init.d/webcit start"
	einfo
	einfo "Webcit will listen on port 2000 by default"
}
