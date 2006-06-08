# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-python/pyode/pyode-1.1.0.ebuild,v 1.3 2005/10/22 05:57:17 vapier Exp $

inherit distutils

MY_P=${P/pyode/PyODE}
DESCRIPTION="python bindings to the ode physics engine"
HOMEPAGE="http://pyode.sourceforge.net/"
SRC_URI="mirror://sourceforge/pyode/${MY_P}.tar.bz2"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="~amd64 ~ppc x86"
IUSE=""

DEPEND="virtual/python
	>=dev-games/ode-0.5
	>=dev-python/pyrex-0.9.3"

S=${WORKDIR}/${MY_P}

src_unpack() {
	unpack ${A}
	cd "${S}"
	sed -i \
		-e "s:#ODE_BASE = .*:ODE_BASE = '/usr/share/ode-0.5':" \
		setup.py || die

	# Fixes gcc41 compatibilty
	# If using ~x86 tree, files will be regenerated with pyrex(>=0.9.4.1)
	# which is compatible with gcc 4.1
	rm ode_notrimesh.c ode_trimesh.c
}

src_install() {
	distutils_src_install
	# The build system doesnt error if it fails to build
	# the ode library so we need our own sanity check
	[[ -z $(find "${D}" -name ode.so) ]] && die "failed to build/install :("
}
