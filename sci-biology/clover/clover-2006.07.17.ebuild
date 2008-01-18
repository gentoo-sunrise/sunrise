# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit versionator toolchain-funcs

MY_PV=$(replace_all_version_separators '-')
MY_P="${PN}-${MY_PV}"
DESCRIPTION="Cis-eLement OVERrepresentation: Detection of functional DNA motifs"
HOMEPAGE="http://zlab.bu.edu/clover/"
SRC_URI="http://zlab.bu.edu/~mfrith/downloads/${MY_P}.tar.gz
	http://zlab.bu.edu/clover/jaspar2005core"

LICENSE="as-is"
SLOT="0"
IUSE=""
KEYWORDS="~x86"

DEPEND=""
RDEPEND=""

S="${WORKDIR}/${MY_P}"

src_unpack() {
	unpack ${MY_P}.tar.gz
	sed -i "s:g++:$(tc-getCXX):; s:-Wall -O3:${CFLAGS}:" Makefile || die "sed failed"
}

src_compile() {
	emake || die "emake failed"
}

src_install() {
	dobin clover
	insinto /usr/share/${PN}
	doins "${DISTDIR}"/jaspar2005core || die "doins failed"
}

pkg_postinst() {
	elog "The motif library jaspar2005core has been installed in"
	elog "    /usr/share/clover/jaspar2005core"
	elog "You can pass this library to clover for motif search, or use your own library."
}
