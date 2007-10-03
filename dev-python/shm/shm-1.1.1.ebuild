# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit distutils

DESCRIPTION="An implementation of shared memory access for Python."
HOMEPAGE="http://nikitathespider.com/python/shm/"
SRC_URI="http://nikitathespider.com/python/shm/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86"
IUSE=""

# $S is set to $WORKDIR/$P by default 
# this is not correct here
S="${WORKDIR}"

src_install()
{
	python_version
	distutils_src_install

	insinto "/usr/$(get_libdir)/python${PYVER}/site-packages"
	doins "${S}/shm_wrapper.py"
}
