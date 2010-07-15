# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=2

inherit eutils

DESCRIPTION="A monitoring system based on Nagios"
HOMEPAGE="http://www.icinga.org/"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="dbi ssl"

RDEPEND="dbi? ( dev-db/libdbi-drivers )
	ssl? ( dev-libs/openssl )"
DEPEND="${RDEPEND}"

pkg_setup() {
	enewgroup icinga
	enewuser icinga -1 -1 -1 icinga
}

src_configure() {
	econf --with-posix-regex \
		$(use_enable ssl) \
		$(use_enable dbi idoutils)
}

src_compile() {
	emake all || die "emake failed"
}

src_install() {
	emake DESTDIR="${D}" install-unstripped install-api install-init install-config install-commandmode || die
	if use dbi; then
		emake DESTDIR="${D}" install-idoutils || die
	fi
	dodoc README THANKS AUTHORS || die "dodoc failed"
}
