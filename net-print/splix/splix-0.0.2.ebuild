# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit eutils

DESCRIPTION="A set of CUPS printer drivers for SPL (Samsung Printer Language) printers"
HOMEPAGE="http://splix.sourceforge.net/"
SRC_URI="http://heanet.dl.sourceforge.net/sourceforge/splix/${P}.tar.bz2"

LICENSE="GPL-1"
SLOT="0"
KEYWORDS="~x86"
IUSE=""

DEPEND="=net-print/cupsddk-1.1.0_p20061207"
RDEPEND="${DEPEND}"

export CUPSFILTER="${D}`cups-config --serverbin`/filter"
export CUPSPPD="${D}`cups-config --datadir`/model"

src_compile() {
	epatch "${FILESDIR}"/fixMakefile.patch
	emake || die "emake failed"
}

src_install() {
	mkdir -p "${CUPSFILTER}"
	mkdir -p "${CUPSPPD}"
	emake DESTDIR="${D}" install || die "emake install failed"
}
