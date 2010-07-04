# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=2

inherit eutils toolchain-funcs versionator

MY_PV=$(replace_all_version_separators -)
DESCRIPTION="Programs for processing ABC music notation files"
HOMEPAGE="http://abc.sourceforge.net/abcMIDI/"
SRC_URI="mirror://sourceforge/abc/abcMIDI-${MY_PV}.zip"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

S=${WORKDIR}/${PN}

src_prepare() {
	epatch "${FILESDIR}"/${PN}-2010.02.09_gentoo.patch
	rm -rf doc/programming/cvs || die
}

src_compile() {
	tc-export CC
	export LNK="${CC}"
	default
}

src_install() {
	emake DESTDIR="${D}" install prefix="/usr" docdir="share/doc/${PF}" || die "Unable to install"
	docinto programming
	dodoc doc/programming/* *.abc || die "Unable to install documentation"
}
