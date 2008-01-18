# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="1"
inherit qt4

DESCRIPTION="Homebrewer's recipe calculator"
HOMEPAGE="http://www.usermode.org/code.html"
SRC_URI="http://www.usermode.org/code/${P}.tar.gz"

LICENSE="as-is"
SLOT="0"
KEYWORDS="~x86"
IUSE=""

DEPEND=">=x11-libs/qt-4.1:4"
RDEPEND="${DEPEND}"

src_compile() {
	# configure script is broken/bad
	export BINDIR="/usr/bin" DATADIR="/usr/share/${PN}" DOCDIR="/usr/share/doc/${P}"
	eqmake4
	emake || die "emake failed"
}

src_install() {
	dobin qbrew
	insinto /usr/share/${PN}
	doins data/* pics/splash.png
	dohtml -r docs/*
	dodoc AUTHORS ChangeLog README TODO
}
