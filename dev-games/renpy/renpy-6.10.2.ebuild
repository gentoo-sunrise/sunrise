# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="2"

inherit confutils distutils eutils games

DESCRIPTION="Visual novel engine written in python"
HOMEPAGE="http://www.renpy.org"
SRC_URI="http://www.renpy.org/dl/${PV}/${P}-source.tar.bz2"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~x86"
IUSE="development doc examples"

DEPEND=">=dev-lang/python-2.5
	<dev-lang/python-3
	media-libs/libpng
	media-libs/libsdl
	media-libs/freetype:2
	media-video/ffmpeg
	dev-libs/fribidi
	dev-python/pygame[X]"
RDEPEND="${DEPEND}"

pkg_setup() {
	confutils_use_depend_any examples development
}

src_prepare() {
	# Fix path to app-editors/jedit
	epatch "${FILESDIR}"/${PN}-jedit-path.patch

	find renpy -iname '*.pyo' -delete
	distutils_src_prepare
}

src_compile() {
	cd module || die "Cannot cd to 'module' directory"
	# RENPY_DEPS_INSTALL is a double-colon separated list of directories that
	# contains all core renpy dependencies. This is usually /usr.
	RENPY_DEPS_INSTALL="${ROOT}"/usr distutils_src_compile
}

src_install() {
	insinto "${GAMES_DATADIR}"/${PN}
	exeinto "${GAMES_DATADIR}"/${PN}

	doexe renpy.py || die "doexe failed"

	dodir "${GAMES_BINDIR}" || die "dodir failed"
	cat <<-EOF > "${D}"/"${GAMES_BINDIR}"/${PN} || die "Failed to create ${PN}"
		#!/bin/sh
		RENPY_BASE="${GAMES_DATADIR}"/${PN} "${GAMES_DATADIR}"/${PN}/renpy.py "\${@}"
	EOF

	doins -r common renpy || die "doins failed"

	if use development; then
		doins -r launcher template || die "doins failed"

		newicon launcher/logo32.png renpy.png || die "newicon failed"
		make_desktop_entry renpy "Ren'Py" renpy Game /usr/share/games/${PN} || die "make_desktop_entry failed"
	fi

	if use examples; then
		doins -r the_question || die "doins failed"
		doins -r tutorial || die "doins failed"
	fi

	dodoc CHANGELOG.txt || die "dodoc failed"

	if use doc; then
		dohtml -r doc || die "dohtml failed"
	fi

	cd module || die "Cannot cd to 'module' directory"
	RENPY_DEPS_INSTALL="${ROOT}"/usr distutils_src_install
	prepgamesdirs
}

pkg_postinst() {
	python_mod_optimize "${ROOT}"/usr/share/games/${PN}
	distutils_pkg_postinst
	if use development; then
		elog "You need to emerge app-editors/jedit to easily use renpy development interface."
	fi
}

pkg_postrm() {
	python_mod_cleanup "${ROOT}"/usr/share/games/${PN}
	distutils_pkg_postrm
}
