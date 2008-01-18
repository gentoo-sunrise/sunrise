# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit kde rpm

MDV_EXTRAVERSION="17mdv2007.1"

DESCRIPTION="Mandriva's Ia Ora theme for KDE"
HOMEPAGE="http://www.mandriva.com/"
SRC_URI="ftp://ftp.free.fr/pub/Distributions_Linux/MandrivaLinux/official/2007.1/SRPMS/main/release/${P}-${MDV_EXTRAVERSION}.src.rpm"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND=""
RDEPEND=""
need-kde 3.5

S=${WORKDIR}/${PN}

src_compile() {
	emake -f admin/Makefile.common cvs || die "emake failed"
}
