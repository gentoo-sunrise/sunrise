# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=4

inherit base versionator

MY_P=${PN}-$(delete_version_separator 2)

DESCRIPTION="A curses (text) based password encryption tool"
HOMEPAGE="http://www.guengel.ch/myapps/yapet/"
SRC_URI="http://www.guengel.ch/myapps/yapet/downloads/${MY_P}.tar.bz2"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="csv nls pwgen"

RDEPEND="nls? ( virtual/libintl )
	>=sys-libs/ncurses-5.6
	>=dev-libs/openssl-0.9.7"
DEPEND="${RDEPEND}"

S=${WORKDIR}/${MY_P}

src_configure() {
	econf --enable-terminal-title \
		--disable-source-doc \
		--disable-build-doc \
		$(use_enable csv csv2yapet) \
		$(use_enable nls) \
		$(use_enable pwgen)
}
