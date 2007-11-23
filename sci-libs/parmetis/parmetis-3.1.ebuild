# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header:  $

inherit eutils

DESCRIPTION="Parallel graph partitioner"
HOMEPAGE="http://www-users.cs.umn.edu/~karypis/metis/parmetis/"
SRC_URI="http://glaros.dtc.umn.edu/gkhome/fetch/sw/parmetis/ParMetis-${PV}.tar.gz"

KEYWORDS="~amd64 ~x86"
LICENSE="free-noncomm"

SLOT="0"
IUSE="lam mpich"

DEPEND="!mpich? ( !lam? ( sys-cluster/openmpi ) )
	lam? ( sys-cluster/lam-mpi )
	mpich? ( sys-cluster/mpich2 )"
RDEPEND="${DEPEND}"

S=${WORKDIR}/ParMetis-${PV}

src_unpack() {
	unpack ${A}
	cd "${S}"
	epatch "${FILESDIR}"/${P}.patch
}

src_compile() {
	emake || die "emake failed"
}

src_install() {
	dolib *.a *.so *.so.${PV}

	insinto /usr/include
	doins parmetis.h
	insinto /usr/include/metis
	doins METISLib/*.h
	insinto /usr/include/parmetis
	doins ParMETISLib/*.h

	insinto /usr/share/doc/${PF}
	newins Manual/manual.pdf ParMetis.pdf
}
