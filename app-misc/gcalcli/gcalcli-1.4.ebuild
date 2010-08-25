# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="2"

PYTHON_DEPEND="2"

inherit eutils python

DESCRIPTION="Python client for accessing Google Calendar from the command line"
HOMEPAGE="http://code.google.com/p/gcalcli/"
SRC_URI="http://gcalcli.googlecode.com/files/${P}.tgz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND=""
RDEPEND="dev-python/elementtree
	dev-python/gdata
	dev-python/python-dateutil"

pkg_setup() {
	python_set_active_version 2
}

src_prepare() {
	epatch "${FILESDIR}"/${P}-feedfix.patch
}

src_install() {
	dobin gcalcli || die
}
