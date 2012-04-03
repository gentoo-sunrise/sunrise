# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=3

EGIT_REPO_URI="git://github.com/OpenRA/OpenRA.git"
EGIT_COMMIT="release-${PV}"

inherit eutils mono gnome2-utils games git-2

DESCRIPTION="A Libre/Free RTS engine supporting early Westwood games like Command & Conquer and Red Alert"
HOMEPAGE="http://open-ra.org/"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="cg"

DEPEND="dev-dotnet/libgdiplus
	dev-lang/mono
	!games-strategy/openra-bin
	media-libs/freetype:2[X]
	media-libs/libsdl[X,audio,video]
	media-libs/openal
	virtual/jpeg
	virtual/opengl
	cg? ( >=media-gfx/nvidia-cg-toolkit-2.1.0017 )"
RDEPEND="${DEPEND}"

src_prepare() {
	# fix a few paths and install-rules
	epatch "${FILESDIR}"/${P}-makefile.patch

	# register game-version
	sed \
		-e "/Version/s/{DEV_VERSION}/${EGIT_COMMIT}/" \
		-i mods/{ra,cnc}/mod.yaml || die
}

src_install() {
	# no configure script
	emake \
		prefix="${GAMES_PREFIX}" \
		datarootdir="${GAMES_DATADIR_BASE}" \
		datadir="${GAMES_DATADIR}" \
		bindir="${GAMES_BINDIR}" \
		DESTDIR="${D}" \
		install || die

	# icons
	insinto /usr/share/icons/
	doins -r packaging/linux/hicolor || die

	# .desktop files
	domenu "${FILESDIR}"/${PN}-{cnc,editor,ra}.desktop || die

	#docs
	dodoc README HACKING CHANGELOG || die

	if use cg ; then
		# set default renderer to cg
		sed \
			-e '/Renderer/s/Gl/Cg/' \
			-i "${D}"/usr/share/applications/${PN}-{cnc,ra}.desktop \
			|| die "setting default renderer in desktop file failed"
	fi

	# file permissions
	prepgamesdirs
}

pkg_preinst() {
	games_pkg_preinst
	gnome2_icon_savelist
}

pkg_postinst() {
	games_pkg_postinst
	gnome2_icon_cache_update

	if use cg ; then
		elog "If you have problems starting the game consider switching"
		elog "back to Graphics.Renderer=Gl in openra*.desktop or pass that"
		elog "argument on the command line:"
		elog "openra Game.Mods=... Graphics.Renderer=Gl"
	fi
}

pkg_postrm() {
	gnome2_icon_cache_update
}
