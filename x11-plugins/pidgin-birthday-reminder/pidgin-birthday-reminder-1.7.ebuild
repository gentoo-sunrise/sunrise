# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=4

DESCRIPTION="Plugin for Pidgin that reminds you of your buddies birthdays"
HOMEPAGE="http://launchpad.net/pidgin-birthday-reminder"
SRC_URI="http://launchpad.net/${PN}/trunk/${PV}/+download/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND="net-im/pidgin[gtk]"
RDEPEND="${DEPEND}"
