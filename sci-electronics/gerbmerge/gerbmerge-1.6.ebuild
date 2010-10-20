# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=2
PYTHON_DEPEND="2"
SUPPORT_PYTHON_ABIS="1"
RESTRICT_PYTHON_ABIS="3.*"

inherit distutils eutils

DESCRIPTION="A program for combining (panelizing) Gerber/Excellon files"
HOMEPAGE="http://claymore.engineer.gvsu.edu/~steriana/Python/gerbmerge/"
SRC_URI="http://claymore.engineer.gvsu.edu/~steriana/Software/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="doc examples"

DEPEND="dev-python/simpleparse"
RDEPEND="${DEPEND}"

src_prepare() {
	epatch "${FILESDIR}/${P}-no-fixperms.patch"
	distutils_src_prepare
}

src_install() {
	# The provided build script mashes all the examples and documentation into
	# /usr/lib/pythonX.Y/gerbmerge. Do it manually to put all the files in the
	# right places.

	# First the per-ABI stuff into site-packages.
	install_perabi() {
		insinto "$(python_get_sitedir)"
		doins -r "build-${PYTHON_ABI}/lib/${PN}" || die "Failed to install libs"
	}
	python_execute_function install_perabi

	# Next the wrapper script.
	dobin misc/gerbmerge || die "Failed to install wrapper script"

	# Finally the documentation and examples.
	dodoc PKG-INFO README || die "Failed to install documentation"
	if use doc; then
		dohtml -A cfg -A def doc/* || die "Failed to install documentation"
	fi
	if use examples; then
		docinto testdata
		dodoc testdata/* || die "Failed to install examples"
	fi
}
