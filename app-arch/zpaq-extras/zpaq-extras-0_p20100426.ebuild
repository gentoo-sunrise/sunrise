# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit toolchain-funcs

DESCRIPTION="Extra configurations for zpaq"
HOMEPAGE="http://mattmahoney.net/dc/#zpaq"
SRC_URI="http://mattmahoney.net/dc/bwt_j3.zip
	http://mattmahoney.net/dc/bwt_slowmode1.zip
	http://mattmahoney.net/dc/bmp_j4.zip
	http://mattmahoney.net/dc/exe_j1.zip
	http://mattmahoney.net/dc/jpg_test2.zip
	http://mattmahoney.net/dc/fast.cfg"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

DEPEND="app-arch/unzip"
RDEPEND=""

src_compile() {
	tc-export CXX
	progs='bwtpre bwt_ jpeg_jo exe_jo'
	emake ${progs} || die

	sed \
		-e 's:^pcomp zpaq r:pcomp /usr/bin/zpaq r/usr/share/zpaq/:' \
		-e 's:^pcomp \([^/]\):pcomp /usr/libexec/zpaq/\1:' \
		-i *.cfg || die
}

src_install() {
	exeinto /usr/libexec/zpaq
	doexe ${progs} || die

	insinto /usr/share/zpaq
	doins *.cfg "${DISTDIR}"/fast.cfg || die
}
