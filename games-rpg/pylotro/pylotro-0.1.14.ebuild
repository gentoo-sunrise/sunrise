# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="3"

PYTHON_DEPEND="2:2.5"
SUPPORT_PYTHON_ABIS="1"
RESTRICT_PYTHON_ABIS="2.4 3.*"

inherit distutils games

DESCRIPTION="Lord of the Rings Online and Dungeons & Dragons Online Launcher"
HOMEPAGE="http://www.lotrolinux.com/"
SRC_URI="http://www.lotrolinux.com/PyLotRO-${PV}.tar.bz2"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND="dev-python/PyQt4
	dev-python/4suite"
RDEPEND="${DEPEND}"

S="${WORKDIR}"

PYTHON_MODNAME=PyLotROLauncher
PYTHON_VERSIONED_SCRIPTS="${GAMES_BINDIR}/${PN}"

src_compile() {
	distutils_src_compile
}

src_install() {
	distutils_src_install \
		--install-scripts "${GAMES_BINDIR}" \
		--install-data "${GAMES_DATADIR}"
	prepgamesdirs
}

pkg_postinst() {
	distutils_pkg_postinst
	games_pkg_postinst

	elog
	elog "You will need a proper wine or crossover-game installation to launch"
	elog "the game. You can find more information on how to run these games in"
	elog "GNU/Linux by visiting:"
	elog "http://appdb.winehq.org/objectManager.php?sClass=application&iId=4891"
	elog "or http://www.codeweavers.com/compatibility/browse/name/?app_id=4029"
}

pkg_postrm() {
	distutils_pkg_postrm
}
