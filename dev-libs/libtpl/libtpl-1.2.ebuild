# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit perl-module toolchain-funcs

DESCRIPTION="Serialize your C data quickly and easily"
HOMEPAGE="http://tpl.sourceforge.net"
SRC_URI="mirror://sourceforge/tpl/${P}.tar.bz2"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~sparc"
IUSE="perl test"

RDEPEND="perl? ( dev-lang/perl )"
DEPEND="${RDEPEND}
	test? ( dev-lang/perl )"

# Despite of being the default src_compile, it must be redefined because the
# perl-module eclass exports src_compile.
src_compile() {
	econf
	emake || die "emake failed"
}

src_test() {
	cd tests
	sed -i "/CFLAGS/s/-g/${CFLAGS}/" Makefile || die "sed cflags failed"
	# don't dump/load the tpl files on /tmp
	sed -i "s|/tmp/||g" *.c || die "sed tpl failed"
	emake -j1 CC="$(tc-getCC)" || die "emake failed"

	if use perl ; then
		cd "${S}"/lang/perl/tests
		emake || die "emake perl failed"
	fi
}

src_install() {
	emake DESTDIR="${D}" install || die "emake install failed"
	dodoc doc/txt/{examples,future,perl,userguide}.txt || die "dodoc failed"

	if use perl ; then
		perlinfo
		insinto ${SITE_LIB}
		doins lang/perl/Tpl.pm || die "doins failed"
	fi
}

pkg_postinst() {
	use perl && perl-module_pkg_postinst
}
