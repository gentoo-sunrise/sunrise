# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit kde-functions qt4

MY_P="libQGLViewer-"${PV}

DESCRIPTION="Simple 3D viewer class for Qt OpenGL applications"
HOMEPAGE="http://www.libqglviewer.com"
SRC_URI="http://www.libqglviewer.com/src/${MY_P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="doc"

RDEPEND="virtual/opengl
	>=x11-libs/qt-4.3"

S="${WORKDIR}"/${MY_P}

src_compile() {
	set-qtdir 4
	cd QGLViewer
	eqmake4 QGLViewer.pro -o Makefile \
		PREFIX=/usr || die "qmake QGLViewer failed"
	emake || die "emake QGLViewer failed"

	cd ../designerPlugin
	eqmake4 designerPlugin.pro -o Makefile \
		INCLUDE_DIR=.. \
		LIB_DIR=../QGLViewer || die "qmake designerPlugin failed"
	emake || die "emake designerPlugin failed"
}

src_install() {
	cd QGLViewer
	INSTALL_ROOT="${D}" emake install_target install_include || die "install QGLViewer failed"

	cd ../designerPlugin
	INSTALL_ROOT="${D}" emake install_target || die "install QGLViewer failed"

	dodoc ../README

	if use doc ; then
		dohtml -r ../doc/*
		insinto /usr/share/doc/${PF}
		doins -r ../examples
	fi
}
