# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=2

PYTHON_DEPEND="2"

inherit python distutils

MY_P="BlockHosts-${PV}"
DESCRIPTION="Blocks abusive IP hosts which probe your services (such as sshd, proftpd)"
HOMEPAGE="http://www.aczoom.com/cms/blockhosts/"
SRC_URI="http://www.aczoom.com/tools/${PN}/${MY_P}.tar.gz"

LICENSE="public-domain"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="logrotate logwatch test"

DEPEND="dev-python/pyxml"
RDEPEND="${DEPEND}
	logrotate? ( app-admin/logrotate )"

S=${WORKDIR}/${MY_P}

pkg_setup() {
	python_pkg_setup
}

src_prepare() {
	python_convert_shebangs -r 2 .

	# don't let setup.py install bhrss.py to /usr/bin
	sed -i -e "s/,.*bhrss\.py'//" setup.py || die

	# remove logrotate check if not in IUSE
	if ! use logrotate; then
		sed -i -e "/^if/d ; /DATA_FILES\./d" setup.py || die
	fi

	distutils_src_prepare
}

src_test() {
	$(PYTHON) test_blockhosts.py || die
}

src_install() {
	distutils_src_install

	exeinto $(python_get_sitedir)
	doexe ${PN}.py || die

	dosym $(python_get_sitedir)/${PN}.py /usr/bin/${PN}.py || die

	exeinto /usr/share/${PN}
	doexe bhrss.py || die

	# not tested, but should work
	if use logwatch; then
		insinto /etc/log.d/conf/services/
		doins logwatch/blockhosts.conf || die

		exeinto /etc/log.d/scripts/services/
		doexe logwatch/blockhosts || die
	fi

	dohtml *.html || die
}

pkg_postinst() {
	echo
	elog "This package isn't configured properly."
	elog "Please refer to the homepage to do this!"
	echo
	elog "See also: http://www.gentoo-wiki.info/BlockHosts"
	echo
	elog "bhrss.py cgi-script is in /usr/share/${PN}."
	elog "If you want to use it, put it in your cgi-bin,"
	echo
}
