# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

NEED_PYTHON=2.3

inherit distutils eutils

MY_P=PySyck-${PV}

DESCRIPTION="new Syck bindings which provide a wrapper for the Syck emitter and
give access to YAML representation graphs."
HOMEPAGE="http://pyyaml.org/"
SRC_URI="http://pyyaml.org/download/${PN}/${MY_P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~x86"
IUSE=""

DEPEND=">=dev-libs/syck-0.55"
RDEPEND="${DEPEND}"

PYTHON_MODNAME="syck"

S=${WORKDIR}/${MY_P}

pkg_setup() {
	if has_version ">=dev-libs/syck-0.55-r1" \
		&& built_with_use dev-libs/syck python ; then
		eerror "dev-libs/syck was already compiled with python bindings."
		eerror "Recompile dev-libs/syck with USE=\"-python\""
		eerror "to prevent collisions."
		die "dev-libs/syck compiled with USE=\"-python\""
	fi
}

src_test() {
	PYTHONPATH=./lib/ "${python}" tests/test_syck.py
	einfo "Some tests may have failed due to pending bugs in dev-libs/syck"
}
