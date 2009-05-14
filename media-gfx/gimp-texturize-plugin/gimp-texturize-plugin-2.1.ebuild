# Copyright 2007-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

DESCRIPTION="GIMP plugin to generate large textures from a small sample"
HOMEPAGE="http://gimp-texturize.sourceforge.net/"
SRC_URI="mirror://sourceforge/gimp-texturize/texturize-${PV}_src.tgz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND=">=media-gfx/gimp-2.4"
DEPEND="${RDEPEND}"

S="$WORKDIR/gimp-texturize"

src_install() {
	emake DESTDIR="${D}" install || die "unable to install"

	dodoc AUTHORS bugs ChangeLog NEWS README todo || die "unable to install documentation"
}
