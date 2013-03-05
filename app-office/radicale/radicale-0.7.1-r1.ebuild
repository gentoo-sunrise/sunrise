# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="5"
PYTHON_DEPEND="*:2.6"
SUPPORT_PYTHON_ABIS=1

inherit distutils user

MY_PN="Radicale"
MY_P="${MY_PN}-${PV}"

DESCRIPTION="A simple CalDAV calendar server"
HOMEPAGE="http://www.radicale.org/"
SRC_URI="mirror://pypi/${MY_PN:0:1}/${MY_PN}/${MY_P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="fastcgi ldap ssl"

# the '>=' goes ok, as radicale supports _all_ other python version
# this includes all 3.* versions
RDEPEND="ssl? ( >=dev-lang/python-2.6.6[ssl] )
		ldap? ( dev-python/python-ldap )
		fastcgi? ( dev-python/flup )"

# radicale's authentication against PAM is not possible here:
# Gentoo has not included the package
# also it seems old, which is bad with respect to
# http://web.nvd.nist.gov/view/vuln/detail?vulnId=CVE-2012-1502

S=${WORKDIR}/${MY_P}

RDIR=/var/lib/radicale
LDIR=/var/log/radicale

pkg_setup() {
	python_pkg_setup
	enewgroup radicale
	enewuser radicale -1 -1 ${RDIR} radicale
}

src_prepare() {
	# fix pathes
	sed -i -e "s:^\(filesystem_folder = \).*$:\1${RDIR}:g" \
				config || die
	sed -i -e "s;^\(args = ('/var/log/radicale\);\1/radicale.log;" \
				logging || die
	distutils_src_prepare
}

src_install() {
	# delete the useless .rst, so that it is not installed
	rm README.rst

	distutils_src_install

	# init file
	newinitd "${FILESDIR}"/radicale.init.d radicale || die

	# directories
	diropts -m0750
	dodir ${RDIR}; fowners radicale:radicale ${RDIR}
	dodir ${LDIR}; fowners radicale:radicale ${LDIR}

	# config file
	insinto /etc/${PN}
	doins config logging || die

	# fcgi and wsgi files
	insinto /usr/share/${PN}
	doins radicale.wsgi
	use fastcgi && doins radicale.fcgi
}

pkg_postinst() {
	einfo "Radicale now supports WSGI."
	einfo "A sample wsgi-script has been put into ${ROOT}usr/share/${PN}."
	use fastcgi && einfo "You will also find there an example fcgi-script."

	distutils_pkg_postinst
}
