# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit distutils eutils multilib

DESCRIPTION="Medical software application"
HOMEPAGE="http://www.gnumed.org/"
SRC_URI="http://download.savannah.gnu.org/releases/${PN}/GNUmed-client.${PV}.tgz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86"
IUSE=""

DEPEND=""

RDEPEND="dev-lang/python
	dev-python/egenix-mx-base
	dev-python/pypgsql
	dev-python/wxpython"

S="${WORKDIR}/GNUmed-${PV}"

PYTHON_MODNAME="Gnumed"

src_unpack() {
	unpack ${A}
	cd "${S}"
	epatch "${FILESDIR}/gnumed-0.1-gnumed.patch"
}

src_compile() {
	distutils_python_version
	cd "${S}"
	sed -i -e "s@usr/lib/python@usr/$(get_libdir)/python${PYVER}@g" client/usr/bin/gnumed
}

src_install() {
	distutils_python_version
	dobin client/usr/bin/gnumed
	insinto /usr/share
	doins -r client/usr/share/gnumed
	insinto /usr/$(get_libdir)/python${PYVER}
	doins -r client/usr/lib/python/site-packages

	insinto /etc/gnumed
	doins client/etc/gnumed/*.conf

	dohtml client/usr/share/doc/gnumed/client/user-manual/*.html
	dohtml client/usr/share/doc/gnumed/medical_knowledge/de/STIKO/STI_NEU.htm
	docinto examples
	dodoc client/etc/gnumed/*.conf
}
