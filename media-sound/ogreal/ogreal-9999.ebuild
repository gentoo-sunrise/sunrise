# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit subversion autotools

ESVN_REPO_URI="https://ogreal.svn.sourceforge.net/svnroot/ogreal/trunk/OgreAL-Eihort"

DESCRIPTION="an OpenAL wrapper for Ogre"
HOMEPAGE="http://sourceforge.net/projects/${PN}"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

DEPEND=">=dev-games/ogre-1.4
		>=media-libs/openal-0.0.8
		media-libs/libvorbis
		dev-games/ois"

src_unpack() {
	subversion_src_unpack
	eautoreconf
}

src_install() {
	emake DESTDIR="${D}" install || die "emake install failed"
}
