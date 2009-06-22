# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

MY_P="docbook2odf-${PV}"
DESCRIPTION="XSL Stylesheets for Docbook2odf"
HOMEPAGE="http://open.comsultia.com/docbook2odf/"
SRC_URI="http://open.comsultia.com/docbook2odf/dwn/${MY_P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86"
IUSE=""

DEPEND=""
RDEPEND=""

S=${WORKDIR}/${MY_P}

src_install() {
	insinto /usr/share/${PN}
	doins -r xsl \
		|| die "Could not copy stylesheet files and directories."
}
