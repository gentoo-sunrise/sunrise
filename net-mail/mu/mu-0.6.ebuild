# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit base

DESCRIPTION="Set of tools to deal with Maildirs, in particular, searching and indexing"
HOMEPAGE="http://www.djcbsoftware.nl/code/mu/"
SRC_URI="http://mu0.googlecode.com/files/${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND="dev-libs/gmime
	dev-libs/xapian
	"
RDEPEND="${DEPEND}"

DOCS=( "AUTHORS" "HACKING" "TODO" )
