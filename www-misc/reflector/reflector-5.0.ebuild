# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=2

DESCRIPTION="archlinux's take on mirrorselect"
HOMEPAGE="http://xyne.archlinux.ca/projects/reflector/"
SRC_URI="http://xyne.archlinux.ca/src/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

RDEPEND="dev-lang/perl
	dev-perl/perl-xyne-arch"

S=${WORKDIR}/${PN}

src_install() {
	dobin ${PN} || die

	doman man/* || die
}
