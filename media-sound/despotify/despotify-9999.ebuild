# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit base subversion

ESVN_REPO_URI="https://${PN}.svn.sourceforge.net/svnroot/${PN}/src"

DESCRIPTION="An open source Spotify client and library"
HOMEPAGE="http://despotify.se/"

LICENSE="BSD-2"
SLOT="0"
KEYWORDS=""
IUSE=""

DEPEND="sys-libs/zlib
	dev-libs/openssl
	media-libs/libvorbis
	media-libs/libao"
RDEPEND="${DEPEND}"

DOCS=(README TODO)
