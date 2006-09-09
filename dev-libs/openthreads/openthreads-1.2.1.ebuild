# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit eutils fixheadtails toolchain-funcs multilib

MY_PN="OpenThreads"
MY_PV="v1.2dev2-osg0.9.5"

DESCRIPTION="a minimal & complete Object-Oriented thread interface for C++"
HOMEPAGE="http://openthreads.sourceforge.net/"
SRC_URI="mirror://sourceforge/${PN}/${MY_PN}-${MY_PV}.tar.gz"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="~x86"
IUSE="doc examples"

DEPEND="app-arch/unzip
	doc? ( app-doc/doxygen )"
RDEPEND=""

S=${WORKDIR}/${MY_PN}

src_unpack() {
	unpack ${A}
	cd "${S}"
	epatch "${FILESDIR}"/${P}-build.patch

	ht_fix_all
}

src_compile() {
	emake CXX=$(tc-getCXX) || die "emake failed"

	if use doc; then
		cd docs
		doxygen doxyfile
	fi
}

src_install() {
	emake INST_LOCATION="${D}"/usr install || die "emake install failed"

	dosym /usr/$(get_libdir)/lib${MY_PN}.so{.${PV},}
	dosym /usr/$(get_libdir)/lib${MY_PN}.so.{${PV},${PV%%.*}}

	dodoc AUTHORS.txt ChangeLog README.txt TODO.txt

	use doc && dohtml docs/html/*

	if use examples ; then
		insinto /usr/share/doc/${PF}/examples
		doins -r examples_src/*
	fi
}
