# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=2
inherit eutils qt4

DESCRIPTION="Graphical tool to do a lot things with image files like extracting, mounting, encrypting."
HOMEPAGE="http://sourceforge.net/projects/acetoneiso2/"
SRC_URI="mirror://sourceforge/${PN}/${PN}_${PV}_source.tar.bz2"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND="|| ( x11-libs/qt-gui:4 x11-libs/qt:4 )"

RDEPEND="${DEPEND}
	sys-fs/fuse
	sys-fs/fuseiso
	|| ( kde-base/dolphin kde-base/kdebase kde-base/konqueror gnome-base/nautilus )
	>=app-crypt/gnupg-2
	app-crypt/pinentry"

S="${WORKDIR}"/${PN}/src/

src_prepare() {
	# Fix prestripping bug 221745
	epatch "${FILESDIR}/${PN}-nostrip.patch"
}

src_configure() {
	eqmake4
}

src_install() {
	INSTALL_ROOT="${D}" einstall || die "install failed"
}
