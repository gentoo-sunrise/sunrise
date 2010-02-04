# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=2

inherit distutils eutils versionator

DESCRIPTION="Simple on-screen Keyboard with macros and easy layout creation"
HOMEPAGE="https://launchpad.net/onboard"
SRC_URI="http://launchpad.net/${PN}/$(get_version_component_range 1-2)/${PV}/+download/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND=">=dev-python/python-distutils-extra-2.4"
RDEPEND="dev-python/gconf-python
	dev-python/pyxml
	dev-python/python-virtkey
	x11-libs/cairo[svg]"

PYTHON_MODNAME="Onboard"

src_install()
{
	distutils_src_install

	domenu data/*.desktop || die "domenu failed."
}
