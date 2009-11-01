# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit toolchain-funcs

MY_P="${PN}${PV/./}"
DESCRIPTION="Unified compressor for PAQ algorithms"
HOMEPAGE="http://mattmahoney.net/dc/#zpaq"
SRC_URI="http://mattmahoney.net/dc/${MY_P}.zip"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND="app-arch/unzip"
RDEPEND=""

src_compile() {
	# Upstream doesn't provide any Makefile

	# -DOPT is broken (at least) on Linux
	"$(tc-getCXX)" ${CXXFLAGS} -DNDEBUG zpaq.cpp -o zpaq || die 'compiling zpaq failed'
	"$(tc-getCXX)" ${CXXFLAGS} lzppre.cpp -o lzppre || die 'compiling lzppre failed'

	sed -e 's:^pcomp :&/usr/libexec/zpaq/:' -i *.cfg || die 'sed failed'
}

src_install() {
	dobin zpaq || die 'dobin failed'

	dodoc readme.txt || die 'dodoc failed'

	# Preprocessors
	exeinto /usr/libexec/zpaq
	doexe lzppre || die 'doexe failed'

	# These are more like compression profiles, so install them in /usr/share
	insinto /usr/share/zpaq
	doins *.cfg || die 'doins failed'
}

pkg_postinst() {
	elog "Unlike conventional archivers, zpaq doesn't have any algorithm chain"
	elog "compiled in by default. Instead, it provides many PAQ components to allow"
	elog "user to create his own chain and supply it as configuration file."
	elog
	elog "We install few default configs in /usr/share/zpaq to start with. They can"
	elog "be used like that:"
	elog "	zpaq c/usr/share/zpaq/max.cfg out.zpaq files"
	elog
	elog "You may also want to install app-arch/zpaq-extras package which provides"
	elog "few additional configs and preprocessors for use with zpaq."
}
