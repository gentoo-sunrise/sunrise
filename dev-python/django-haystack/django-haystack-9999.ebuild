# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EGIT_REPO_URI="git://github.com/toastdriven/${PN}.git"

inherit distutils git

DESCRIPTION="Modular search for django"
HOMEPAGE="http://haystacksearch.org"
SRC_URI=""

LICENSE="BSD"
SLOT="0"
KEYWORDS=""
IUSE=""

RDEPEND="dev-python/django
	<dev-python/Whoosh-0.2"
