# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=2

PYTHON_DEPEND=2
inherit distutils

PYTHON_MODNAME=KochMorse
MY_P=${PYTHON_MODNAME}-${PV}
DESCRIPTION="Morse-tutor for Linux using the Koch-method"
HOMEPAGE="http://code.google.com/p/kochmorse/"
SRC_URI="http://${PN}.googlecode.com/files/${MY_P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND="dev-python/pyalsaaudio
	dev-python/pygtk"

S="${WORKDIR}"/${MY_P}
