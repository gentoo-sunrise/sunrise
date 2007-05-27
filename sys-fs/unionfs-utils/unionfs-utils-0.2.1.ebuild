# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

DESCRIPTION="System Utilities for UnionFS"
HOMEPAGE="http://www.fsl.cs.sunysb.edu/project-unionfs.html"
SRC_URI="ftp://ftp.fsl.cs.sunysb.edu/pub/unionfs/unionfs-utils-0.x/${P/-/_}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="static"

DEPEND=""
RDEPEND=""

S=${WORKDIR}/${P/-/_}

src_compile() {
	# --enable-static for this package is for libraries only.
	# livecd and initrd want these in /sbin static or not,
	# whereas the package puts them in /usr/bin.
	local myconf="--bindir=/sbin --sbindir=/sbin"

	use static && myconf="--disable-shared --enable-static ${myconf}"
	econf ${myconf} || die "econf failed"

	# bundled configure and libtool are not smart enough for static
	use static && sed -i -e "s:^LDFLAGS =\(.*\):LDFLAGS = -all-static \1:g" Makefile
	emake || die "emake failed"
}

src_install () {
	make DESTDIR="${D}" install || die "make install failed"
	dodoc ChangeLog INSTALL NEWS README
}
