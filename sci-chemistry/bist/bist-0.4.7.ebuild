# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit eutils

DESCRIPTION="Bist, the chemical drawing tool"
HOMEPAGE="http://www.autistici.org/interzona/index.php?mod=03_Bist"
SRC_URI="http://www.autistici.org/interzona/ftrack.php?url=sections/06_Download/${P}.tar.bz2"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND="net-misc/curl
	dev-libs/expat
	x11-libs/fltk
	sci-libs/gsl
	>=sci-chemistry/openbabel-2.2.0
	>=media-libs/plotutils-2.5"
DEPEND="${RDEPEND}
	>=sys-devel/gcc-4.2"

src_unpack() {
	unpack ${A}
	cd "${S}"
	use amd64 && epatch "${FILESDIR}/wrap_bracket_dialog-amd64.patch"
}


src_install() {
	dobin bist || die "bist install failed"
	#install bist plug-ins
	insinto /usr/lib/bist/plugin
	doins plugin/*.so || die "make plugin failed"
	dodoc AUTHORS TODO || die
	cd doc
	doman  man/bist.1 || die
	dohtml *.html *.png *jpg || die
}
