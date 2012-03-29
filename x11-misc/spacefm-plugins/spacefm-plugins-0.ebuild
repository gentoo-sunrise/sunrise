# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=4

DESCRIPTION="Meta-package for various spacefm-plugins"
HOMEPAGE="https://github.com/IgnorantGuru/spacefm/wiki/plugins/"
SRC_URI=""

LICENSE="as-is"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="cdemu dmenu httpshare trash"

RDEPEND="cdemu? ( x11-misc/spacefm-cdemu-plugin )
	dmenu? ( x11-misc/spacefm-dmenu-plugin )
	httpshare? ( x11-misc/spacefm-httpshare-plugin )
	trash? ( x11-misc/spacefm-trash-plugin )"
REQUIRED_USE="|| ( ${IUSE} )"
