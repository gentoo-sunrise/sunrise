# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="4"

inherit cmake-utils git-2

EGIT_REPO_URI="git://gitorious.org/qtpanel/qtpanel.git"

DESCRIPTION="Yet another desktop panel written in Qt"
HOMEPAGE="https://gitorious.org/qtpanel/qtpanel"
SRC_URI=""

LICENSE="GPL-3"
SLOT="0"
KEYWORDS=""
IUSE=""

RDEPEND="x11-libs/libX11
	x11-libs/libXcomposite
	x11-libs/libXdamage
	dev-qt/qtgui:4"
DEPEND="${RDEPEND}"

src_install() {
	dobin ${CMAKE_BUILD_DIR}/${PN}
}
