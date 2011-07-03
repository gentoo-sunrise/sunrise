# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=4

inherit multilib rpm

MDV_VERSION="2009.0"

DESCRIPTION="Mandriva's Ia Ora theme for GTK2 and Metacity"
HOMEPAGE="http://www.mandriva.com/"
SRC_URI="ftp://ftp.free.fr/pub/Distributions_Linux/MandrivaLinux/official/${MDV_VERSION}/SRPMS/main/release/ia_ora-gnome-${PV}-1mdv${MDV_VERSION}.src.rpm"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND="x11-libs/gtk+:2"
RDEPEND="${DEPEND}
	x11-themes/gnome-icon-theme"

S=${WORKDIR}/ia_ora-gnome-${PV}

src_install() {
	emake DESTDIR="${D}" install
	rm -f "${D}usr/$(get_libdir)/gtk-2.0/2.10.0/engines/libia_ora.la" \
		|| die "removing .la file"
	dodoc AUTHORS README ChangeLog
}
