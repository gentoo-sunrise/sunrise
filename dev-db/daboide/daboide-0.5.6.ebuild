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
	INS=/usr/lib/python${PYVER}/site-packages/${P}

	dodoc ChangeLog

	# investigate usage of doins -r please
	# for each source directory
	for DDIR in $(find . -type d)
	do
		# if there are any files - install them
		if [ $(ls -l ${DDIR} | grep ^[-l] | wc -l) != "0" ]
		then
			insinto ${INS}/${DDIR}
			doins ${DDIR}/*
		fi

		# if we have any python files
		if [ $(ls -l ${DDIR}/*.py 2>/dev/null | wc -l) != "0" ]
		then
			# pick out those files which should be executable
			EFIL=$(grep '^#!' ${DDIR}/*.py | cut -d : -f 1)

			# and if there are any - install them
			if [ -n "${EFIL}" ]
			then
				exeinto ${INS}/${DDIR}
				doexe ${EFIL}
			fi
		fi
	done

	# Create executable
	echo '#!/bin/sh' > daboide
	echo "exec /usr/lib/python${PYVER}/site-packages/${P}/IDE.py" >> daboide
	dobin daboide
}
