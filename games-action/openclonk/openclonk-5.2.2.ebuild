# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=3

inherit autotools eutils flag-o-matic games

MY_P=${PN}-release-${PV}-src

DESCRIPTION="A free multiplayer action game where you control clonks"
HOMEPAGE="http://openclonk.org/"
SRC_URI="http://hg.${PN}.org/${PN}/archive/${MY_P}.tar.gz
	http://${PN}.org/homepage/icon.png -> ${PN}.png"

LICENSE="BSD CLONK-source CLONK-trademark LGPL-2.1 POSTGRESQL"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="+audio doc mp3 openal"

RDEPEND="
	media-libs/freetype:2
	media-libs/glew
	media-libs/libpng:0
	media-libs/libsdl[X,audio?,opengl,video]
	sys-libs/zlib
	virtual/jpeg
	virtual/opengl
	x11-libs/cairo
	x11-libs/gdk-pixbuf
	x11-libs/gtk+:3
	x11-libs/libXpm
	x11-libs/libXrandr
	x11-libs/libXxf86vm
	x11-libs/libX11
	audio? (
		media-libs/sdl-mixer[mp3?]
		openal? (
			media-libs/libvorbis
			media-libs/openal
		)
	)"
DEPEND="${RDEPEND}
	>=dev-libs/boost-1.40
	dev-util/pkgconfig
	doc? (
		=dev-lang/python-2*
		dev-libs/libxml2[python]
		sys-devel/gettext
	)"

S=${WORKDIR}/${MY_P}

src_prepare() {
	# remove license files
	sed \
		-e '/dist_doc_DATA/s#planet/COPYING ##;s:licenses/LGPL.txt ::' \
		-i Makefile.am || die

	# force python2 for doc-generation
	if use doc ; then
		sed \
			-e 's/python/python2/g' \
			-i docs/Makefile || die
	fi

	eautoreconf
}

src_configure() {
	# QA
	append-flags -fno-strict-aliasing

	local myconf
	if use audio ; then
		myconf="$(use_enable audio sound)"
		use mp3 && myconf="${myconf} $(use_enable mp3)"
		use openal && myconf="${myconf} $(use_with openal)"
	fi

	egamesconf \
		--with-automatic-update=no \
		--with-gtk=3.0 \
		${myconf}
}

src_compile() {
	emake || die

	if use doc ; then
		emake -C docs || die
	fi
}

src_install() {
	emake DESTDIR="${D}" install || die
	doicon "${DISTDIR}"/${PN}.png || die
	newgamesbin "${FILESDIR}"/${PN}-wrapper-script.sh ${PN} || die
	make_desktop_entry ${PN} ${PN}

	if use doc ; then
		dohtml -r docs/online/* || die
	fi

	prepgamesdirs
}

pkg_postinst() {
	games_pkg_postinst
	einfo "Run the game via the wrapper \"${GAMES_BINDIR}/${PN}\"."
}
