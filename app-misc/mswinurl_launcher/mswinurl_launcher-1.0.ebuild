# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-admin/conky/conky-1.7.0_rc1.ebuild,v 1.1 2009/03/17 01:22:09 omp Exp $

inherit eutils fdo-mime

DESCRIPTION="A launcher and desktop association for Microsoft Windows *.URL (text/x-uri) files"
HOMEPAGE="http://bugs.launchpad.net/ubuntu/+source/mime-support/+bug/185165/comments/12"
SRC_URI="http://launchpadlibrarian.net/20406796/mswinurl_launcher.py"

LICENSE="Artistic"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND="dev-util/desktop-file-utils"
RDEPEND="dev-lang/python"

S=${WORKDIR}

src_unpack() {
	cp "${DISTDIR}/${A}" "${S}" || die "could not copy ${A} to ${S}"
}

src_install() {
	dobin ${PN}.py || die
	domenu "${FILESDIR}/${PN}.desktop" || die
}

pkg_postinst() {
	fdo-mime_desktop_database_update
}

pkg_postrm() {
	fdo-mime_desktop_database_update
}
