# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="2"
PYTHON_DEPEND="2:2.4"
RESTRICT_PYTHON_ABIS="3"

inherit distutils toolchain-funcs

DESCRIPTION="Little Nautilus extension that binds any shortcut to gloobus-preview"
HOMEPAGE="http://github.com/DaKTaLeS/nautilus-gloobus-preview"
SRC_URI="http://www.encomiabile.it/files/ngp/${P}.tar.gz"

LICENSE="LGPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND="dev-python/nautilus-python
	gnome-extra/gloobus-preview"

pkg_postinst() {
	# Getting nautilus extension dir
	local extensiondir="$($(tc-getPKG_CONFIG) --variable=extensiondir libnautilus-extension)"
	python_mod_optimize "${extensiondir}"/python/${PN}.py
	elog "You have to restart Nautilus to use ${PN}."
	elog "		nautilus -q"
	elog "		nautilus --no-desktop"
}
