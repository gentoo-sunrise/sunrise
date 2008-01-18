# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit eutils

DESCRIPTION="A utility to limit the bandwidth used by a process."
HOMEPAGE="http://www.hping.org/netbrake/"
SRC_URI="http://www.hping.org/${PN}/${P}.tar.gz"

LICENSE="X11"
SLOT="0"
KEYWORDS="~x86"

IUSE="httpfs"

DEPEND=""

S=${WORKDIR}/${PN}

src_unpack() {
	unpack ${A}
	cd "${S}"

	# Makefile.in ignores our compiler and compiler flags preference
	epatch "${FILESDIR}/${P}-fix-compiler-and-flags.patch"

	# patch to configure files to install the library and script
	# executable according to gentoo's standards and remove user
	# interaction for compile options
	epatch "${FILESDIR}/${P}-fix-path-and-httpfs.patch"

	use httpfs && export HTTPFS_FLAG=y
}

src_install() {
	dolib libnetbrake.so.0.1
	dobin netbrake

	dodoc AUTHORS CHANGES README THANKS TODO VERSION
}
