# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=2

inherit eutils

DESCRIPTION="Clusterm permit to cluster ssh operations"
HOMEPAGE="https://sourceforge.net/projects/clusterm/"
SRC_URI="mirror://sourceforge/clusterm/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND="dev-perl/gnome2-gconf
	dev-perl/gnome2-perl
	dev-perl/Gnome2-Vte
	dev-perl/gtk2-perl"
RDEPEND="${DEPEND}"

src_prepare() {
	epatch "${FILESDIR}"/${P}.patch
	epatch "${FILESDIR}"/${P}-perldoc.patch
}

src_install() {
	emake PREFIX="/usr" DESTDIR="${D}" install || die "emake install failed"
}
