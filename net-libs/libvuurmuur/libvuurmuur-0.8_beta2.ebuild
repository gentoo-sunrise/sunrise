# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="2"

inherit autotools multilib

MY_PV=${PV/_beta/beta}
MY_P="Vuurmuur-${MY_PV}"

DESCRIPTION="Libraries and plugins required by Vuurmuur"
HOMEPAGE="http://www.vuurmuur.org"
SRC_URI="ftp://ftp.vuurmuur.org/releases/${MY_PV}/${MY_P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND="net-firewall/iptables"
RDEPEND="${DEPEND}"

S="${WORKDIR}/${MY_P}/${PN}-${MY_PV}"

src_unpack() {
	default
	cd "${MY_P}"
	unpack "./libvuurmuur-${MY_PV}.tar.gz"
}

src_prepare() {
	epatch "${FILESDIR}"/libvuurmuur-plugin-0.7.patch   # no longer needed for >0.8_beta2
	eautoreconf
}

src_configure() {
	econf --with-plugindir=/usr/$(get_libdir)
}

src_install() {
	emake DESTDIR="${D}" install || die "installing libvuurmuur failed"

	# files needed but not yet installed by make
	dodir /etc/vuurmuur/textdir || die "installing textdir failed"
	insinto /etc/vuurmuur/plugins
	doins plugins/textdir/textdir.conf || die "installing textdir.conf failed"
}
