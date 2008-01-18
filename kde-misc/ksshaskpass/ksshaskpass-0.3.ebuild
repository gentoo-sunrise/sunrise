# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit kde

DESCRIPTION="KDE implementation of ssh-askpass with Kwallet integration."
HOMEPAGE="http://hanz.nl/p/program"
SRC_URI="http://hanz.nl/download/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86"
IUSE="kdeenablefinal"

DEPEND=""
RDEPEND="net-misc/openssh"

need-kde 3.5
