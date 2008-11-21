# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header$

DESCRIPTION="Set of utilities to simplify various dns(sec) tasks."
HOMEPAGE="http://www.nlnetlabs.nl/projects/ldns/"
SRC_URI="http://www.nlnetlabs.nl/downloads/ldns/ldns-${PV}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND="dev-libs/openssl
	>=net-libs/ldns-${PV}
	net-libs/libpcap"

S="${WORKDIR}/ldns-${PV}"

DIRS="drill examples"

src_compile() {
	for dir in ${DIRS}; do
		einfo "Building in ${dir}"
		cd "${dir}"
			econf
			emake || die "emake in ""${dir}"" failed"
		cd ..
	done
}

src_install() {
	for dir in ${DIRS}; do
		cd "${dir}"
		emake DESTDIR="${D}" install || die "emake install in ""${dir}"" failed"
		cd ..
	done

	dodoc Changelog README || die "Adding documentation failed"
}
