# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit eutils toolchain-funcs multilib fixheadtails

MY_PN="Producer"
OSG_V=1.2
DESCRIPTION="a cross-platform C++/OpenGL library that is focused on Camera control"
HOMEPAGE="http://openscenegraph.org/"
SRC_URI="http://www.openscenegraph.org/downloads/snapshots/OSG_OP_OT-${OSG_V}.zip"

LICENSE="OSGPL"
SLOT="0"
KEYWORDS="~x86"
IUSE="doc examples"

RDEPEND="virtual/opengl
	>=dev-libs/openthreads-1.4.3
	x11-libs/libXmu
	x11-libs/libX11"
DEPEND="${RDEPEND}
	app-arch/unzip
	doc? ( app-doc/doxygen )"

S="${WORKDIR}/OSG_OP_OT-${OSG_V}/${MY_PN}"

src_unpack() {
	unpack ${A}
	cd "${S}"
	epatch "${FILESDIR}"/${P}-build.patch

	ht_fix_all
}

src_compile() {
	emake CXX="$(tc-getCXX)" || die "emake failed"

	if use doc; then
		cd docs
		doxygen doxy.cfg
	fi
}

src_install() {
	emake INST_LOCATION="${D}"/usr install || die "emake install failed"

	dosym /usr/$(get_libdir)/lib${MY_PN}.so{.${PV},}
	dosym /usr/$(get_libdir)/lib${MY_PN}.so.{${PV},${PV%%.*}}

	insinto /usr/$(get_libdir)/pkgconfig
	doins Make/producer.pc

	dodoc README.txt

	use doc && dohtml -r doc/Doxygen/html/*

	if use examples; then
		insinto /usr/share/doc/${PF}/examples
		doins -r doc/Tutorial/SourceCode/*
	fi
}
