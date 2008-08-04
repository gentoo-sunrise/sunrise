# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="1"
inherit qt4 multilib

DESCRIPTION="Homebrewer's recipe calculator"
HOMEPAGE="http://www.usermode.org/code.html"
SRC_URI="http://www.usermode.org/code/${P}.tar.gz"

LICENSE="BSD-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND="|| ( ( x11-libs/qt-core:4 x11-libs/qt-gui:4 ) >=x11-libs/qt-4.3:4 )"
RDEPEND="${DEPEND}"

src_compile() {
	export BINDIR="/usr/bin" DATADIR="/usr/share/${PN}" DOCDIR="/usr/share/doc/${P}"
	./configure --qtdir="/usr/$(get_libdir)/qt4" || die "configure failed"
	echo "QT += xml" >> qbrew.pro
	eqmake4
	emake || die "emake failed"
}

src_install() {
	dobin qbrew || die "bin install failed"
	insinto /usr/share/${PN}
	doins data/* pics/splash.png || die "install failed"
	dohtml -r docs/* || die "documentation install failed"
	dodoc AUTHORS ChangeLog README TODO || die "documentation install failed"
}
