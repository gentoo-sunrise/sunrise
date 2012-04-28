# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=4

inherit autotools fdo-mime git-2 multilib mono

DESCRIPTION="Simple Painting for Gtk"
HOMEPAGE="http://pinta-project.com"
SRC_URI=""

EGIT_REPO_URI="git://github.com/PintaProject/Pinta.git"

LICENSE="MIT CCPL-Attribution-3.0"
SLOT="0"
KEYWORDS=""
IUSE=""

RDEPEND="dev-dotnet/gtk-sharp:2
	dev-dotnet/mono-addins[gtk]
	dev-lang/mono
	x11-libs/cairo"
DEPEND="${RDEPEND}
	dev-util/intltool
	dev-util/pkgconfig
	sys-devel/gettext"

src_prepare() {
	sed -e "s/lib/$(get_libdir)/" -i pinta.in || die
	eautoreconf
	intltoolize --copy --automake --force || die "intltoolize failed"
}

pkg_postinst() {
	fdo-mime_desktop_database_update
	fdo-mime_mime_database_update
}

pkg_postrm() {
	fdo-mime_desktop_database_update
	fdo-mime_mime_database_update
}
