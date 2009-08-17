# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header$

EAPI=2

DESCRIPTION="Set of utilities to simplify various dns(sec) tasks."
HOMEPAGE="http://www.nlnetlabs.nl/projects/ldns/"
SRC_URI="http://www.nlnetlabs.nl/downloads/ldns/ldns-${PV}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="sha2 ssl"

DEPEND=">=net-libs/ldns-${PV}[sha2?,ssl?]
	net-libs/libpcap"
RDEPEND=${DEPEND}

S=${WORKDIR}/ldns-${PV}

pkg_setup() {
	if use sha2; then
		if ! use ssl; then
			die "For sha2 support, you have to enable ssl USE flag too"
		fi
		ewarn "You enabled sha2 USE flag, this is still experimental"
	fi
}

src_configure() {
	cd "${S}"/drill
	econf $(use_with ssl)

	cd "${S}"/examples
	econf $(use_enable sha2) $(use_with ssl)
}

src_compile() {
	emake -C drill || die "emake for drill failed"
	emake -C examples || die "emake for examples failed"
}

src_install() {
	emake -C drill DESTDIR="${D}" install || die "emake install for drill failed"
	emake -C examples DESTDIR="${D}" install || die "emake install for examples failed"

	dodoc Changelog README || die "Adding documentation failed"
}
