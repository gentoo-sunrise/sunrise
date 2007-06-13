# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit font versionator

MY_PN="LinLibertineFont"

DESCRIPTION="Linux Libertine Open Font"
HOMEPAGE="http://linuxlibertine.sourceforge.net/"
SRC_URI="mirror://sourceforge/linuxlibertine/${MY_PN}-$(get_version_component_range 1-2).tgz"

LICENSE="|| ( GPL-2 OFL )"
SLOT="0"
KEYWORDS="~x86"
IUSE=""

S="${WORKDIR}/${MY_PN}"
DOCS="Bugs ChangeLog.txt Readme"
FONT_SUFFIX="ttf"
FONT_S="${S}"
