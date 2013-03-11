# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=3

inherit distutils

MY_PV="${PV/_beta/b}"
MY_PN="${PN/-/_}"
MY_P="${MY_PN}-${MY_PV}"

DESCRIPTION="A suite of Python packages and data for natural language processing"
HOMEPAGE="http://nltk.sourceforge.net/"
SRC_URI="mirror://sourceforge/nltk/${MY_P}.tar.gz
	!minimal? ( mirror://sourceforge/nltk/${MY_PN}-corpora-${MY_PV}.zip )
	doc? ( mirror://sourceforge/nltk/${MY_PN}-doc-${MY_PV}.zip )
	examples? ( mirror://sourceforge/nltk/${MY_PN}-examples-${MY_PV}.zip )"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="doc examples linguas_pt_BR minimal"

DEPEND="app-arch/unzip"
RDEPEND="dev-python/numpy
	dev-python/matplotlib"

S="${WORKDIR}/${MY_P}"

src_install() {
	if ! use minimal ; then
		insinto /usr/share/${MY_PN}
		doins -r "${WORKDIR}/corpora" || die
		doenvd "${FILESDIR}/99nltk-lite" || die
	fi
	if use doc ; then
		if ! use linguas_pt_BR ; then
			rm -rf "${WORKDIR}/doc/pt-br" || die
		fi
		insinto /usr/share/${MY_PN}
		doins -r "${WORKDIR}/doc" || die
	fi
	if use examples ; then
		insinto /usr/share/${MY_PN}
		doins -r "${WORKDIR}/examples" || die
	fi

	dodoc README.txt || die

	distutils_src_install
}

pkg_postinst() {
	if use minimal ; then
		elog "${PN} has been installed with the 'minimal' USE flag enabled"
		elog "This means corpora hasn't been installed, which may be needed"
		elog "for the examples and apps developed using ${PN}."
	fi
}
