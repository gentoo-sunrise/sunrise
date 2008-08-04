# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=1
inherit qt4

DESCRIPTION="Graphical tool to do a lot things with image files like extracting, mounting, encrypting."
HOMEPAGE="http://sourceforge.net/projects/acetoneiso2/"
SRC_URI="mirror://sourceforge/${PN}/${PN}_${PV}_source.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="7zip cdr crypt"

DEPEND="x11-libs/qt:4
	|| ( kde-base/konqueror gnome-base/nautilus kde-base/kdebase )
	sys-fs/fuse
	sys-fs/fuseiso"

RDEPEND="${DEPEND}
	7zip? ( app-arch/p7zip )
	cdr? ( virtual/cdrtools app-cdr/cdrdao )
	crypt? ( >=app-crypt/gnupg-2 app-crypt/pinentry )"

S="${WORKDIR}"/${PN}/src/

src_compile() {
	eqmake4
	emake || die "emake failed"
}

src_install() {
	INSTALL_ROOT="${D}" einstall || die "install failed"
}
