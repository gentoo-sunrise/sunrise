# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

NEED_PYTHON=2.3

inherit distutils

MY_P="BlockHosts-${PV}"
DESCRIPTION="Blocks abusive IP hosts which probe your services (such as sshd, proftpd)"
HOMEPAGE="http://www.aczoom.com/cms/blockhosts/"
SRC_URI="http://www.aczoom.com/tools/blockhosts/${MY_P}.tar.gz"

LICENSE="public-domain"
SLOT="0"
KEYWORDS="~x86"
IUSE="logrotate logwatch"

DEPEND=""
RDEPEND="logrotate? ( app-admin/logrotate )"

DOCS="CHANGES"
S=${WORKDIR}/${MY_P}

src_unpack() {
	unpack ${A}
	cd "${S}"

	# don't let setup.py install bhrss.py to /usr/bin
	sed -i \
		-e "s/,.*bhrss\.py'//" \
		setup.py || die "sed failed"

	# remove logrotate check if not in IUSE
	if ! use logrotate; then
		sed -i \
			-e "/^if/d" \
			-e "/DATA_FILES\./d" \
			setup.py || die "sed failed"
	fi
}

src_install() {
	distutils_src_install

	insinto /usr/share/${PN}
	doins bhrss.py
	# keep the test script
	doins test_blockhosts.py

	dohtml *.html

	# not tested, but should work
	if use logwatch; then
		insinto /etc/log.d/conf/services/
		doins logwatch/blockhosts.conf

		exeinto /etc/log.d/scripts/services/
		doexe logwatch/blockhosts
	fi
}

pkg_postinst() {
	echo
	elog "This package isn't configured properly."
	elog "Please refer to the homepage to do this!"
	echo
	elog "See also: http://gentoo-wiki.com/HOWTO_BlockHosts"
	echo
	elog "bhrss.py cgi-script is in /usr/share/${PN}."
	elog "If you want to use it, put it in your cgi-bin,"
	elog "emerge dev-python/pyxml and copy blockhosts.py"
	elog "into your python module directory."
	echo
}
