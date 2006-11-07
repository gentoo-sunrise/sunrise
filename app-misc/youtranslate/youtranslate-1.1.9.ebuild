# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit mono eutils

DESCRIPTION="Gtk# frontend for Internet translation services"
HOMEPAGE="http://laas.altervista.org/youtranslate/ytindex.php"
SRC_URI="http://laas.altervista.org/${PN}/${P}_src.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND=">=dev-lang/mono-1.0
	>=dev-dotnet/gtk-sharp-2.4
	>=dev-dotnet/glade-sharp-2.4"
RDEPEND="${DEPEND}"

src_compile() {
	emake -f Makefile.solution.youtranslate || die "emake failed"
}

src_install() {
	dobin youtranslate.exe "${FILESDIR}/youtranslate"
	doicon yTicon.png
	make_desktop_entry "${PN}" "YouTranslate!" "yTicon" "Utility"
}
