# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit kde

KEYWORDS="~x86"

DESCRIPTION="A front-end to ssh-agent which allow you to add, list and remove the keys from your agent."
HOMEPAGE="http://hanz.nl/p/program"
SRC_URI="http://hanz.nl/download/${P}.tar.gz"
LICENSE="GPL-2"
SLOT="0"
IUSE="kdeenablefinal"

DEPEND=""
RDEPEND="net-misc/openssh
	kde-misc/ksshaskpass"

need-kde 3.5
