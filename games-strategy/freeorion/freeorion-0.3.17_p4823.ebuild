# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=3

PYTHON_DEPEND="2"

inherit cmake-utils python subversion games

DESCRIPTION="A free and open source clone of Master Of Orion"
HOMEPAGE="http://www.freeorion.org"
ESVN_REPO_URI="https://${PN}.svn.sourceforge.net/svnroot/${PN}/trunk"
ESVN_PROJECT="${PN}"
ESVN_REVISION="${PV#*_p}"

LICENSE="GPL-2 CCPL-Attribution-ShareAlike-3.0"
SLOT="0"
KEYWORDS="" # dependency gigi unkeyworded and potentially broken
IUSE="cg"

RDEPEND="
	dev-games/gigi[ogre,ois]
	dev-games/ogre[cg?,opengl]
	>=dev-libs/boost-1.47[python]
	media-libs/freealut
	media-libs/libogg
	media-libs/libsdl[X,opengl,video]
	media-libs/libvorbis
	media-libs/openal
	sci-physics/bullet
	sys-libs/zlib
	virtual/opengl"
DEPEND="${RDEPEND}
	dev-util/pkgconfig"

CMAKE_USE_DIR="${S}"/FreeOrion
CMAKE_VERBOSE="1"

src_unpack() {
	subversion_src_unpack
}

src_prepare() {
	# set OGRE plugin-dir
	sed \
		-e "s:PluginFolder=.:PluginFolder=$(pkg-config --variable=plugindir OGRE):" \
		-i "${CMAKE_USE_DIR}"/ogre_plugins.cfg || die

	# set revision number
	sed \
		-e "/svn_revision_number/s:???:${ESVN_REVISION}:" \
		-i "${CMAKE_USE_DIR}"/CMakeLists.txt || die

	if use cg ; then
		# add cg ogre plugin to config
		echo "Plugin=Plugin_CgProgramManager" \
			>> "${CMAKE_USE_DIR}"/ogre_plugins.cfg || die
	fi
}

src_configure() {
	local mycmakeargs=(
		-DRELEASE_COMPILE_FLAGS=""
		)

	cmake-utils_src_configure
}

src_compile() {
	cmake-utils_src_compile
}

src_install() {
	# data files
	rm "${CMAKE_USE_DIR}"/default/COPYING || die
	insinto "${GAMES_DATADIR}"/${PN}
	doins -r "${CMAKE_USE_DIR}"/default || die

	# bin
	dogamesbin "${CMAKE_BUILD_DIR}"/${PN}{ca,d} || die
	newgamesbin "${CMAKE_BUILD_DIR}"/${PN} ${PN}.bin || die
	games_make_wrapper ${PN} \
		"${GAMES_BINDIR}/${PN}.bin --resource-dir ./default" \
		"${GAMES_DATADIR}/${PN}"

	# config
	insinto "${GAMES_SYSCONFDIR}"/${PN}
	doins "${CMAKE_USE_DIR}"/{OISInput,ogre_plugins}.cfg || die
	# game uses relative paths
	dosym "${GAMES_SYSCONFDIR}"/${PN}/ogre_plugins.cfg \
		"${GAMES_DATADIR}"/${PN}/ogre_plugins.cfg || die
	dosym "${GAMES_SYSCONFDIR}"/${PN}/OISInput.cfg \
		"${GAMES_DATADIR}"/${PN}/OISInput.cfg || die

	# other
	dodoc "${CMAKE_USE_DIR}"/changelog.txt || die
	newicon "${CMAKE_USE_DIR}"/default/data/art/icons/FO_Icon_32x32.png \
		${PN}.png || die
	make_desktop_entry ${PN} ${PN} ${PN}

	# permissions
	prepgamesdirs
}
