# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

AT_NOELIBTOOLIZE=yes

inherit eutils autotools

DESCRIPTION="A curses (text) based password encryption tool"
HOMEPAGE="http://www.guengel.ch/myapps/yapet/"
URI_PREFIX="http://www.guengel.ch/myapps/yapet/downloads/"
SRC_URI="${URI_PREFIX}${P}.tar.bz2
	${URI_PREFIX}patches/${PN}_csv2yapet-${PV}.diff
	${URI_PREFIX}patches/${PN}_cfgfile-${PV}.diff
	${URI_PREFIX}patches/${PN}_vikeys-${PV}.diff"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~x86 ~amd64"
IUSE="nls"

RDEPEND="nls? ( virtual/libintl )
	>=sys-libs/ncurses-5.6
	>=dev-libs/openssl-0.9.7"
DEPEND="${RDEPEND}"

src_unpack() {
	local patchset=(
		"${DISTDIR}/yapet_csv2yapet-${PV}.diff"
		"${DISTDIR}/yapet_cfgfile-${PV}.diff"
		"${DISTDIR}/yapet_vikeys-${PV}.diff"
	)

	unpack "${P}.tar.bz2"
	cd "${S}"

	for x in ${patchset[@]}; do
		epatch ${x}
	done

	eautoreconf
	econf --enable-terminal-title \
		--enable-csv2yapet \
		--disable-source-doc \
		--disable-build-doc \
		$(use_enable nls)
}
