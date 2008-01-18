# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit kde

DESCRIPTION="Screen capturing program that records your screen-activities, supports commentboxes and exports to all video formats"
HOMEPAGE="http://screenkast.sourceforge.net/"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86"
IUSE=""

DEPEND="~media-libs/libinstrudeo-${PV}"
RDEPEND="${DEPEND}"

need-kde 3.5
