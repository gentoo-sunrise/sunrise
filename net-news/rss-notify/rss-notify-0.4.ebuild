# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="3"

PYTHON_DEPEND="2"
SUPPORT_PYTHON_ABIS="1"
RESTRICT_PYTHON_ABIS="3.*"

inherit distutils

DESCRIPTION="RSS reader in the style of notify-osd"
HOMEPAGE="http://launchpad.net/rssn/"
SRC_URI="http://launchpad.net/rssn/${PV}/${PV}/+download/${PN}_${PV}-0ubuntu0~ppa1~jaunty.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND="
	dev-python/feedparser
	>=dev-python/gconf-python-2.22.3
	>=dev-python/imaging-1.1.6
	dev-python/notify-python"

PYTHON_MODNAME="${PN/-/_}"
