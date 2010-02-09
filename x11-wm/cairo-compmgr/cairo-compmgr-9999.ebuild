# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="2"

inherit autotools gnome2 git

EGIT_REPO_URI="git://git.tuxfamily.org/gitroot/ccm/cairocompmgr.git"

DESCRIPTION="A versatile and extensible compositing manager which uses cairo for rendering"
HOMEPAGE="http://cairo-compmgr.tuxfamily.org/"
SRC_URI=""

LICENSE="GPL-2"
SLOT="0"
KEYWORDS=""
IUSE=""

RDEPEND="x11-libs/gtk+:2
	x11-libs/cairo
	x11-libs/pixman"
DEPEND="${RDEPEND}
	>=x11-proto/glproto-1.4.9"

G2CONF="--disable-glitz --disable-glitz-tfp --enable-shave"

EGIT_PATCHES=( "${FILESDIR}/${P}-glitz-tfp-undef.patch" )
AT_M4DIR="."
EGIT_BOOTSTRAP="eautoreconf"
