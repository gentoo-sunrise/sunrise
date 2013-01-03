# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="5"

PYTHON_COMPAT=( python2_{6,7} )

inherit autotools eutils python-single-r1

DESCRIPTION="Tools and bindings for kernel input event device emulation, data capture and replay"
HOMEPAGE="https://launchpad.net/evemu"
SRC_URI="http://launchpad.net/${PN}/trunk/${P}/+download/${P}.tar.gz"

LICENSE="LGPL-3 GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="static-libs"

RDEPEND="${PYTHON_DEPS}"
DEPEND="app-text/asciidoc
	app-text/xmlto
	${RDEPEND}"

src_prepare() {
	# add --disable-werror flag - upstream bug: https://bugs.launchpad.net/evemu/+bug/1095836
	epatch "${FILESDIR}"/${P}-werror.patch
	eautoreconf

	sed -e "s|${PN}|man1/${PN}|" -i tools/${PN}-record.1 tools/${PN}-play.1 || die
}

src_configure() {
	econf \
		--disable-werror \
		$(use_enable static-libs static)
}

src_install() {
	default
	use static-libs || prune_libtool_files
}
