# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit distutils eutils versionator

MY_PV="$(get_version_component_range 1-2)"

DESCRIPTION="Simple on-screen Keyboard with macros and easy layout creation"
HOMEPAGE="https://launchpad.net/onboard"
SRC_URI="http://launchpad.net/${PN}/${MY_PV}/${MY_PV}/+download/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

DEPEND=""
RDEPEND="dev-python/gconf-python
	dev-python/pyxml
	dev-python/python-virtkey"

PYTHON_MODNAME="Onboard"

src_install()
{
	distutils_src_install

	dohtml docs/* || die "dohtml failed."
	domenu debian/*.desktop || die "domenu failed."
}
