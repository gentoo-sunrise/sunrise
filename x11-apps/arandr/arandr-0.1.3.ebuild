# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

PYTHON_DEPEND="2"
PYTHON_MODNAME="screenlayout"
SUPPORT_PYTHON_ABIS="1"
RESTRICT_PYTHON_ABIS="3.*"

inherit python distutils

DESCRIPTION="A simple PyGTK front end for XRandR 1.2+ (client side X only)"
HOMEPAGE="http://christian.amsuess.com/tools/arandr/"
SRC_URI="http://christian.amsuess.com/tools/arandr/files/${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND=">=dev-python/docutils-0.6"
RDEPEND="${DEPEND}
	>=dev-python/pygtk-2.10
	>=x11-apps/xrandr-1.2"
