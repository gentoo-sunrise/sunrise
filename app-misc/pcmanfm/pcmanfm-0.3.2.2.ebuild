# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

MY_P=${P/_beta/-beta}

DESCRIPTION="Extremely fast and lightweight tabbed file manager"
HOMEPAGE="http://pcmanfm.sourceforge.net/"
SRC_URI="mirror://sourceforge/${PN}/${MY_P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="fam hal"

RDEPEND="fam? ( virtual/fam )
	x11-libs/cairo
	>=x11-libs/gtk+-2.8
	x11-misc/shared-mime-info
	hal? ( >=sys-apps/hal-0.5.0 )"
DEPEND="${RDEPEND}
	dev-util/pkgconfig"

S=${WORKDIR}/${MY_P}

pkg_setup() {
	if ! use fam ; then
		ewarn "You have disabled fam, experimental inotify support"
		ewarn "will be used instead. If you have problems, then"
		ewarn "recompile this package with USE=\"fam\""
	fi
}

src_compile() {
	econf \
		$(use_enable hal) \
		$(use_enable !fam inotify) \
		|| die "econf failed"
	emake || die "emake failed"
}

src_install() {
	emake DESTDIR="${D}" install || die "emake install failed"
	dodoc AUTHORS TODO
}

pkg_postinst() {
	if use fam && has_version app-admin/fam ; then
		elog "You are using fam as your file alteration monitor,"
		elog "so you must have famd started before running pcmanfm."
		elog
		elog "To add famd to the default runlevel and start it, run:"
		elog
		elog "# rc-update add famd default"
		elog "# /etc/init.d/famd start"
		elog
		elog "It is recommended you use gamin instead of fam."
	fi
}
