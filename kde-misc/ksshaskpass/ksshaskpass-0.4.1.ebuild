# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

ARTS_REQUIRED="never"

inherit kde cmake-utils

DESCRIPTION="KDE implementation of ssh-askpass with Kwallet integration."
HOMEPAGE="http://www.kde-apps.org/content/show.php/Ksshaskpass?content=50971"
SRC_URI="http://alioth.debian.org/~trigger-guest/${PN}/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="kdeenablefinal"

RDEPEND="net-misc/openssh"

PATCHES=( "${FILESDIR}/CMakeLists.patch" )
CMAKE_IN_SOURCE_BUILD=1

need-kde 3.5

src_install() {
	exeinto ${KDEDIR}/bin
	doexe src/${PN} || die "doexe failed"
	dodoc ChangeLog TODO || die "dodoc failed"
	doman src/${PN}.1 || die "doman failed"
}
