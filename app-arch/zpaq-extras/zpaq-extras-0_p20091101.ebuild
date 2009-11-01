# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit toolchain-funcs

DESCRIPTION="Extra configurations for zpaq"
HOMEPAGE="http://mattmahoney.net/dc/#zpaq"
SRC_URI="http://mattmahoney.net/dc/bwt_j3.zip
	http://mattmahoney.net/dc/bwt_slowmode1.zip
	http://mattmahoney.net/dc/bmp_j4.zip
	http://mattmahoney.net/dc/exe_j1.zip
	http://mattmahoney.net/dc/jpg_test2.zip"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

DEPEND="app-arch/unzip"
RDEPEND=""

src_compile() {
	local _prog

	mkdir bin
	for _prog in bwtpre bwt_ jpeg_jo exe_jo; do
		"$(tc-getCXX)" ${CXXFLAGS} ${_prog}.cpp -o bin/${_prog} \
			|| die "compiling ${_prog} failed"
	done

	sed \
		-e 's:^pcomp zpaq r:pcomp /usr/bin/zpaq r/usr/share/zpaq/:' \
		-e 's:^pcomp \([^/]\):pcomp /usr/libexec/zpaq/\1:' \
		-i *.cfg || die 'sed failed'
}

src_install() {
	exeinto /usr/libexec/zpaq
	doexe bin/* || die 'dobin failed'

	insinto /usr/share/zpaq
	doins *.cfg || die 'doins failed'
}
