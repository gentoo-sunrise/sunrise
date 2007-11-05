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
	unpack "${A}"
	epatch "${FILESDIR}"/"${P}".patch || die "cannot patch the sources"
}

src_compile() {
	emake || die "emake failed"
}

src_install() {
	dolib *.a *.so *.so."${PV}"
	insinto /usr/include
	doins parmetis.h
	dodir /usr/include/{metis,parmetis}
	insinto /usr/include/metis
	cd ./METISLib
	doins *.h
	cd ../ParMETISLib
	insinto /usr/include/parmetis
	doins *.h
	cd ../Manual
	insinto /usr/share/doc/"${P}"
	newins manual.pdf ParMetis.pdf
}
