# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit versionator

MY_PV=$(delete_all_version_separators)
MY_P="${PN}${MY_PV}"
DESCRIPTION="An HMM-based microbial gene finding system from TIGR"
HOMEPAGE="http://www.cbcb.umd.edu/software/glimmer/"
SRC_URI="http://www.cbcb.umd.edu/software/${PN}/${MY_P}.tar.gz"

LICENSE="Artistic"
SLOT="0"
IUSE=""
KEYWORDS="~x86"

DEPEND=""
RDEPEND=""

S=${WORKDIR}/${MY_P}

src_compile() {
	sed -i -e 's|\(set awkpath =\).*|\1 /usr/share/'${PN}'/scripts|' \
		-e 's|\(set glimmerpath =\).*|\1 /usr/bin|' scripts/* || die "failed to rewrite paths"
	cd src
	emake || die "emake failed"
}

src_install() {
	rm -f bin/test
	dobin bin/*

	insinto /usr/share/${PN}/scripts
	doins scripts/*

	dodoc glim302notes.pdf
}
