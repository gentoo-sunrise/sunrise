# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit eutils autotools

MYP=ParMGridGen-${PV}

DESCRIPTION="Software for parallel (mpi) generating coarse grids"
HOMEPAGE="http://www-users.cs.umn.edu/~moulitsa/software.html"
SRC_URI="http://www-users.cs.umn.edu/~moulitsa/download/${MYP}.tar.gz"

KEYWORDS="~amd64 ~x86"
LICENSE="as-is"
SLOT="0"
IUSE=""

DEPEND="virtual/mpi"

S=${WORKDIR}/${MYP}

pkg_setup(){
	export CC=mpicc
}

src_unpack() {
	unpack ${A}
	cd "${S}"
	epatch "${FILESDIR}"/${P}-autotools.patch
	eautoreconf
}

src_install() {
	emake DESTDIR="${D}" install || die "emake install failed"
	dodoc README
	dodoc Doc/*.pdf
}
