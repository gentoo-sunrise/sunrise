# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=3

inherit eutils gnome2-utils games

MY_PN=${PN%-bin}

DESCRIPTION="A Libre/Free RTS engine supporting early Westwood games like Command & Conquer and Red Alert"
HOMEPAGE="http://open-ra.org/"
SRC_URI="http://${MY_PN}.res0l.net/assets/downloads/linux/arch/${MY_PN}-release.${PV}-1-any.pkg.tar.xz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="cg"

RDEPEND="dev-dotnet/libgdiplus
	dev-lang/mono
	!games-strategy/openra
	media-libs/freetype:2[X]
	media-libs/libsdl[X,audio,video]
	media-libs/openal
	virtual/jpeg
	virtual/opengl
	cg? ( media-gfx/nvidia-cg-toolkit )"

src_prepare() {
	# register game-version
	sed \
		-e "/Version/s/{DEV_VERSION}/release-${PN}/" \
		-i usr/share/${MY_PN}/mods/{ra,cnc}/mod.yaml || die
}

src_install() {
	# docs
	dodoc usr/share/${MY_PN}/{CHANGELOG,HACKING} || die
	rm usr/share/${MY_PN}/{CHANGELOG,HACKING} || die

	# data files
	rm usr/share/${MY_PN}/COPYING || die
	insinto "${GAMES_DATADIR}"
	doins -r usr/share/${MY_PN} || die

	# icons
	insinto /usr/share/icons
	doins -r usr/share/icons/* || die

	# wrappers scripts
	games_make_wrapper ${MY_PN} "mono ./OpenRA.Game.exe" \
		"${GAMES_DATADIR}/${MY_PN}"
	games_make_wrapper ${MY_PN}-editor "mono ./OpenRA.Editor.exe" \
		"${GAMES_DATADIR}/${MY_PN}"

	# .desktop files
	domenu "${FILESDIR}"/${MY_PN}-{cnc,editor,ra}.desktop || die

	if use cg ; then
		# set default renderer to cg
		sed \
			-e '/Renderer/s/Gl/Cg/' \
			-i "${D}"/usr/share/applications/${MY_PN}-{cnc,ra}.desktop \
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
