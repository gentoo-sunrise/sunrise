# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit eutils toolchain-funcs

DESCRIPTION="An implementation of the Optimized Link State Routing protocol"
HOMEPAGE="http://www.olsr.org/"
SRC_URI="http://www.olsr.org/releases/${PV%.*}/${P}.tar.bz2"

SLOT="0"
LICENSE="GPL-2"
KEYWORDS="~x86"
IUSE="gtk"

DEPEND="gtk? ( =x11-libs/gtk+-2* )"

src_unpack() {
	unpack ${A}
	cd "${S}"
	epatch "${FILESDIR}/${P}-gui_makefile.patch"
	epatch "${FILESDIR}/${P}-memleak_in_olsr_remove_scheduler_event.patch"
}

src_compile() {
	cd "${S}"
	emake OS=linux CC=$(tc-getCC) || die "emake failed"

	for module in dot_draw dyn_gw httpinfo nameservice powerinfo secure ; do
		cd "${S}/lib/${module}"
		emake OS=linux CC=$(tc-getCC) || die "emake failed"
	done

	if use gtk ; then
		cd "${S}/gui/linux-gtk"
		einfo "Building GUI ..."
		emake CC=$(tc-getCC) || die "emake failed"
	fi
}

src_install() {
	dosbin olsrd

	doman files/olsrd.conf.5.gz files/olsrd.8.gz

	dolib lib/dot_draw/olsrd_dot_draw.so.0.3 lib/dyn_gw/olsrd_dyn_gw.so.0.4
	dolib lib/httpinfo/olsrd_httpinfo.so.0.1 lib/nameservice/olsrd_nameservice.so.0.2
	dolib lib/powerinfo/olsrd_power.so.0.3 lib/secure/olsrd_secure.so.0.5

	dodoc files/olsrd.conf.default.rfc files/olsrd.conf.default.lq \
		lib/dyn_gw/README_DYN_GW lib/dot_draw/README_DOT_DRAW \
		lib/httpinfo/README_HTTPINFO lib/powerinfo/README_POWER
	newdoc lib/nameservice/README README-NAMESERVICE
	newdoc lib/secure/SOLSR-README README-SECURE

	use gtk && dobin gui/linux-gtk/olsrd-gui

	doinitd "${FILESDIR}/olsrd"
}

pkg_postinst() {
	ewarn "You must have root privileges to run olsrd!"
	elog
	elog "olsrd uses the config file /etc/olsrd.conf"
	elog "There are two example config files"
	elog
	elog "	/usr/share/doc/${PF}/olsrd.conf.default.rfc.gz"
	elog "  /usr/share/doc/${PF}/olsrd.conf.default.lq.gz"
	elog
	elog "First one uses RFC conform OLSR and the second uses"
	elog "the Link Quality Extensions:"
	elog
	elog "  http://www.olsr.org/docs/README-Link-Quality.html"
}
