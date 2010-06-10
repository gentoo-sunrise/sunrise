# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=2

inherit autotools base git

EGIT_REPO_URI="git://${PN}.git.sourceforge.net/gitroot/${PN}/${PN}"

DESCRIPTION="FreeRDP intends to rapidly start moving forward and implement features that rdesktop lacks the most"
HOMEPAGE="http://freerdp.sourceforge.net/"
SRC_URI=""

LICENSE="GPL-2"
SLOT="0"
KEYWORDS=""
IUSE=""

DEPEND="media-libs/alsa-lib
	dev-libs/openssl"
RDEPEND="${DEPEND}"

DOCS=( AUTHORS ChangeLog NEWS README )

src_prepare() {
	eautoreconf
}
