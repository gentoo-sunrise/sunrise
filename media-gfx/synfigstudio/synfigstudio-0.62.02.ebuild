# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=4

inherit eutils

DESCRIPTION="Main UI of synfig: Film-Quality Vector Animation"
HOMEPAGE="http://www.synfig.org/"
SRC_URI="mirror://sourceforge/synfig/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="fmod"

DEPEND="
	dev-cpp/gtkmm:2.4
	>=media-gfx/synfig-${PV}
	dev-libs/libsigc++:2
	fmod? ( media-libs/fmod )"
RDEPEND=${DEPEND}

src_prepare() {
	epatch "${FILESDIR}"/${P}-gcc46.patch
}

src_configure() {
	econf $(use_with fmod libfmod )
}
