# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit eutils qt4

MY_PV="${PV/_p/-}"
MY_P="${PN}-${MY_PV}"

DESCRIPTION="Qt SSL features as a plugin for QCA"
HOMEPAGE="http://delta.affinix.com/qca/"
SRC_URI="http://delta.affinix.com/download/qca/2.0/beta2/${MY_P}.tar.bz2"

LICENSE="GPL-2"
SLOT="2"
KEYWORDS="~x86 ~amd64"
IUSE="debug"

RDEPEND="$(qt_min_version 4.1.0)
	>app-crypt/qca-1.99
	dev-libs/openssl"

DEPEND="${RDEPEND}
	>=sys-apps/sed-4.0"

S="${WORKDIR}/${MY_P}"

src_compile() {
	QTDIR="/usr/lib" ./configure || die "configure failed"

	qmake \
		QMAKE_CFLAGS_RELEASE="${CFLAGS}" \
		QMAKE_CXXFLAGS_RELEASE="${CXXFLAGS}" \
		QMAKE_RPATH= \
		QTDIR="/usr/lib" \
		"CONFIG += no_fixpath release" \
		${PN}.pro \
		|| die "qmake failed"

	# ugly workaround...
	if ! built_with_use qt debug || ! use debug; then
		sed -i -e 's/QtCore_debug/QtCore/g' Makefile
	fi;

	make || die "make failed"
}

src_install() {
	make INSTALL_ROOT="${D}" install || die "make install failed"
	if [ "$(get_libdir)" != "lib" ]; then
		mv ${D}/usr/lib ${D}/usr/$(get_libdir)
	fi

	dodoc README TODO
}
