# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="2"

inherit base

DESCRIPTION="Pidgin plugin to capture a rectangular area of your screen and send it"
HOMEPAGE="http://code.google.com/p/pidgin-sendscreenshot"
SRC_URI="http://${PN}.googlecode.com/files/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86"
IUSE=""

DEPEND="net-im/pidgin[gtk]
	net-misc/curl"
RDEPEND="${DEPEND}"

DOCS=( AUTHORS ChangeLog README )
