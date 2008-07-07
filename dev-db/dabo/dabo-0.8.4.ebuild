# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit distutils multilib

DESCRIPTION="A 3-tier, cross-platform application development framework written in Python/wxPython."
HOMEPAGE="http://dabodev.com/"
SRC_URI="ftp://dabodev.com/dabo/${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~x86"
IUSE="ide"

DEPEND=">=dev-python/setuptools-0.6_alpha9
	ide? ( !dev-db/daboide )"

RDEPEND=">=dev-python/wxpython-2.6.1.1
	>=dev-db/sqlite-3.0
	>=dev-python/pysqlite-2.0
	ide? ( dev-python/imaging dev-python/reportlab )"

S="${WORKDIR}/${PN}"

src_install() {
	distutils_python_version
	${python} setup.py install --root="${D}" --no-compile \
		--single-version-externally-managed "$@" \
		--install-data="/usr/$(get_libdir)/python${PYVER}/site-packages/" \
		|| die "setup.py install failed"

	dodoc ANNOUNCE AUTHORS ChangeLog README TODO

	if use ide; then
		cd "${S}/ide"
		INS="/usr/$(get_libdir)/python${PYVER}/site-packages/${PN}/ide"

		insinto ${INS}
		doins -r * || die "IDE installation failed!"

		# pick out those files which should be executable
		for EFIL in $(grep -RI '^#!' * | cut -d : -f 1 | grep -iv '\.txt$')
		do
			# and if there are any - install them
			exeinto "${INS}/$(dirname ${EFIL})"
			doexe "${EFIL}"
		done
	fi
}
