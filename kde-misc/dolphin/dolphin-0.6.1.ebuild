# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit kde

KEYWORDS="~x86"

DESCRIPTION="A file manager for KDE focusing on usability."
HOMEPAGE="http://enzosworld.gmxhome.de"
SRC_URI="http://enzosworld.gmxhome.de/download/${P}.tar.gz"
SLOT="0"
LICENSE="GPL-2"
IUSE=""

DEPEND="kde-base/kdelibs"
RDEPEND="${DEPEND}"

need-kde 3.4

S=${WORKDIR}/${PN}
