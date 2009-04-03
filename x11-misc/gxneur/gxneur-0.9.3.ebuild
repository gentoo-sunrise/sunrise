# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="2"

DESCRIPTION="GTK based GUI for xneur"
HOMEPAGE="http://www.xneur.ru/"
if [[ "${PV}" =~ (_p)([0-9]+) ]] ; then
	inherit subversion
	SRC_URI=""
	MTSLPT_REV=${BASH_REMATCH[2]}
	ESVN_REPO_URI="svn://xneur.ru:3690/xneur/${PN}/@${MTSLPT_REV}"
else
	inherit eutils autotools versionator
	SRC_URI="http://dists.xneur.ru/release-${PV}/tgz/${P}.tar.bz2"
fi

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

src_unpack() {
	if [[ ${SRC_URI} == "" ]] ; then
		subversion_src_unpack
	else
		unpack ${A}
	fi
}

src_prepare() {
	epatch "${FILESDIR}/${P}-CFLAGS.patch"
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
