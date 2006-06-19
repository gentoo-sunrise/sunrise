# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit eutils qt4

MVER="${PV/_*/}"
SVER="${PV/*_/}"
MY_P="${PN}-${MVER}-${SVER}"

DESCRIPTION="Qt Cryptographic Architecture (QCA)"
HOMEPAGE="http://delta.affinix.com/qca/"
SRC_URI="http://delta.affinix.com/download/qca/${MVER}/${SVER}/${MY_P}.tar.bz2"

LICENSE="GPL-2"
SLOT="2"
KEYWORDS="~x86 ~amd64"
IUSE="debug doc ssl"

RDEPEND="$(qt_min_version 4.1.0)"

DEPEND="${RDEPEND}
	doc? ( app-doc/doxygen )"

S="${WORKDIR}/${MY_P}"

src_unpack() {
	unpack ${A}

	cd ${S}
	epatch ${FILESDIR}/${PN}-allow_slotting.patch
}

src_compile() {
	local myconf=""
	local qmyconf="CONFIG += no_fixpath"

	# check wheter qt was build with debug use flag
	if ! built_with_use qt debug || ! use debug; then
		myconf="${myconf} --disable-tests"
		qmyconf="${qmyconf} release"
	else
		myconf="${myconf} --enable-debug"
		qmyconf="${qmyconf} debug"
	fi

	QTDIR="/usr/lib" \
		./configure \
		--prefix=/usr \
		${myconf} \
		|| die "configure failed"

	qmake \
		QMAKE_CFLAGS_RELEASE="${CFLAGS}" \
		QMAKE_CXXFLAGS_RELEASE="${CXXFLAGS}" \
		QMAKE_RPATH= \
		QTDIR="/usr/lib" \
		"${qmyconf}" \
		${PN}.pro \
		|| die "qmake failed"

	make || die "make failed"

	use doc && doxygen
}

src_install() {
	make INSTALL_ROOT="${D}" install || die "make install failed"
	if [ "$(get_libdir)" != "lib" ]; then
		mv ${D}/usr/lib ${D}/usr/$(get_libdir)
	fi

	dodoc README TODO

	if use doc; then
		insinto /usr/share/doc/${PF}/doxydoc
		doins ${S}/apidocs/html/*
	fi
}
