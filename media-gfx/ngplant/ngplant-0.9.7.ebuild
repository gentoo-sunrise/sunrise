# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="2"

inherit eutils multilib toolchain-funcs

DESCRIPTION="plant modeling software package"
HOMEPAGE="http://ngplant.sourceforge.net"
SRC_URI="mirror://sourceforge/${PN}/${PN}/${PV}/${P}.tar.gz"

SLOT="0"
KEYWORDS="~amd64 ~x86"
LICENSE="GPL-3 BSD"
IUSE="doc examples"

RDEPEND="
	media-libs/glew
	virtual/glut
	x11-libs/wxGTK:2.8
	dev-lang/lua"
DEPEND="${RDEPEND}
	dev-util/scons
	dev-util/pkgconfig
	dev-libs/libxslt"

src_prepare() {
	epatch "${FILESDIR}"/${PV}-gcc4.3.patch
	rm -rf extern

	sed \
		-e "s:CC_OPT_FLAGS=.*$:CC_OPT_FLAGS=\'${CFLAGS}\':g" \
		-i SConstruct \
		|| die "failed to correct CFLAGS"

	sed \
		-e "s:LINKFLAGS='-s':LINKFLAGS=\'${LDFLAGS}\':g" \
		-i ngpview/SConscript ${PN}/SConscript devtools/SConscript ngpshot/SConscript \
		|| die "failed to correct LDFLAGS"
}

src_compile() {
	scons \
		CC=$(tc-getCC) \
		CXX=$(tc-getCXX)\
		LINKFLAGS="${LDFLAGS}" \
		GLEW_INC="/usr/include/" \
		GLEW_LIBPATH="/usr/$(get_libdir)/" \
		GLEW_LIBS="GLEW GL GLU glut" \
		LUA_INC="/usr/include/" \
		LUA_LIBPATH="/usr/$(get_libdir)/" \
		LUA_LIBS="$(pkg-config lua --libs)" \
		|| die
}

src_install() {
	dobin ${PN}/${PN} ngpview/ngpview devtools/ngpbench ngpshot/ngpshot scripts/ngp2obj.py || die
	dolib.a ngpcore/libngpcore.a ngput/libngput.a || die
	insinto /usr/share/${PN}/
	doins -r plugins shaders || die

	dodoc ReleaseNotes || die

	if use examples; then
		doins -r samples || die
	fi

	if use doc; then
		dohtml -r docapi || die
	fi
}
