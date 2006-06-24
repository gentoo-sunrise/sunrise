# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit distutils

DESCRIPTION="An Integrated Development Environment for dabo"
HOMEPAGE="http://dabodev.com/"
SRC_URI="ftp://dabodev.com/dabo/${P}-mac-nix.tar.gz"
LICENSE="MIT"
SLOT="0"
KEYWORDS="~x86"
IUSE=""
S=${WORKDIR}/${PN}

DEPEND=""

RDEPEND=">=dev-python/wxpython-2.5.2.8
	dev-db/dabo
	dev-python/imaging
	dev-python/reportlab
	${DEPEND}"

# Prevent inherited method from trying to run setup.py
src_compile() { :; }

src_install() {
	# Install daboide into site-packages
	distutils_python_version
	INS=/usr/lib/python${PYVER}/site-packages/${PN}

	dodoc ChangeLog

	insinto ${INS}
	doins -r .

	# pick out those files which should be executable
	for EFIL in $(grep -RI '^#!' * | cut -d : -f 1)
	do
		# and if there are any - install them
		exeinto ${INS}/${EFIL%%$(basename ${EFIL})}
		doexe ${EFIL}
	done

	# Create executable
	echo '#!/bin/sh' > daboide
	echo "exec /usr/lib/python${PYVER}/site-packages/${PN}/IDE.py" >> daboide
	dobin daboide
}
