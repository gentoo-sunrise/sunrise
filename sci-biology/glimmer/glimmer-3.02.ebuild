# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit versionator

MY_P=glimmer${PV}
MY_PV=$(delete_all_version_separators)

DESCRIPTION="An HMM-based microbial gene finding system from TIGR"
HOMEPAGE="http://www.cbcb.umd.edu/software/glimmer/"
SRC_URI="http://www.cbcb.umd.edu/software/glimmer/glimmer${MY_PV}.tar.gz"

LICENSE="glimmer"
SLOT="0"
IUSE=""
KEYWORDS="~x86"

DEPEND=""
RDEPEND=""

S=${WORKDIR}/${MY_P}

src_compile() {
	sed -i -e 's|\(set awkpath =\).*|\1 /usr/share/'${PN}'/scripts' \
		-e 's|\(set glimmerpath =\).*|\1 /usr/bin' scripts/*
	cd src
	emake || die "emake failed"
}

src_install() {
	dobin bin/{anomaly,build-icm,entropy-score,glimmer3,multi-extract,start-codon-distrib,uncovered,build-fixed,entropy-profile,extract,long-orfs,score-fixed,window-acgt}

	dodir /usr/share/${PN}/scripts
	insinto /usr/share/${PN}/scripts
	doins scripts/*

	dodoc glim302notes.pdf
}
