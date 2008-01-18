# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit distutils eutils

DESCRIPTION="Python library for symbolic mathematics."
HOMEPAGE="http://code.google.com/p/sympy/"
SRC_URI="http://sympy.googlecode.com/files/${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~x86"
IUSE="gtk xslt"

DEPEND=">=virtual/python-2.4
	>=dev-python/ipython-0.7.2
	gtk? ( x11-libs/gtkmathview )
	xslt? ( dev-libs/libxslt )"
RDEPEND="${DEPEND}"

pkg_setup() {
	if use xslt && ! built_with_use "dev-libs/libxslt" python ; then
		eerror "dev-libs/libxslt has to be compiled with 'python'"
		eerror "USE-flag enabled."
		die "Needed USE-flag for dev-libs/libxslt not found."
	fi
}
