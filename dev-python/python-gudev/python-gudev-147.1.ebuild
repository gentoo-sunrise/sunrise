# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=2
PYTHON_DEPEND="*"

inherit autotools base python

DESCRIPTION="Python binding to the GUDev udev helper library"
HOMEPAGE="http://github.com/nzjrs/python-gudev"
SRC_URI="http://github.com/nzjrs/${PN}/tarball/${PV} -> ${P}.tar.gz"

LICENSE="LGPL-3"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

RDEPEND=">=sys-fs/udev-147[extras]
	dev-python/pygobject"
DEPEND="${RDEPEND}"

S=${WORKDIR}/nzjrs-${PN}-5fac65a

DOCS="AUTHORS NEWS README"

src_prepare() {
        eautoreconf
}
