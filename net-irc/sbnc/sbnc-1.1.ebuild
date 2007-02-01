# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

DESCRIPTION="Modular IRC proxy written in C++ and multi-user capable"
HOMEPAGE="http://sbnc.sourceforge.net/"
SRC_URI="http://mirror.shroudbox.net/sbnc-current.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86"
IUSE="ssl"

DEPEND="ssl? ( dev-libs/openssl )"
RDEPEND="${DEPEND}
	dev-lang/tcl"

src_compile() {
	local myconf
	if use ssl ; then
		myconf="--enable-ssl=yes"
	else
		myconf="--disable-ssl"
	fi

	econf ${myconf} || die "econf failed"
	emake || die "emake failed"
}

src_install() {
	dodir /opt
	emake HOME="${D}opt" install || die "emake install failed"
}
