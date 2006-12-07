# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

DESCRIPTION="Provides a suite of standard drivers, a PPD file compiler, and other utilities that can be used to develop printer drivers for CUPS and other printing environments."
HOMEPAGE="http://www.cups.org/ddk/index.php"
SRC_URI="http://jdettner.free.fr/gentoo/cupsddk/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86"
IUSE=""

DEPEND=""
RDEPEND=""

S="${WORKDIR}"

src_compile() {
	econf BUILDROOT="${D}" || die "econf failed"
	emake BUILDROOT="${D}" || die "emake failed"
}

src_install() {
	emake BUILDROOT="${D}" install || die "emake install failed"
}

