# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header:$

EAPI=4

DESCRIPTION="Creates HTML reports from Ubuntu PPA statistics"
SRC_URI="http://wpitchoune.net/${PN}/files/${P}.tar.gz"
HOMEPAGE="http://wpitchoune.net/blog/ppastats/"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND="dev-libs/json-c
	net-misc/curl"
RDEPEND="${DEPEND}"
