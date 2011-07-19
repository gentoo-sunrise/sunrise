# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=3

EGIT_REPO_URI="http://github.com/baverman/snaked.git"
SUPPORT_PYTHON_ABIS="1"
PYTHON_DEPEND="2:2.6"
RESTRICT_PYTHON_ABIS="2.[45] 3.*"

inherit distutils git-2 python

DESCRIPTION="Minimalist editor inspired by Scribes"
HOMEPAGE="http://github.com/baverman/snaked"
SRC_URI=""

LICENSE="MIT"
SLOT="0"
KEYWORDS=""
IUSE=""

RDEPEND="
	dev-python/pygtksourceview
	dev-python/rope
	dev-python/pyflakes"
