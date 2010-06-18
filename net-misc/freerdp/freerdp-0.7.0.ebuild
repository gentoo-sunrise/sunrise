# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=2

inherit base

DESCRIPTION="FreeRDP intends to rapidly start moving forward and implement features that rdesktop lacks the most"
HOMEPAGE="http://freerdp.sourceforge.net/"
SRC_URI="mirror://sourceforge/${PN}/${PV%.*}/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

DEPEND="media-libs/alsa-lib
	dev-libs/openssl"
RDEPEND="${DEPEND}"

DOCS=( AUTHORS ChangeLog NEWS README )
