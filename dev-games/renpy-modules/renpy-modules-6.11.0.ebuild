# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="2"
PYTHON_DEPEND="2:2.5"

inherit distutils eutils

MY_P=${PN%-modules}-${PV}
PYTHON_MODNAME="pysdlsound"

DESCRIPTION="Modules for renpy"
HOMEPAGE="http://www.renpy.org"
SRC_URI="http://www.renpy.org/dl/${PV}/${MY_P}-source.tar.bz2"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND="media-libs/libpng
	media-libs/libsdl
	media-libs/freetype:2
	media-video/ffmpeg
	dev-libs/fribidi
	dev-python/pygame[X]
	sys-libs/zlib
	!=dev-games/renpy-6.10.2"
RDEPEND="${DEPEND}"

S="${WORKDIR}/${MY_P}/module"

# RENPY_DEPS_INSTALL is a double-colon separated list of directories that
# contains all core renpy dependencies. This is usually /usr.
export RENPY_DEPS_INSTALL="${ROOT}usr"
