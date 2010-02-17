# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="2"
inherit autotools git

DESCRIPTION="Multiplatform class and template library designed to complement and supplement the C++ STL"

HOMEPAGE="http://www.synfig.org/"
EGIT_REPO_URI="git://synfig.git.sourceforge.net/gitroot/synfig/synfig"
EGIT_FETCH_CMD="git clone --depth 1"
SRC_URI=""

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

src_prepare() {
	S="${WORKDIR}/${P}/ETL"
	cd "${S}"
	eautoreconf
}

src_install() {
	emake DESTDIR="${D}" install || die "Install failed"
	dodoc AUTHORS README NEWS || die
}
