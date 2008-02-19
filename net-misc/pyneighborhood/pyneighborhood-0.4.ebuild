# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

MY_P="${P/n/N}"

DESCRIPTION="GTK+ 2 rewrite of LinNeighborhood"
HOMEPAGE="http://pyneighborhood.sourceforge.net/"
SRC_URI="mirror://sourceforge/pyneighborhood/${MY_P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86"
IUSE=""

RDEPEND="net-fs/mount-cifs
	=dev-python/pygtk-2*"

S="${WORKDIR}/${MY_P}"

src_compile() {
	./configure --prefix=/usr || die "./configure failed" # Not a standard configure script
}

src_install() {
	emake DESTDIR="${D}" install || die "emake install failed"
}
