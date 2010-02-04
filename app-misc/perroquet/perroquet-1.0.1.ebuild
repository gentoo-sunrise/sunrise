# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="2"

inherit distutils eutils versionator

DESCRIPTION="Educational program to improve listening in a foreign language"
HOMEPAGE="http://perroquet.b219.org/"
SRC_URI="http://launchpad.net/perroquet/$(get_version_component_range 1-2)/${PV}/+download/${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~x86"
IUSE=""

RDEPEND="virtual/libintl"
DEPEND="${RDEPEND}
	>=dev-python/pygobject-2.18.0
	dev-python/gst-python
	dev-perl/XML-Parser"

src_install() {
	python_src_install --without-icon-cache --without-mime-database \
		--without-desktop-database
}
