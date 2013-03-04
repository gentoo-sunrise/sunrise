# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="3"

inherit qt4-r2

MY_PV=${PV/_p/ubuntu}
DESCRIPTION="Reader for Orayta Jewish Book Collection"
HOMEPAGE="http://orayta.googlecode.com/"
SRC_URI="http://launchpad.net/~moshe-wagner/+archive/orayta/+files/${PN}_${MY_PV}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

DEPEND=">=dev-qt/qtgui-4.5:4
	>=dev-qt/qtxmlpatterns-4.5:4
	>=kde-base/kdelibs-4
	>=dev-qt/qtwebkit-4.5:4"
RDEPEND="${DEPEND}
	app-dicts/orayta-books"

S="${WORKDIR}/svn"

src_prepare() {
	#Unhide project file (for some reason hidden in tarball)
	mv hide.tmp Orayta.pro || die 'Project File missing'

	sed -i 's|/usr/local/bin|/usr/bin|' Orayta.pro

	qt4-r2_src_prepare
}
