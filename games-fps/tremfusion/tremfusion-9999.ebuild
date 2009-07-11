# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="2"

inherit eutils games mercurial toolchain-funcs

MENU_PK3_VER="0.99r3"
DESCRIPTION="An enhanced modification of the free software first person shooter Tremulous, based on ioquake3"
HOMEPAGE="https://www.tremfusion.net/"
EHG_REVISION="trem-compat"
EHG_REPO_URI="http://tremfusion.net/hg/${PN}"
EHG_PROJECT="${P}"
SRC_URI="http://www.tremfusion.net/downloads/z-tremfusion-menu-${MENU_PK3_VER}.pk3"
LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="dedicated openal +opengl tty +vorbis"

UIDEPEND="openal? ( media-libs/openal )
	media-libs/libsdl
	vorbis? ( media-libs/libogg media-libs/libvorbis )
	virtual/opengl
	sys-libs/ncurses"
RDEPEND="opengl? ( ${UIDEPEND} )
	!opengl? ( !dedicated? ( ${UIDEPEND} ) )
	media-libs/freetype
	net-misc/curl
	|| ( games-fps/tremulous games-fps/tremulous-bin )"
DEPEND="${RDEPEND}
	app-arch/unzip"

S=${WORKDIR}/${PN}

pkg_setup() {
	buildit() { use $1 && echo 1 || echo 0 ; }
}

src_prepare() {
	sed -i -e "s:release run-tremfusion.sh:run-tremfusion.sh:"  Makefile \
		|| die "sed failed"
}

src_compile() {
# adjusting arch to x86_64 if arch is amd64
	use amd64 && ARCH=x86_64

	emake \
		BUILD_CLIENT=$(buildit opengl) \
		BUILD_SERVER=$(buildit dedicated) \
		BUILD_CLIENT_TTY=$(buildit tty) \
		BUILD_GAME_SO=0 \
		BUILD_GAME_QVM=0 \
		CC="$(tc-getCC)" \
		DEFAULT_BASEDIR="${GAMES_DATADIR}/${PN}" \
		USE_CODEC_VORBIS=$(buildit vorbis) \
		USE_OPENAL=$(buildit openal) \
		USE_LOCAL_HEADERS=0 \
		USE_SCM_VERSION=1 \
		|| die "emake failed"
}

src_install() {
	emake \
		BUILD_CLIENT=$(buildit opengl) \
		BUILD_SERVER=$(buildit dedicated) \
		BUILD_CLIENT_TTY=$(buildit tty) \
		INSTALL_PREFIX=/usr BUILDROOT="${D}" BINDIR="${GAMES_BINDIR}" DATADIR="${GAMES_DATADIR}" \
		install || die "emake install failed"
	insinto "${GAMES_DATADIR}"/${PN}/${PN}/
	doins "${DISTDIR}"/z-tremfusion-menu-${MENU_PK3_VER}.pk3 || die "doins failed"
	dodoc README CC || die
	doicon "${WORKDIR}"/tremfusion/misc/tremfusion.png
	domenu misc/tremfusion.desktop
	prepgamesdirs
}

pkg_postinst() {
	games_pkg_postinst
	elog "This is Tremfusion live mercurial ebuild"
	elog "This package allows you to play on Tremulous servers"
}
