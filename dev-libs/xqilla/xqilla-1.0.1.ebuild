# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit eutils

MY_P=XQilla-${PV}
DESCRIPTION="An XQuery and XPath 2 library and command line utility written in C++."
HOMEPAGE="http://xqilla.sourceforge.net/HomePage"
SRC_URI="mirror://apache/xml/xerces-c/source/xerces-c-src_2_7_0.tar.gz
	mirror://sourceforge/xqilla/${MY_P}.tar.gz"

LICENSE="Sleepycat BSD"
SLOT="0"
KEYWORDS="~x86"
IUSE="doc"

DEPEND="=dev-libs/xerces-c-2.7.0-r1
	doc? ( app-doc/doxygen )"

S="${WORKDIR}"/${MY_P}

src_unpack() {
	unpack ${A}
	cd "${S}"

	#Remove the cause of a bad rpath
	sed -i -e 's:-R$(xerces_lib)::' Makefile.in || die "Sed failed!"
}


src_compile() {
	einfo "compiling temporary copy of xerces-c"
	export XERCESCROOT="${WORKDIR}"/xerces-c-src
	cd "${XERCESCROOT}"/src/xercesc
	./runConfigure -plinux -P/usr ${EXTRA_ECONF} || die
	emake -j1 || die

	einfo "compiling xqilla"
	cd "${S}"
	econf --with-xerces="${XERCESCROOT}" || die
	emake || die
	einfo "xqilla compiled"

	if use doc; then
		emake docs || die
	fi
}

src_install () {
	emake DESTDIR="${D}" install || die

	if use doc; then
		cd docs
		dohtml -r dom3-api simple-api
	fi
}
