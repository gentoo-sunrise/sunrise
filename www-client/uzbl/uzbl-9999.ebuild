# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="2"

EGIT_REPO_URI="git://github.com/Dieterbe/uzbl.git"

inherit git toolchain-funcs

DESCRIPTION="A web browser that follows the UNIX philosophy"
HOMEPAGE="http://www.uzbl.org"
SRC_URI=""

LICENSE="GPL-3"
SLOT="0"
KEYWORDS=""
IUSE=""

RDEPEND="dev-lang/perl
	gnome-extra/zenity
	net-misc/socat
	>=net-libs/libsoup-2.24
	>=net-libs/webkit-gtk-1.1.4
	>=x11-libs/gtk+-2.14"
DEPEND="${RDEPEND}
	dev-util/pkgconfig"

EGIT_PATCHES=("${FILESDIR}/${PV}-Makefile.patch")

src_compile() {
	emake CC=$(tc-getCC) || die "emake failed"
}

src_install() {
	emake DESTDIR="${D}" install || die "install failed"
	dodoc docs/* || die "dodoc failed"
}

pkg_postinst() {
	ewarn "Remember to export XDG_DATA_HOME and XDG_CONFIG_HOME or otherwise"
	ewarn "${PN} won't work."
	ewarn "For testing do:"
	ewarn "	export XDG_DATA_HOME=\"/usr/share/uzbl/examples/data/\""
	ewarn "	export XDG_CONFIG_HOME=\"/usr/share/uzbl/examples/config/\""
}
