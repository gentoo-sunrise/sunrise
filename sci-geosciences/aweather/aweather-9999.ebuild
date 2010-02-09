# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EGIT_REPO_URI="git://lug.rose-hulman.edu/proj/aweather"
EGIT_BOOTSTRAP="eautoreconf"

inherit autotools git

DESCRIPTION="A weather monitoring program"
HOMEPAGE="http://lug.rose-hulman.edu/wiki/AWeather"
SRC_URI=""

LICENSE="GPL-3"
SLOT="0"
KEYWORDS=""
IUSE=""

RDEPEND="~sci-libs/libgis-9999
	>=x11-libs/gtk+-2.16
	sci-libs/rsl"
DEPEND="${RDEPEND}"

src_install() {
	emake DESTDIR="${D}" install || die "install failed"
	dodoc ChangeLog README TODO || die
}
