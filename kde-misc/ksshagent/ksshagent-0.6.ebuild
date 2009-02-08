# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit kde rpm

KEYWORDS="~amd64 ~x86"

DESCRIPTION="A front-end to ssh-agent which allow you to add, list and remove the keys from your agent."
HOMEPAGE="http://hanz.nl/p/program"
SRC_URI="http://mirror.fraunhofer.de/opensuse.org/repositories/home:/jsakalos/openSUSE_10.2/src/${P}-1.3.src.rpm"
LICENSE="GPL-2"
SLOT="0"
IUSE="kdeenablefinal"

RDEPEND="net-misc/openssh
	kde-misc/ksshaskpass"

need-kde 3.5

