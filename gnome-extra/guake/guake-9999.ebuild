# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="1"
inherit gnome2 git

DESCRIPTION="Guake is a drop-down terminal for Gnome"
HOMEPAGE="http://guake-terminal.org/"
EGIT_REPO_URI="git://repos.guake-terminal.org/guake"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND=">=dev-lang/python-2.4
		x11-libs/gtk+:2
		gnome-base/gconf:2
		x11-libs/libX11
		dev-python/notify-python
		x11-libs/vte"

src_unpack() {
	git_src_unpack
	pwd
	sh autogen.sh
	gnome2_omf_fix
	elibtoolize
}
