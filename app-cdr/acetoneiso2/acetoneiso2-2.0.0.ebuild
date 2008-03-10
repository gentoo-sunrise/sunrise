# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=1

inherit qt4

DESCRIPTION="Graphical tool to do a lot things with image files like extracting, mounting, encrypting."
HOMEPAGE="http://sourceforge.net/projects/acetoneiso2/"
SRC_URI="mirror://sourceforge/${PN}/${PN}_${PV}-source.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="cdr crypt"

DEPEND="
	x11-libs/qt:4
	cdr? ( || ( app-cdr/cdrtools app-cdr/cdrkit )
	app-cdr/cdrdao )
	app-arch/p7zip
	|| ( kde-base/konqueror gnome-base/nautilus kde-base/kdebase )
	crypt? ( >=app-crypt/gnupg-2 )
	sys-fs/fuse
	sys-fs/fuseiso"

RDEPEND=${DEPEND}

S="${WORKDIR}"/${PN}/src/

src_compile() {
	eqmake4 || die "qmake failed"
	emake || die "emake failed"
}

src_install() {
	INSTALL_ROOT="${D}" einstall || die "install failed"
}
