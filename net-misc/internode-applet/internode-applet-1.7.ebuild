# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="3"

PYTHON_DEPEND="2"
SUPPORT_PYTHON_ABIS="1"
RESTRICT_PYTHON_ABIS="3.*"

inherit distutils

DESCRIPTION="Internode Usage Meter for GNOME"
HOMEPAGE="http://www.users.on.net/~spohlenz/internode/"
SRC_URI="http://www.users.on.net/~spohlenz/internode/${P}.tar.gz"

LICENSE="GPL-1"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND="dev-python/gnome-python-desktop"

PYTHON_MODNAME=internode
