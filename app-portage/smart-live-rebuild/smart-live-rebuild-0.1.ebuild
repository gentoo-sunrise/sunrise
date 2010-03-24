# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

PYTHON_DEPEND=2
inherit python

DESCRIPTION="Update live packages and emerge the modified ones"
HOMEPAGE="http://proj.mgorny.alt.pl/misc/#smart-live-rebuild"
SRC_URI="http://dl.mgorny.alt.pl/misc/${P}.py.bz2"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

src_compile() {
	python_convert_shebangs 2 ${P}.py
}

src_install() {
	newbin ${P}.py ${PN} || die
}
