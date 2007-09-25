# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit eutils kde-functions versionator

BASE_PV=$(get_version_component_range 1-2)

DESCRIPTION="TI89(ti)/92(+)/V200 emulator"
HOMEPAGE="http://lpg.ticalc.org/prj_tiemu/"
SRC_URI="mirror://sourceforge/gtktiemu/${PN}-${BASE_PV}.tar.bz2
		mirror://sourceforge/gtktiemu/${P}.diff.bz2"
LICENSE="GPL-2"

SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="dbus kde nls"

DEPEND=">=sci-libs/libticables2-1.0.0
		>=sci-libs/libticalcs2-1.0.7
		>=sci-libs/libtifiles2-1.0.7
		>=sci-libs/libticonv-1.0.4
		>=dev-libs/glib-2.6.0
		>=gnome-base/libglade-2.4.0
		>=x11-libs/gtk+-2.6.0
		nls? ( sys-devel/gettext )
		dbus? ( >=dev-libs/dbus-glib-0.60 )"

RDEPEND="${DEPEND}"

S="${WORKDIR}/${PN}-${BASE_PV}"

src_unpack() {
	unpack ${A}
	cd "${S}"
	epatch "${WORKDIR}/${P}.diff"
}

src_compile() {
	use kde && set-kdedir 3

	econf \
		$(use_enable nls) \
		$(use_with kde) \
		$(use_enable dbus)

	emake || die "emake failed"
}

src_install() {
	emake -j1 DESTDIR="${D}" install || die "emake install failed"
	dodoc AUTHORS NEWS README README.linux RELEASE THANKS TODO
}
