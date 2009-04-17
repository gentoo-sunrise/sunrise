# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="2"
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
	x11-libs/vte[python]"
DEPEND="${RDEPEND}
	sys-devel/gettext
	dev-util/intltool
	dev-util/pkgconfig"

src_unpack() {
	git_src_unpack
	intltoolize -c -f --automake || die "intltoolize failed"
	gnome2_omf_fix
	AT_M4DIR="m4" eautoreconf
}
