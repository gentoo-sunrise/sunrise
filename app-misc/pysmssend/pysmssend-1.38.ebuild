# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

NEED_PYTHON=2.5

inherit distutils eutils multilib

DESCRIPTION="Python Application for sending sms over multiple ISPs"
HOMEPAGE="http://pysmssend.sourceforge.net/"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="qt4"

RDEPEND=">dev-python/mechanize-0.1.7b
	qt4? ( dev-python/PyQt4 )"

src_install() {
	distutils_src_install
	if use qt4; then
		insinto /usr/share/${PN}/Icons
		doins   Icons/*
		doicon  Icons/pysmssend.png
		dobin   pysmssend pysmssendcmd || die "failed to create executables"
		make_desktop_entry pysmssend pySMSsend pysmssend.png "Applications;Network"
	else
		dobin   pysmssendcmd || die "failed to create executable"
		dosym   pysmssendcmd /usr/bin/pysmssend
	fi
	dodoc README AUTHORS TODO || die "dodoc failed"
}
