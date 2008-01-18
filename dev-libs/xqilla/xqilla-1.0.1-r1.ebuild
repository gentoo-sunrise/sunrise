# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit eutils

MY_P=XQilla-${PV}
DESCRIPTION="An XQuery and XPath 2 library and command line utility written in C++."
HOMEPAGE="http://xqilla.sourceforge.net/HomePage"
SRC_URI="mirror://apache/xml/xerces-c/source/xerces-c-src_2_7_0.tar.gz
	mirror://sourceforge/xqilla/${MY_P}.tar.gz
	http://www.oracle.com/technology/products/berkeley-db/xml/update/2.3.10/patch.2.3.10.1
	http://www.oracle.com/technology/products/berkeley-db/xml/update/2.3.10/patch.2.3.10.2"

LICENSE="Sleepycat BSD"
SLOT="0"
KEYWORDS="~x86"
IUSE="doc"

RDEPEND="~dev-libs/xerces-c-2.7.0"
DEPEND="${RDEPEND}
	doc? ( app-doc/doxygen )"

S="${WORKDIR}"/${MY_P}

src_unpack() {
	unpack ${A}
	cd "${S}"

	epatch "${DISTDIR}/patch.2.3.10.1"
	epatch "${DISTDIR}/patch.2.3.10.2"

	#Remove the cause of a bad rpath
	sed -i -e 's:-R$(xerces_lib)::' Makefile.in || die "sed failed!"
}

src_compile() {
	einfo "compiling temporary copy of xerces-c"
	XERCESCROOT="${WORKDIR}"/xerces-c-src
	cd "${XERCESCROOT}"/src/xercesc
	./runConfigure -plinux -P/usr ${EXTRA_ECONF} || die "configure of xerces failed"
	emake -j1 || die "emake xerces failed"

	einfo "compiling xqilla"
	cd "${S}"
	econf --with-xerces="${XERCESCROOT}" || die "econf failed"
	emake || die "emake failed"

	if use doc; then
		emake docs || die "emake docs failed"
	fi
}

src_install () {
	emake DESTDIR="${D}" install || die "emake docs failed"

	if use doc; then
		cd docs
		dohtml -r dom3-api simple-api
	fi
}
