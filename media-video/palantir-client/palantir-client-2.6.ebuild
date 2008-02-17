# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="1"
inherit eutils qt3

MY_PN=${PN/-client/}
MY_P=${MY_PN}-${PV}

DESCRIPTION="Transmit live video, audio and data over a TCP/IP network, as well as to control remote devices."
HOMEPAGE="http://www.fastpath.it/products/palantir/index.php"
SRC_URI="http://www.fastpath.it/products/${MY_PN}/pub/${MY_P}.tgz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86"
IUSE=""

DEPEND=">=x11-libs/qt-3.3:3"
RDEPEND="${DEPEND}"

S=${WORKDIR}/${MY_P}/clients/qt

src_unpack() {
	unpack ${A}
	cd "${S}"

	# patching in subdir because there are ebuilds for parts of this package
	epatch "${FILESDIR}/${PV}-senselessConfigFileHandling.patch"

	sed -i  \
		-e 's/-ggdb//' \
		-e 's/CPPFLAGS/CPPFLAGS+/' \
		-e 's/g++/$(CXX)/g' \
		Makefile || die "sed failed"

	# Fix the relative path
	for file in $(ls *.cpp *.h); do
		sed -i \
			-e 's#./icons#/usr/share/palantir-client/icons#g' \
			-e 's#./pclient.ini#/usr/share/palantir-client/pclient.ini#g' \
			${file} || die "sed failed"
	done
}

src_install() {
	dobin pclient
	dodoc README
	insinto /usr/share/${PN}
	doins -r icons/
	doins pclient.ini
}
