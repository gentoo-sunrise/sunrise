# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit multilib

MY_PN=FreeImage
MY_PV=${PV//./}
MY_P=${MY_PN}${MY_PV}

DESCRIPTION="A library project for developers who would like to support popular graphics image formats."
HOMEPAGE="http://sourceforge.net/projects/freeimage"
SRC_URI="mirror://sourceforge/freeimage/${MY_P}.zip
	doc? ( mirror://sourceforge/freeimage/${MY_P}.pdf )"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86 ~amd64"
IUSE="doc mmx plus"

DEPEND=""
RDEPEND=""

S="${WORKDIR}/${MY_PN}"

src_unpack() {
	unpack ${A}
	cd ${S}
	epatch "${FILESDIR}"/freeimage-3.9.3-make.patch
}

src_compile() {
	if ! use mmx; then
		 CFLAGS="${CFLAGS} -DPNG_NO_ASSEMBLER_CODE -DPNG_NO_MMX_CODE"
		 CXXFLAGS="${CXXFLAGS} -DPNG_NO_ASSEMBLER_CODE -DPNG_NO_MMX_CODE"
	fi
	emake || die
	if use plus; then
		emake -f Makefile.fip || die
	fi
}

src_install() {
	dodoc README.* Whatsnew.txt

	if use doc; then
		dodoc ${WORKDIR}/${MY_P}.pdf
	fi
	if use plus; then
		dodoc Wrapper/FreeImagePlus/WhatsNew_FIP.txt
	fi
	dolib.so Dist/*.so
	dolib.a Dist/*.a
	dosym /usr/$(get_libdir)/libfreeimage-${PV}.so /usr/$(get_libdir)/libfreeimage.so
	insinto /usr/include
	doins Dist/*.h
}
