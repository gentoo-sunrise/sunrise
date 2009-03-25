# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit versionator flag-o-matic

MY_P="${PN}-$(replace_version_separator 2 '-')"

DESCRIPTION="Sound visualisation gadget that works directly with ALSA"
HOMEPAGE="http://www.aufroof.org/?expand=marcel&detail=04_projekte"
SRC_URI="http://www.aufroof.org/marcel/04_projekte/${MY_P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="mmx sse"

DEPEND="media-libs/libsdl
	media-libs/alsa-lib"
RDEPEND="${DEPEND}"

S=${WORKDIR}/${MY_P}

src_compile() {
	use sse && append-flags -DSSE
	use mmx && append-flags -DMMX
	econf
	emake || die "emake failed"
}

src_install() {
	emake DESTDIR="${D}" install || die "emake install failed"
}
