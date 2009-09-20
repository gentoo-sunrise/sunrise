# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit multilib toolchain-funcs

MY_P="${PN}${PV/./}"
DESCRIPTION="Unified compressor for PAQ algorithms"
HOMEPAGE="http://mattmahoney.net/dc/#zpaq"
SRC_URI="http://mattmahoney.net/dc/${MY_P}.zip"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="doc"

src_compile() {
	# Upstream doesn't provide any Makefile

	"$(tc-getCXX)" ${CXXFLAGS} zpaq104.cpp -o zpaq || die 'compiling zpaq failed'
	"$(tc-getCXX)" ${CXXFLAGS} unzpaq103.cpp -o unzpaq || die 'compiling unzpaq failed'

	# SFX part is upstream-broken
#	"$(tc-getCXX)" ${CXXFLAGS} zpaqsfx.cpp -o zpaqsfx || die 'compiling zpaqsfx failed'

#	cat zpaqsfx.tag >> zpaqsfx || die 'appending tag to zpaqsfx failed'
}

src_install() {
	dobin zpaq unzpaq || die 'dobin failed'

	dodoc readme.txt || die 'dodoc failed'
	if use doc; then
		dodoc zpaq100.pdf || die 'dodoc failed'
	fi

#	exeinto /usr/$(get_libdir)/zpaq
#	doexe zpaqsfx || die 'doexe failed'

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
#	elog
#	elog "zpaq SFX stub is installed in /usr/$(get_libdir)/zpaq. You can use it"
#	elog "to create SFX archives like that:"
#	elog "	cp /usr/$(get_libdir)/zpaq/zpaqsfx sfxarchive
#	elog "	zpaq c sfxarchive ..."
}
