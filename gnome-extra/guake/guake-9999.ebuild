# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit git gnome2 autotools

DESCRIPTION="Guake is a drop-down terminal for Gnome"
HOMEPAGE="http://guake-terminal.org/"
EGIT_REPO_URI="git://repos.guake-terminal.org/guake"
SRC_URI=""

LICENSE="GPL-2"
SLOT="0"
KEYWORDS=""
IUSE=""

RDEPEND=">=dev-lang/python-2.4
	dev-python/gnome-python
	dev-python/notify-python
	x11-libs/vte"
DEPEND="${RDEPEND}
	sys-devel/gettext
	dev-util/intltool
	dev-util/pkgconfig"

pkg_setup() {
	if ! built_with_use x11-libs/vte python ; then
		eerror "You must rebuild x11-libs/vte with python USE flag."
		die
	fi
}

src_unpack() {
	git_src_unpack
	intltoolize -c -f --automake || die "intltoolize failed"
	gnome2_omf_fix
	AT_M4DIR="m4" eautoreconf
}
