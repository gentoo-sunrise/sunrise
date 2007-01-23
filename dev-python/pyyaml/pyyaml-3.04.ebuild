# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit distutils

MY_P=${P/pyyaml/PyYAML}

DESCRIPTION="PyYAML is a YAML parser and emitter for the Python programming language."
HOMEPAGE="http://pyyaml.org/"
SRC_URI="http://pyyaml.org/download/${PN}/${MY_P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~x86"
IUSE="examples"

DEPEND=""
RDEPEND="${DEPEND}"

S=${WORKDIR}/${MY_P}

src_install() {
	distutils_src_install
	if use examples ; then
		insinto /usr/share/pyyaml
		doins -r examples
	fi
}
