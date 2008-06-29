# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit rpm

MDV_EXTRAVERSION="1mdv2007.1"

DESCRIPTION="Mandriva's Ia Ora theme for GTK2 and Metacity"
HOMEPAGE="http://www.mandriva.com/"
SRC_URI="ftp://ftp.free.fr/pub/Distributions_Linux/MandrivaLinux/official/2007.1/SRPMS/main/release/ia_ora-gnome-${PV}-${MDV_EXTRAVERSION}.src.rpm"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND="x11-themes/gnome-icon-theme"
RDEPEND="${DEPEND}"

S="${WORKDIR}/ia_ora-gnome-${PV}"

src_install() {
	emake DESTDIR="${D}" install || die "emake install failed"
	dodoc AUTHORS README ChangeLog
}
