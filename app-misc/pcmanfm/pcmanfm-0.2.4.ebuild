# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

DESCRIPTION="Extremely fast and lightweight tabbed file manager"
HOMEPAGE="http://pcmanfm.sourceforge.net/"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND="virtual/fam
	x11-libs/cairo
	>=x11-libs/gtk+-2.8
	x11-misc/shared-mime-info
	x11-themes/gnome-icon-theme"
DEPEND="${RDEPEND}
	dev-util/pkgconfig
	sys-devel/autoconf
	>=sys-devel/automake-1.9"

src_install() {
	emake DESTDIR="${D}" install || die "emake install failed"
	dodoc AUTHORS TODO
}

pkg_postinst() {
	if has_version app-admin/fam ; then
		einfo "You are using fam as your file alteration monitor,"
		einfo "so you must have famd started before running pcmanfm."
		einfo
		einfo "To add famd to the default runlevel and start it, run:"
		einfo
    		einfo "# rc-update add famd default"
		einfo "# /etc/init.d/famd start"
		einfo
		einfo "It is recommended you use gamin instead of fam."
	fi
}
