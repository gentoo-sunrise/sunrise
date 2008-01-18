# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/x11-themes/mandriva-galaxy/mandriva-galaxy-1.0.4.ebuild,v 1.17 2005/10/04 13:37:37 metalgod Exp $

inherit eutils rpm kde-functions autotools

MDV_EXTRAVERSION="3mdv2007.0"

DESCRIPTION="Mandriva's Galaxy theme for GTK2, Metacity and KDE"
HOMEPAGE="http://www.mandriva.com/"
SRC_URI="ftp://ftp.free.fr/pub/Distributions_Linux/MandrivaLinux/official/2007.0/SRPMS/main/release/galaxy-${PV}-${MDV_EXTRAVERSION}.src.rpm"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="kde"

DEPEND=">=x11-libs/gtk+-2.0
	kde? ( || ( kde-base/kwin kde-base/kdebase ) )"

RDEPEND="${DEPEND}"

S="${WORKDIR}/galaxy-${PV}"

src_unpack() {
	rpm_src_unpack
	cd "${S}"
	epatch "${FILESDIR}"/remove-gtk1.patch
	use kde || epatch "${FILESDIR}"/remove-kde.patch
	eautoreconf
}

src_compile() {
	set-qtdir 3
	set-kdedir 3
	econf || die "econf failed"
	emake || die "emake failed"
}

src_install() {
	emake DESTDIR="${D}" install || die "emake install failed"
	dodoc AUTHORS README ChangeLog
}
