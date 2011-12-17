# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=4

inherit kde4-base

DESCRIPTION="Nice KDE replacement to du command"
HOMEPAGE="https://bitbucket.org/jeromerobert/k4dirstat/"
SRC_URI="${HOMEPAGE}get/k4dirstat-${PV}.tar.bz2"

LICENSE="GPL-2"
SLOT="4"
KEYWORDS="~amd64"
IUSE=""

RDEPEND="kde-base/libkonq:4
	sys-libs/zlib"
DEPEND="${RDEPEND}"

src_unpack() {
	# tarball contains git revision hash, which we don't want in the ebuild.
	default
	mv "${WORKDIR}"/*k4dirstat-* "${S}" || die
}
