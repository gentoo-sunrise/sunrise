# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

WANT_AUTOCONF="latest"
WANT_AUTOMAKE="latest"
inherit autotools

KEYWORDS="~x86"

MY_P=${P/lib}

DESCRIPTION="A YAML 1.1 parser and emitter written in C."
HOMEPAGE="http://pyyaml.org/wiki/LibYAML"
SRC_URI="http://pyyaml.org/download/${PN}/${MY_P}.tar.gz"
LICENSE="MIT"
SLOT="0"
IUSE="examples"

DEPEND=""
RDEPEND=""

S="${WORKDIR}/${MY_P}"

src_unpack() {
	unpack ${A}
	cd "${S}"
	if ! hasq test ${FEATURES} ; then
		sed -i \
			-e 's/tests//' \
			Makefile.am || die "sed failed"
		eautoreconf
	fi
}

src_install() {
	emake DESTDIR="${D}" install || die "emake install failed"
	dohtml -r doc/html/*
	dodoc README
	if use examples ; then
		insinto /usr/share/${PN}/examples
		doins tests/example-*.c
	fi
}
