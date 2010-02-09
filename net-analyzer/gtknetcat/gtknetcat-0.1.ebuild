# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit base

DESCRIPTION="GUI frontend for the old UNIX command nc (netcat)"
HOMEPAGE="http://lxde.org/download"
SRC_URI="mirror://sourceforge/lxde/GtkNetCat%20%28GUI%20for%20netcat%29/GtkNetCat%20${PV}/${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND="net-analyzer/netcat
	dev-python/pygtk"
DEPEND=""
