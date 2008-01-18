# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

GCONF_DEBUG="no"
SCROLLKEEPER_UPDATE="no"

inherit gnome2

DESCRIPTION="Fyre renders and animates Peter de Jong maps"
SRC_URI="http://flapjack.navi.cx/releases/fyre/${P}.tar.bz2"
HOMEPAGE="http://fyre.navi.cx/"

SLOT="0"
LICENSE="GPL-2"
KEYWORDS="~amd64 ~x86"
IUSE="cluster openexr"

RDEPEND=">=dev-libs/glib-2.0
	>=gnome-base/libglade-2.4
	>=x11-libs/gtk+-2.0
	cluster? ( >=net-libs/gnet-2.0 )
	openexr? ( media-libs/openexr )"
DEPEND="${RDEPEND}
	dev-util/desktop-file-utils
	>=dev-util/pkgconfig-0.9
	x11-misc/shared-mime-info"

pkg_setup() {
	G2CONF="$(use_enable cluster gnet) $(use_enable openexr)"
}

src_install() {
	#...=/bin/true prevents the makefile from updating mime and .desktop
	# databases on its own
	emake DESTDIR="${D}" \
		update_xdgmime=/bin/true update_fdodesktop=/bin/true \
		install || die "install failed"
	dodoc AUTHORS ChangeLog README TODO

	if use cluster; then
		newconfd "${FILESDIR}/"${P}-conf fyre
		newinitd "${FILESDIR}/"${P}-init fyre
	fi
}
