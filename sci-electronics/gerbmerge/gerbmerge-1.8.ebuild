# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=3
PYTHON_DEPEND="2"
SUPPORT_PYTHON_ABIS="1"
RESTRICT_PYTHON_ABIS="3.*"

inherit distutils eutils

DESCRIPTION="A program for combining (panelizing) Gerber/Excellon files"
HOMEPAGE="http://ruggedcircuits.com/gerbmerge/"
SRC_URI="http://ruggedcircuits.com/gerbmerge/${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="doc examples"

DEPEND="dev-python/simpleparse"
RDEPEND="${DEPEND}"

src_prepare() {
	# This package has a very, very messy distutils situation. This patch rips
	# out most of setup.py and replaces it with something simpler.
	epatch "${FILESDIR}/${P}-fix-setup.patch"

	# This adds a "main" function to the toplevel module in the gerbmerge Python
	# package, which allows the function to be called from a launcher script
	# (otherwise it would expect to be invoked directly while having been
	# installed in site-packages).
	epatch "${FILESDIR}/${P}-fix-main.patch"

	# Throw a very simple launcher script into the mix.
	cp "${FILESDIR}/${P}-launcher.py" "${S}/misc/gerbmerge" || die

	distutils_src_prepare
}

src_install() {
	distutils_src_install
	if use doc; then
		dohtml -A cfg -A def doc/* || die "Failed to install documentation"
	fi
	if use examples; then
		docinto testdata
		dodoc testdata/* || die "Failed to install examples"
	fi
}
