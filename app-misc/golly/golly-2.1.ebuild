# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=2
PYTHON_DEPEND=2
WX_GTK_VER=2.8

inherit eutils python wxwidgets

MY_P=${P}-src
DESCRIPTION="A simulator for Conway's Game of Life and other cellular automata"
HOMEPAGE="http://golly.sourceforge.net/"
SRC_URI="mirror://sourceforge/${PN}/${MY_P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND="dev-lang/perl[ithreads]
	x11-libs/wxGTK:2.8[X,tiff]"
RDEPEND="${DEPEND}"

S=${WORKDIR}/${MY_P}

pkg_setup() {
	python_set_active_version 2
}

src_prepare() {
	# Fix linker flags to work with Perl 5.10.1 (fixed in CVS)
	epatch "${FILESDIR}"/${P}-perl-ldopts.patch

	# Fix Python symbol names on AMD64 (fixed in CVS)
	epatch "${FILESDIR}"/${P}-python-amd64.patch

	# Fix installing data files into a different directory than binaries:
	epatch "${FILESDIR}"/${PN}-separate-data-directory.patch

	# Get rid of .DS_Store and other stuff that should not be installed:
	find . -name '.*' -delete || die
	find Scripts/Python -name '*.pyc' -delete || die

	# Fix Python library path:
	sed -i -e "s|libpython2.5.so|$(python_get_library)|" wxprefs.cpp || die

	# Insert user-specified compiler flags into Makefile:
	sed -i -e "/^CXXFLAGS = /s/-O5/${CXXFLAGS}/" \
		-e "s/^LDFLAGS = /&${LDFLAGS} /" makefile-gtk || die
}

src_compile() {
	emake -f makefile-gtk || die
}

src_install() {
	insinto /usr/bin
	dobin golly bgolly RuleTableToTree || die

	insinto /usr/share/${PN}
	doins -r Help Patterns Scripts Rules || die

	dodoc README || die
}
