# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=4

inherit eutils multilib fdo-mime

DESCRIPTION="Upload tool for the imagehoster abload"
HOMEPAGE="http://www.abload.de/tool.php"
SRC_URI="amd64? ( http://download.${PN}.de/ubuntu-64/${P}.x86_64.deb )
	x86? ( http://download.${PN}.de/ubuntu-32/${P}.i386.deb )"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="gnome kde"

DEPEND=""
RDEPEND="x11-libs/qt-core:4
	x11-libs/qt-gui:4"

S=${WORKDIR}/usr

src_unpack() {
	default
	unpack ./data.tar.gz
}

src_install() {
	into /opt/${PN}
	dobin bin/${PN}
	dosym /opt/${PN}/bin/${PN} /opt/bin/${PN}
	dolib lib/libabload.so.0.1.0
	dosym libabload.so.0.1.0 /opt/${PN}/$(get_libdir)/libabload.so
	dosym libabload.so.0.1.0 /opt/${PN}/$(get_libdir)/libabload.so.0
	dosym libabload.so.0.1.0 /opt/${PN}/$(get_libdir)/libabload.so.0.1
	into /usr
	domenu share/applications/${PN}.desktop
	doicon share/pixmaps/${PN}.png

	if use kde ; then
		insinto /usr/share/kde4/services/ServiceMenus
		doins "${FILESDIR}"/abloadaction.desktop
	fi

	if use gnome ; then
		insinto /usr/share/${PN}
		newins "${FILESDIR}"/nautilus1.sh "abload in background"
		newins "${FILESDIR}"/nautilus2.sh "open in abload"
	fi

	make_wrapper ${PN} /opt/${PN}/bin/${PN} "" /opt/${PN}/$(get_libdir)
}

pkg_postinst() {
	fdo-mime_desktop_database_update

	if use gnome ; then
		elog "                                              "
		elog "Nautilus scripts are in /usr/share/abloadtool."
		elog "Copy them to ~/.gnome2/nautilus-scripts and   "
		elog "make them executable!                         "
		elog "                                              "
	fi
}

pkg_postrm() {
	fdo-mime_desktop_database_update
}
