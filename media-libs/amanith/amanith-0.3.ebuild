# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit eutils toolchain-funcs

KEYWORDS="~amd64 ~x86"

DESCRIPTION="Crossplatform & Opensource C++ Vector Graphic Framework"
HOMEPAGE="http://www.amanith.org/blog/index.php"
SRC_URI="http://www.amanith.org/download/files/${PN}_${PV/./}.tar.gz"
LICENSE="QPL"
SLOT="0"
IUSE="examples qt4"

DEPEND=">=media-libs/freetype-2.1.10
		>=media-libs/jpeg-6b
		>=media-libs/libpng-1.2.10
		>=sys-libs/zlib-1.2.3
		qt4? ( >=x11-libs/qt-4.1.0 )
		!qt4? ( =x11-libs/qt-3* )"
RDEPEND="${DEPEND}"

S=${WORKDIR}/${PN}

src_unpack() {
	unpack ${A}

	epatch "${FILESDIR}/${PV}-plugins_dep.patch"
	epatch "${FILESDIR}/${PV}-examples_gcc4.patch"

	# We don't have to build the 3rd-party libs, they're provided by the deps
	rm -rf "${S}/3rdpart"
	sed -i -e 's/3rdpart//' "${S}/amanith.pro"

	if use qt4; then
		sed -i -e 's/# DEFINES += USE_QT4/DEFINES += USE_QT4/' "${S}/config/settings.conf"
	fi

	if ! use examples; then
		sed -i -e 's/examples//' "${S}/amanith.pro"
	fi

}

src_compile() {
	export AMANITHDIR="${S}"
	if ! use qt4; then
		export QTDIR="/usr/qt/3"
		PATH="${QTDIR}/bin:${PATH}"
	fi
	qmake || die "qmake failed"
	emake CXX=$(tc-getCXX) || die "emake failed"
}

src_install() {
	dolib.so lib/*.so*
	dolib.so plugins/*.so*

	insinto /usr/include
	doins -r include/amanith

	dodoc CHANGELOG FAQ README
	insinto "/usr/share/doc/${PF}"
	doins "doc/amanith.chm"

	if use examples; then
		# remove the object files
		find ./examples -iname "*.o" -delete

		insinto "/usr/share/${PN}"
		doins -r examples data config
	fi
}
