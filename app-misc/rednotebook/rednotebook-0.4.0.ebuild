# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

NEED_PYTHON="2.5"
inherit distutils

DESCRIPTION="A Desktop Diary."
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.gz"
HOMEPAGE="http://digitaldump.wordpress.com/projects/rednotebook/"

KEYWORDS="~amd64 ~x86"
SLOT="0"
LICENSE="GPL-3"
IUSE=""

RDEPEND=">=dev-python/pyyaml-3.05
	>=dev-python/wxpython-2.8.8.1"
