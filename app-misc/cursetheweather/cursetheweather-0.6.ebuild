# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=2
PYTHON_DEPEND=2
PYTHON_USE_WITH=ncurses
SUPPORT_PYTHON_ABIS=1
RESTRICT_PYTHON_ABIS='3.*'

inherit distutils

MY_P="CurseTheWeather-${PV}"

DESCRIPTION="An ncurses-based weather forecast program"
HOMEPAGE="http://opensource.hld.ca/trac.cgi/wiki/CurseTheWeather"
SRC_URI="http://opensource.hld.ca/trac.cgi/export/latest/trunk/ctw/dist/${MY_P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

S=${WORKDIR}/${MY_P}
