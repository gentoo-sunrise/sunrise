# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=4

PYTHON_DEPEND="2:2.6"
PYTHON_USE_WITH="sqlite"

inherit eutils python

DESCRIPTION="cli carddav client (for use with mutt etc.)"
HOMEPAGE="http://pycarddav.lostpackets.de"
SRC_URI="http://pycarddav.lostpackets.de/download/${P}.tar.gz"

LICENSE="BEER-WARE"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND="dev-python/lxml
		dev-python/pycurl
		dev-python/vobject
		|| ( dev-lang/python:2.7 dev-python/argparse )"
DEPEND="${RDEPEND}"

src_prepare(){
	python_convert_shebangs 2 pc_query pycardsyncer
}

src_install(){
	dodoc pycard.conf.sample README.rst
	dohtml README.html
	dobin pc_query pycardsyncer
}

pkg_postinst() {
	ewarn "Copy and edit the supplied pycard.conf.sample file"
	ewarn "(default location is ~/.pycard/pycard.conf)."
	ewarn "Beware that only you can access this file,"
	ewarn "if you have untrusted users on your machine,"
	ewarn "since the password is stored in cleartext."
}
