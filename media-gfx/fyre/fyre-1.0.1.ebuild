# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="2"

GCONF_DEBUG="no"
SCROLLKEEPER_UPDATE="0"

inherit gnome2 eutils

DESCRIPTION="Fyre renders and animates Peter de Jong maps"
HOMEPAGE="http://fyre.navi.cx/"
SRC_URI="http://releases.navi.cx/${PN}/${P}.tar.bz2"

SLOT="0"
LICENSE="GPL-2"
KEYWORDS="~amd64 ~x86"
IUSE="gnet openexr"

RDEPEND="dev-libs/glib:2
	gnome-base/libglade
	x11-libs/gtk+:2
	gnet? ( net-libs/gnet )
	openexr? ( media-libs/openexr )"
DEPEND="${RDEPEND}
	dev-util/desktop-file-utils
	dev-util/pkgconfig
	x11-misc/shared-mime-info"

pkg_setup() {
	G2CONF="$(use_enable gnet) $(use_enable openexr)"
}

src_prepare() {
	epatch "${FILESDIR}"/${PN}_file_dialog_pause_fix.patch
}

src_install() {
	#...=/bin/true prevents the makefile from updating mime and .desktop
	# databases on its own
	emake DESTDIR="${D}" \
		update_xdgmime=/bin/true update_fdodesktop=/bin/true \
		install || die
	dodoc AUTHORS ChangeLog README TODO || die

	if use gnet; then
		newconfd "${FILESDIR}/${P}-conf" ${PN} || die
		newinitd "${FILESDIR}/${P}-init" ${PN} || die
	fi
}
