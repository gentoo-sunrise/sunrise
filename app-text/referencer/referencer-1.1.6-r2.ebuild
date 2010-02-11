# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="2"

inherit fdo-mime

DESCRIPTION="Gnome application to organise documents or references, and to generate BibTeX bibliography files"
HOMEPAGE="http://icculus.org/referencer/"
SRC_URI="http://icculus.org/${PN}/downloads/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND=">=app-text/poppler-0.12.3-r3
	>=dev-cpp/gtkmm-2.8
	>=dev-cpp/libgnomeuimm-2.14.0
	>=dev-cpp/gnome-vfsmm-2.14.0
	>=dev-cpp/libglademm-2.6.0
	>=dev-cpp/gconfmm-2.14.0
	dev-libs/boost
	dev-lang/python"

DEPEND="${RDEPEND}
	>=app-text/gnome-doc-utils-0.3.2
	dev-util/pkgconfig
	>=dev-lang/perl-5.8.1
	dev-perl/libxml-perl
	dev-util/intltool
	app-text/rarian"

src_configure() {
	econf --disable-update-mime-database --enable-python
}

src_install() {
	emake install DESTDIR="${D}" || die "emake failed"
	dodoc AUTHORS ChangeLog NEWS README TODO || die
}

pkg_postinst() {
	fdo-mime_mime_database_update
}

pkg_postrm() {
	fdo-mime_mime_database_update
}
