# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

WANT_AUTOCONF="latest"
WANT_AUTOMAKE="latest"

inherit autotools

DESCRIPTION="Multiuser IRC proxy with ssl support"
SRC_URI="mirror://berlios/bip/${P}.tar.bz2"
HOMEPAGE="http://bip.berlios.de/"

SLOT="0"
LICENSE="GPL-2"
KEYWORDS="~x86"
IUSE="ssl"

DEPEND="ssl? ( dev-libs/openssl )"

src_unpack() {
	unpack ${A}
	cd "${S}"

	# Respect CFLAGS
	sed -i -e "s/CFLAGS=\"-O2 -W -Wall\"/CFLAGS=\"${CFLAGS}\"/g" \
		configure.in || die "sed failed"

	eautoreconf
}

src_compile() {
	local myconf=""
	use ssl || myconf="--disable-ssl"

	econf ${myconf} || die "econf failed"
	emake || die "emake failed"
}

src_install() {
	dobin src/bip src/bipmkpw || "dobin failed"
	insinto "/usr/share/${PN}"
	doins samples/bip.conf

	dodoc AUTHORS ChangeLog README NEWS TODO
	doman bip.1 bip.conf.1 bipmkpw.1
}

pkg_postinst() {
	elog
	elog "Copy the /usr/share/${PN}/bip.conf file to ~/.bip/bip.conf"
	elog "and modify it according to your needs"
	elog
}
