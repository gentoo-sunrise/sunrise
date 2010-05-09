# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=2
PYTHON_DEPEND="python? 2:2.6"

inherit distutils

DESCRIPTION="Thread-based email index, search and tagging"
HOMEPAGE="http://notmuchmail.org/"
SRC_URI="http://notmuchmail.org/releases/${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="python"

DEPEND="dev-libs/gmime:2.4
	sys-libs/talloc
	>=dev-libs/xapian-1.0.19
	"
RDEPEND="${DEPEND}"

#This is need for src_compile and src_install:
#setup.py imports the notmuch module (__init__.py), which looks for
#libnotmuch.so
export LD_LIBRARY_PATH=${LD_LIBRARY_PATH}:${S}/lib

src_prepare() {
	if use python ; then
		cd bindings/python || die "bindings/python not found"
		distutils_src_prepare
	fi
}

src_compile() {
	default
	if use python ; then
		cd bindings/python || die "bindings/python not found"
		distutils_src_compile
	fi
}

src_install() {
	emake DESTDIR="${D}" install || die "emake failed"
	dodoc AUTHORS NEWS README TODO || die "dodoc failed"
	if use python ; then
		cd bindings/python || die "bindings/python not found"
		distutils_src_install
	fi
}

pkg_postinst() {
	if use python ; then
		distutils_pkg_postinst
	fi
}

pkg_postrm() {
	if use python ; then
		distutils_pkg_postrm
	fi
}
