# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /mnt/back/repository/c/wbar/ebuild/wbar-1.2.ebuild,v 1.3 2006/12/29 02:39:34 warlock Exp $

inherit eutils

DESCRIPTION="Light, fast and animated quick launch bar"
HOMEPAGE="http://www.tecnologia-aplicada.com.ar/rodolfo/"
SRC_URI="http://www.tecapli.com.ar/rodolfo/${P}.tbz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86"
IUSE="animation"

DEPEND="media-libs/imlib2"
RDEPEND="${DEPEND}"

src_unpack() {
	unpack ${A}
	cd "${S}"

	use animation && epatch animation2.patch
}

src_install() {

	dodir /usr/share/wbar/
	awk '{if($$1 ~ /i:/ || ($$1 ~ /t:/ && NR<4)) print $$1" /usr/share/wbar/"$$2; else
	print $$0;}' dot.wbar > "${D}/usr/share/wbar/dot.wbar"

	cp -a wbar.icons "${D}/usr/share/wbar"
	dobin wbar
}
