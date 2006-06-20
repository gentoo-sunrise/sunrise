# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit distutils eutils

MY_P=${PN/icepy/IcePy}-${PV}

DESCRIPTION="ICE middleware Python bindings"
HOMEPAGE="http://www.zeroc.com/index.html"
SRC_URI="http://www.zeroc.com/download/Ice/3.0/${MY_P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86"
IUSE=""

DEPEND=">=dev-lang/python-2.4
	=dev-cpp/ice-${PV}*"
RDEPEND=${DEPEND}

S=${WORKDIR}/${MY_P}

src_unpack() {
	unpack ${A}
	cd "${S}"

	# This patch makes sure that only slice2py gets called during make
	epatch "${FILESDIR}"/${P}-skip_compilation.patch
	# ... and removes the dependency on ICE_HOME global env var
	epatch "${FILESDIR}"/${P}-Make.rules.patch

	# The rest will be handled by our setup-script
	cp "${FILESDIR}"/${P}-setup.py setup.py

	# This step calls slice2py and generates all the python files
	emake || die "Failed to create the .py-Files"
}

