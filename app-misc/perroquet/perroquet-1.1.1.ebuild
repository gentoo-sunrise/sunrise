# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="2"

PYTHON_DEPEND="2:2.6"
SUPPORT_PYTHON_ABIS="1"

inherit distutils eutils versionator

DESCRIPTION="Educational program to improve listening in a foreign language"
HOMEPAGE="http://perroquet.b219.org/"
SRC_URI="http://launchpad.net/${PN}/$(get_version_component_range 1-2)/${PV}/+download/${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND="virtual/libintl"
DEPEND="${RDEPEND}
	dev-python/pygobject:2
	dev-python/gst-python
	dev-perl/XML-Parser"
RESTRICT_PYTHON_ABIS="2.[45] 3.*"

DISTUTILS_GLOBAL_OPTIONS=(--without-icon-cache --without-mime-database \
	--without-desktop-database)
