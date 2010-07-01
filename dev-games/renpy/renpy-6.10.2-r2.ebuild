# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="2"
PYTHON_DEPEND="2:2.5"

inherit confutils eutils games python versionator

DESCRIPTION="Visual novel engine written in python"
HOMEPAGE="http://www.renpy.org"
SRC_URI="http://www.renpy.org/dl/${PV}/${P}-source.tar.bz2"

LICENSE="MIT"
SLOT="$(get_version_component_range 1-2)"
KEYWORDS="~amd64 ~x86"
IUSE="development doc examples"

RDEPEND="dev-python/pygame[X]
	>=dev-games/renpy-modules-${PV}"

pkg_setup() {
	confutils_use_depend_any examples development
	games_pkg_setup
}

src_prepare() {
	# Fix path to app-editors/jedit
	epatch "${FILESDIR}"/${PN}-jedit-path.patch

	find renpy -name '*.pyo' -exec rm -f {} + || die
}

src_install() {
	insinto "${GAMES_DATADIR}"/${P}
	exeinto "${GAMES_DATADIR}"/${P}

	doexe renpy.py || die "doexe failed"

	dodir "${GAMES_BINDIR}" || die "dodir failed"
	P_SLOT=${PN}-${SLOT}
	cat <<-EOF > "${D}"/"${GAMES_BINDIR}"/${P_SLOT} || die "Failed to create ${P_SLOT}"
		#!/bin/sh
		RENPY_BASE="${GAMES_DATADIR}"/${P} "${GAMES_DATADIR}"/${P}/renpy.py "\${@}"
	EOF

	doins -r common renpy || die "doins failed"

	if use development; then
		doins -r launcher template || die "doins failed"

		newicon launcher/logo32.png ${P}.png || die "newicon failed"
		make_desktop_entry ${P_SLOT} "Ren'Py ${PV}" ${P} Game "${GAMES_DATADIR}"/${P} || die "make_desktop_entry failed"
	fi

	if use examples; then
		doins -r the_question || die "doins failed"
		doins -r tutorial || die "doins failed"
	fi

	dodoc CHANGELOG.txt || die "dodoc failed"

	if use doc; then
		dohtml -r doc || die "dohtml failed"
	fi

	prepgamesdirs
}

pkg_postinst() {
	python_mod_optimize "${GAMES_DATADIR}/${P}"
	if use development; then
		elog "You need to emerge app-editors/jedit to easily use renpy development interface."
	fi
	games_pkg_postinst
}

pkg_postrm() {
	python_mod_cleanup "${GAMES_DATADIR}/${P}"
}
