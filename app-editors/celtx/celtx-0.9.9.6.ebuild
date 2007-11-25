# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit eutils

SLOT="0"
LICENSE="CePL"
KEYWORDS="~amd64 ~x86"

DESCRIPTION="An open source screenplay editor"
SRC_URI="http://www.celtx.com/download/Celtx.tar.gz"
HOMEPAGE="http://www.celtx.com"
IUSE=""
DEPEND=""

src_install() {
	mkdir -p ${D}/opt/celtx
	cp -R ${WORKDIR}/celtx ${D}/opt/ || die
}
