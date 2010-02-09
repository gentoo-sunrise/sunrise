# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="2"

inherit base

DESCRIPTION="Library for handling Metalink files"
HOMEPAGE="http://launchpad.net/libmetalink"
SRC_URI="http://code.launchpad.net/${PN}/trunk/${PV}/+download/${P}.tar.bz2"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~x86"
IUSE="expat test"

RDEPEND="expat? ( dev-libs/expat )
	!expat? ( >=dev-libs/libxml2-2.6.24 )"
DEPEND="${RDEPEND}
	test? ( dev-util/cunit )"

src_configure() {
	local xml_args
	use expat \
		&& xml_args=--with-libexpat \
		|| xml_args=--with-libxml2

	econf ${xml_args} --docdir=/usr/share/doc/${PF}
}
