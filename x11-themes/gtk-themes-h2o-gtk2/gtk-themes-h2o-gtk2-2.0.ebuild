# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

DESCRIPTION="A port of the H2O GTK+ theme to GTK2"
HOMEPAGE="http://themes.freshmeat.net/projects/h2o-gtk2/"
SRC_URI="http://themes.freshmeat.net/redir/h2o-gtk2/34135/url_tgz/h2o-gtk2-default-${PV}.tar.gz"

IUSE=""
KEYWORDS="~x86"
LICENSE="GPL-2"
SLOT="0"

S=${WORKDIR}

RDEPEND=">=x11-libs/gtk+-2.2"

src_unpack() {
	unpack ${A}
	cd "${S}"

	# Clean up unnecessary files
	rm -r */*/{*xcf,.gtkrc.swp,.xvpics}
}

src_install() {
	insinto /usr/share/themes
	doins -r *
}
