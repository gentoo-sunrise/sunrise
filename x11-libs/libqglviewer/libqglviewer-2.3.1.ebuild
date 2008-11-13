# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit qt4

MY_P="libQGLViewer-"${PV}

DESCRIPTION="Simple 3D viewer class for Qt OpenGL applications"
HOMEPAGE="http://www.libqglviewer.com"
SRC_URI="http://www.libqglviewer.com/src/${MY_P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="doc"

DEPEND="virtual/opengl
	>=x11-libs/qt-4.3"

S=${WORKDIR}/${MY_P}/QGLViewer

src_compile() {
	eqmake4 QGLViewer.pro -o Makefile PREFIX=/usr
	emake || die "emake QGLViewer failed"

	cd ../designerPlugin
	eqmake4 designerPlugin.pro -o Makefile \
		INCLUDE_DIR=.. \
		LIB_DIR=../QGLViewer
	emake || die "emake designerPlugin failed"
}

src_install() {
	INSTALL_ROOT="${D}" emake install_target install_include || die "install QGLViewer failed"

	cd ../designerPlugin
	INSTALL_ROOT="${D}" emake install_target || die "install QGLViewer failed"

	dodoc ../README || die "installing README failed"

	if use doc ; then
		dohtml -r ../doc/* || die "installing html files failed"
		insinto /usr/share/doc/${PF}
		doins -r ../examples || die "installing examples failed"
	fi
}
