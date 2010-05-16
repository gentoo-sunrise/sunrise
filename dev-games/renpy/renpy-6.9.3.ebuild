# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="2"
PYTHON_DEPEND="2:2.5"

inherit eutils games python versionator

DESCRIPTION="Visual novel engine written in python"
HOMEPAGE="http://www.renpy.org"
SRC_URI="http://www.renpy.org/dl/${PV}/${P}-source.tar.bz2"

LICENSE="MIT"
SLOT="$(get_version_component_range 1-2)"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND="dev-python/pygame[X]
	>=dev-games/renpy-modules-${PV}"

pkg_setup() {
	games_pkg_setup
}

src_prepare() {
	find renpy -iname '*.pyo' -delete
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
	dodoc CHANGELOG.txt || die "dodoc failed"

	prepgamesdirs
}

pkg_postinst() {
	python_mod_optimize "${GAMES_DATADIR}/${P}"
	games_pkg_postinst
}

pkg_postrm() {
	python_mod_cleanup "${GAMES_DATADIR}/${P}"
}
