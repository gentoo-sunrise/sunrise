# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="1"

inherit games

DESCRIPTION="PlayOnLinux is a piece of sofware which allow you to install and use easily numerous games and softwares designed to run with Windows(tm)."
HOMEPAGE="http://www.playonlinux.com/"
SRC_URI="http://www.playonlinux.com/script_files/PlayOnLinux/${PV}/PlayOnLinux_${PV}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~x86"
IUSE=""

DEPEND="dev-lang/python
		x11-libs/wxGTK
		x11-libs/gtk+
		www-client/lynx
		app-arch/unzip
		app-arch/cabextract
		sys-devel/binutils
		x11-terms/xterm
		app-emulation/wine
		media-gfx/imagemagick
		app-arch/lzma-utils"
RDEPEND="${DEPEND}
		dev-python/wxpython"

S="${WORKDIR}/playonlinux"

src_unpack() {
	unpack ${A}
	cd "${S}"
}

src_install() {
	cd "${S}"
	./playonlinux || die "install failed"
	einfo "Fix for License miss spelling"
	addpredict "${S}"
	addread "${S}"
	mv LICENCE LICENSE

	dodoc CHANGELOG LICENSE || die "doc failed"
}

