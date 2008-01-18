# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit distutils multilib

DESCRIPTION="An Integrated Development Environment for dabo"
HOMEPAGE="http://dabodev.com/"
SRC_URI="ftp://dabodev.com/dabo/${P}-mac-nix.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~x86"
IUSE=""

DEPEND=""
RDEPEND=">=dev-python/wxpython-2.6.1.1
	>=dev-db/dabo-0.7.2
	dev-python/imaging
	dev-python/reportlab
	${DEPEND}"

S="${WORKDIR}/${PN}"

# Prevent inherited method from trying to run setup.py
src_compile() { :; }

src_install() {
	# Install daboide into site-packages
	distutils_python_version
	INS=/usr/$(get_libdir)/python${PYVER}/site-packages/${PN}

	dodoc ChangeLog

	insinto ${INS}
	doins -r *

	# pick out those files which should be executable
	for EFIL in $(grep -RI '^#!' * | cut -d : -f 1 | grep -iv '\.txt$')
	do
		# and if there are any - install them
		exeinto "${INS}/${EFIL%%$(basename ${EFIL})}"
		doexe "${EFIL}"
	done

	# Create executable
	echo '#!/bin/sh' > daboide
	echo "exec ${INS}/IDE.py" >> daboide
	dobin daboide
}
