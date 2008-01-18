# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit eutils

DESCRIPTION="The Self-Organizing Map Program Package"
HOMEPAGE="http://www.cis.hut.fi/research/som-research/nnrc-programs.shtml"
SRC_URI="http://www.cis.hut.fi/research/${PN}/${P}.tar"

SLOT="0"
LICENSE="free-noncomm"
KEYWORDS="~x86"
IUSE=""

DEPEND=""
RDEPEND=""

src_unpack() {
	unpack ${A}
	cd "${S}"

	epatch "${FILESDIR}"/${P}_makefile_qa.diff
}

src_compile() {
	emake -f makefile.unix || die "emake failed"
}

src_test() {
	# is this really a "test"?
	emake -f makefile.unix example || die "emake examples failed"
}

src_install() {
	dobin lininit mapinit planes qerror randinit sammon umat vcal vfind visual vsom
	dodoc README
}
