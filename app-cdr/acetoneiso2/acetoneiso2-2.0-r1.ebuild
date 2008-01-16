# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-cdr/acetoneiso2/acetoneiso2-2.0-r1.ebuild,v 1.0 2008/01/16 09:39:58 ampheus Exp $

EAPI=1

inherit eutils qt4

DESCRIPTION="Extracting and browsing .iso files"
HOMEPAGE="http://sourceforge.net/projects/acetoneiso2/"
SRC_URI="mirror://sourceforge/acetoneiso2/acetoneiso2_${PV}-RC1.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="cdr crypt"

DEPEND="
	x11-libs/qt:4
	cdr? ( 	app-cdr/cdrtools
		app-cdr/cdrdao )
	app-arch/p7zip
	|| ( kde-base/konqueror gnome-base/nautilus kde-base/kdebase )
	crypt? ( >=app-crypt/gnupg-2 )
	sys-fs/fuse"

RDEPEND=${DEPEND}

S="${WORKDIR}"/${PN}/src/

src_compile() {
	eqmake4 || die "qmake failed"
	emake || die "emake failed"
}

src_install() {
	INSTALL_ROOT="${D}" einstall || die "install failed"
}
