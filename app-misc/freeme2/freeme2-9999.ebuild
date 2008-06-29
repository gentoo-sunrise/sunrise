# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit subversion autotools

ESVN_REPO_URI="https://freeme2.svn.sourceforge.net/svnroot/freeme2"

DESCRIPTION="A utility that strips WM-DRM protection from wmv/asf/wma files as well as video/audio streams."
HOMEPAGE="http://sourceforge.net/projects/freeme2"
SRC_URI=""

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND="dev-libs/openssl"

S=${WORKDIR}/${PN}

src_unpack() {
	subversion_src_unpack
	eautoreconf
}

src_install() {
	emake DESTDIR="${D}" install || die "install failed"
	dodoc AUTHORS README
}
