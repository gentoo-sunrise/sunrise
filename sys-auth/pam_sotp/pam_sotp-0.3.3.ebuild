# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit eutils multilib pam

DESCRIPTION="pam module for simple one time password authentication"
HOMEPAGE="http://www.cavecanen.org/cs/projects/pam_sotp/"
SRC_URI="http://www.cavecanen.org/cs/projects/pam_sotp/dl/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="debug urandom"

DEPEND=">=sys-libs/pam-0.78-r3"
RDEPEND="${DEPEND}"

pkg_setup() {
	enewgroup shadow
}

src_compile() {
	local myconf=""

	use urandom && myconf="--with-randomdev=/dev/urandom"
	econf --libdir="/$(get_libdir)" $(use_enable debug) ${myconf}
	emake || die "emake failed"
}

src_install() {
	dopamd etc/pam.d/otppasswd
	dopammod src/pam/${PN}.so
	diropts -m0770 -o root -g shadow
	keepdir /etc/sotp

	dobin src/utils/otppasswd
	fowners root:shadow /usr/bin/otppasswd
	fperms 2755 /usr/bin/otppasswd

	dodoc AUTHORS ChangeLog NEWS README
	dohtml doc/manual/html/*
}

pkg_postinst() {
	elog "See manual.html in /usr/share/doc/${PF}/html and otppasswd -h"
	elog "for configuration hints."
}
