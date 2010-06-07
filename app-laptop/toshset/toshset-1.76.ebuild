# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=2

inherit autotools toolchain-funcs

DESCRIPTION="Utility to modify HCI/SCI controls on Toshiba Laptops"
HOMEPAGE="http://www.schwieters.org/toshset/"
SRC_URI="http://schwieters.org/${PN}/allVersions/${P}.tgz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="debug"

src_prepare() {
	sed -i '/$(BININSTALL) novatel_3g_suspend/d' "${S}/Makefile.in" || die "sed failed"
	sed -i '/$(DESTDIR)\/pm\/sleep.d\/$/d' "${S}/Makefile.in" || die "sed failed"
	sed -i "s/\(^CFLAGS = -Wall @OS_CFLAGS@ @DEBUGFLAGS@$\)/\1 ${CFLAGS}/" "${S}/Makefile.in" || die "sed failed"
	sed -i "/^LDFLAGS = -s/s:-s:${LDFLAGS}:" "${S}/Makefile.in" || die "sed failed"

	eautoreconf
}

src_configure() {
	econf $(use_enable debug)
}

src_compile() {
	emake CC=$(tc-getCC) CXX=$(tc-getCXX) || die "emake failed"
}

src_install() {
	emake CC=$(tc-getCC) CXX=$(tc-getCXX) \
		DESTDIR="${D}" install || die "emake install failed"
	dodoc README README.video || die
}

pkg_postinst() {
	ewarn "If you want to use ${PN} under ACPI you probably need to patch your kernel."
	ewarn "Check ${HOMEPAGE} for details."
}
