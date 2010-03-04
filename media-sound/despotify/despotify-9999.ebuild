# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit subversion

ESVN_REPO_URI="https://${PN}.svn.sourceforge.net/svnroot/${PN}"

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

src_install() {
	cd src
	emake DESTDIR="${D}" install || die "install failed"
	dodoc README TODO || die "dodoc failed"
}
