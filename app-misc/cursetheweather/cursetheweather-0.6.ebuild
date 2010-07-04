# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit distutils

MY_P="CurseTheWeather-${PV}"

DESCRIPTION="An ncurses-based weather forecast program"
HOMEPAGE="http://opensource.hld.ca/trac.cgi/wiki/CurseTheWeather"
SRC_URI="http://opensource.hld.ca/trac.cgi/export/latest/trunk/ctw/dist/${MY_P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86"
IUSE=""

DEPEND="sys-libs/ncurses"
RDEPEND="${DEPEND}"

S=${WORKDIR}/${MY_P}
