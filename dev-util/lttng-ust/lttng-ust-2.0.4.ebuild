# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=4

inherit autotools

DESCRIPTION="Linux Trace Toolkit - UST library"
HOMEPAGE="http://lttng.org"
SRC_URI="http://lttng.org/files/${PN}/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86"
IUSE="examples"

DEPEND="dev-libs/userspace-rcu"
RDEPEND="${DEPEND}"

src_prepare() {
	if ! use examples; then
		sed -i -e '/SUBDIRS/s:examples::' doc/Makefile.am || die
	fi
	eautoreconf
}
