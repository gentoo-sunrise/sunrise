# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="2"

inherit eutils autotools versionator

DESCRIPTION="GTK based GUI for xneur"
HOMEPAGE="http://www.xneur.ru/"
SRC_URI="http://dists.xneur.ru/release-${PV}/tgz/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="nls"

RDEPEND=">=x11-misc/xneur-$(get_version_component_range 1-2)
	 >=x11-libs/gtk+-2.0.0
	 >=sys-devel/gettext-0.16.1
	 >=gnome-base/libglade-2.6.0"
DEPEND="${RDEPEND}
	>=dev-util/pkgconfig-0.20"

src_prepare() {
	epatch "${FILESDIR}/${PN}-0.9.3-CFLAGS.patch"
	rm ltmain.sh aclocal.m4	m4/{lt~obsolete,ltoptions,ltsugar,ltversion,libtool}.m4
	sed -i "s/-Werror -g0//" configure.in || die
	eautoreconf
}

src_configure() {
	econf $(use_enable nls)
}

src_install() {
	emake install DESTDIR="${D}" || die
	dodoc AUTHORS ChangeLog NEWS || die
	doicon pixmaps/gxneur.png
	make_desktop_entry "${PN}" "${PN}" ${PN} "GTK;Gnome;Utility;TrayIcon"
}
