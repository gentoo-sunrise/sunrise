# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit eutils subversion autotools flag-o-matic

ESVN_REPO_URI="https://libwiimote.svn.sourceforge.net/svnroot/libwiimote/branches/ant"
ESVN_PROJECT="libwiimote"
ESVN_BOOTSTRAP="eautoreconf"

DESCRIPTION="Library to connect to the Nintendo Wii remote (svn snapshot)"
HOMEPAGE="http://libwiimote.sourceforge.net"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="examples tilt force"

RDEPEND="net-wireless/bluez-libs"
DEPEND="${RDEPEND}"


src_compile() {
	econf \
		$(use_enable force force) \
		$(use_enable tilt tilt) \
		|| die "Error: econf failed!"

	emake || die "emake failed"
}


src_install() {
	emake install DESTDIR="${D}" || die "emake install failed"
	dodoc AUTHORS NEWS README TODO

	if use examples; then
		elog "Installing test programs with sources in /usr/share/doc/${PF}/${DOCDESTTREE}"
		dodir /usr/share/doc/${PF}/${DOCDESTTREE}
		cp "${S}/test/test? ${D}usr/share/doc/${PF}/${DOCDESTTREE}"
		dodoc "${S}/test/test?.c"
	fi
}
