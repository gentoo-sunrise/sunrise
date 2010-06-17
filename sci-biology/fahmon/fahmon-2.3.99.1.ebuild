# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="2"

WX_GTK_VER="2.8"
inherit base wxwidgets

MY_P=FahMon-${PV}
DESCRIPTION="wxGTK monitor for the folding@home client"
HOMEPAGE="http://fahmon.net/"
SRC_URI="http://fahmon.net/downloads/${MY_P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND="
	x11-libs/wxGTK:${WX_GTK_VER}[X]
	net-misc/curl"
DEPEND="${RDEPEND}"

S=${WORKDIR}/${MY_P}
