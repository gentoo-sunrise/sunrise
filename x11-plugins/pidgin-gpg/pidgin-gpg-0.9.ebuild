# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=4

AUTOTOOLS_AUTORECONF="1"
inherit autotools-utils

DESCRIPTION="GPG/OpenPGP Plugin for Pidgin (XEP-0027)"
HOMEPAGE="https://github.com/segler-alex/Pidgin-GPG"
SRC_URI="mirror://github/segler-alex/Pidgin-GPG/${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

RDEPEND="app-crypt/gnupg
	app-crypt/gpgme
	net-im/pidgin"
DEPEND="${RDEPEND}
	virtual/pkgconfig"

PATCHES=( "${FILESDIR}"/${P}-automake-1.12.patch )

src_install() {
	autotools-utils_src_install
	prune_libtool_files --all
}
