# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit eutils subversion autotools

ESVN_REPO_URI="https://libwiimote.svn.sourceforge.net/svnroot/libwiimote/branches/ant"
ESVN_PROJECT="libwiimote"

DESCRIPTION="Library to connect to the Nintendo Wii remote (svn snapshot)"
HOMEPAGE="http://libwiimote.sourceforge.net"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="examples force tilt"

RDEPEND="net-wireless/bluez-libs"
DEPEND="${RDEPEND}
		dev-util/pkgconfig"

src_unpack() {
	subversion_src_unpack
	epatch "${FILESDIR}/${P}-ldflags.patch"
	eautoreconf
}

src_compile() {
	econf \
		$(use_enable force) \
		$(use_enable tilt)

	emake || die "emake failed"
}

src_install() {
	emake DESTDIR="${D}" install || die "emake install failed"
	dodoc AUTHORS NEWS README TODO

	if use examples; then
		docinto examples
		dodoc test/test?.c
	fi
}
