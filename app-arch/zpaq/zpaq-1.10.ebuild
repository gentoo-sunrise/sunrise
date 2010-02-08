# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="2"

inherit multilib toolchain-funcs

MY_P="${PN}${PV/./}"
DESCRIPTION="Unified compressor for PAQ algorithms"
HOMEPAGE="http://mattmahoney.net/dc/#zpaq"
SRC_URI="http://mattmahoney.net/dc/${MY_P}.zip"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="optimization"

DEPEND="app-arch/unzip"
RDEPEND=""

src_prepare() {
	# make it FHS-friendly
	sed -e 's:^pcomp :&/usr/libexec/zpaq/:' -i *.cfg || die

	if use optimization; then
		sed \
			-e "s:%CXX%:$(tc-getCXX):" \
			-e "s:%CXXFLAGS%:${CXXFLAGS}:" \
			-e "s:%LIBDIR%:$(get_libdir):" \
			"${FILESDIR}"/zpaqmake.in > zpaqmake || die
	fi
}

src_configure() {
	tc-export CXX

	if use optimization; then
		# NOTE: zpaqmake is used in runtime by zpaq to compile profiles
		# please do not complain about stripping, it's not for build time

		local stripflag=' -Wl,--strip-all'
		# check whether the default compiler supports -Wl,--strip-all
		echo 'int main(void) {return 0;}' > striptest.c
		"${CXX}" ${CXXFLAGS} ${LDFLAGS} ${stripflag} \
			striptest.c -o striptest || stripflag=

		sed -i -e "s:%LDFLAGS%:${LDFLAGS}${stripflag}:" zpaqmake || die
	fi
}

src_compile() {
	"${CXX}" ${CXXFLAGS} -DNDEBUG ${LDFLAGS} zpaq.cpp -o zpaq || die
	"${CXX}" ${CXXFLAGS} ${LDFLAGS} lzppre.cpp -o lzppre || die

	if use optimization; then
		# provide precompiled stub
		"${CXX}" -c ${CXXFLAGS} -DNDEBUG -DOPT zpaq.cpp -o zpaq.o || die
	fi
}

src_install() {
	dobin zpaq || die
	dodoc readme.txt || die

	if use optimization; then
		dobin zpaqmake || die
		insinto /usr/include/zpaq
		doins zpaq.h || die
		insinto /usr/$(get_libdir)/zpaq
		doins zpaq.o || die
	fi

	# Preprocessors
	exeinto /usr/libexec/zpaq
	doexe lzppre || die

	# These are more like compression profiles, so install them in /usr/share
	insinto /usr/share/zpaq
	doins *.cfg || die
}

pkg_postinst() {
	elog "Unlike conventional archivers, zpaq doesn't have any algorithm chain"
	elog "compiled in by default. Instead, it provides many PAQ components to allow"
	elog "user to create his own chain and supply it as configuration file."
	elog
	elog "We install few default configs in /usr/share/zpaq to start with. They can"
	elog "be used like that:"
	if use optimization; then
		elog "	zpaq oc/usr/share/zpaq/max.cfg out.zpaq files"
	else
		elog "	zpaq c/usr/share/zpaq/max.cfg out.zpaq files"
	fi
	elog
	elog "You may also want to install app-arch/zpaq-extras package which provides"
	elog "few additional configs and preprocessors for use with zpaq."
}
