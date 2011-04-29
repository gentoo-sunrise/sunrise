# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="4"

DESCRIPTION="A port of the H2O GTK+ theme to GTK2"
HOMEPAGE="http://art.gnome.org/themes/gtk2/213/"
SRC_URI="http://art.gnome.org/download/themes/gtk2/213/GTK2-H2O-default-${PV}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86"
IUSE=""

DEPEND="x11-libs/gtk+:2"
RDEPEND="${DEPEND}"

S=${WORKDIR}

src_prepare() {
	# Clean up unnecessary files
	rm -rf */*/{*.xcf,.gtkrc.swp,.xvpics} || die
}

src_install() {
	insinto /usr/share/themes
	doins -r * || die
}
