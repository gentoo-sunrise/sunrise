# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit kde

DESCRIPTION="WebIssues Client application."
HOMEPAGE="http://webissues.mimec.org"
SRC_URI="http://webissues.mimec.org/files/${P}.tar.bz2"

KEYWORDS="~x86"

SLOT="0"
LICENSE="GPL-2"
IUSE="kdeenablefinal"

DEPEND=""
RDEPEND="${DEPEND}"

need-kde 3.5
