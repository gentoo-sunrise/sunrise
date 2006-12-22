# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit distutils

MY_PV="${PV/_beta/b}"
MY_PN="${PN/-/_}"
MY_P="${MY_PN}-${MY_PV}"

DESCRIPTION="A suite of Python packages and data for natural language processing"
HOMEPAGE="http://nltk.sourceforge.net/"
SRC_URI="mirror://sourceforge/nltk/${MY_P}.tar.gz
	!lite? ( mirror://sourceforge/nltk/${MY_PN}-corpora-${MY_PV}.zip )
	doc? ( mirror://sourceforge/nltk/${MY_PN}-doc-${MY_PV}.zip )
	examples? ( mirror://sourceforge/nltk/${MY_PN}-examples-${MY_PV}.zip )"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86"
IUSE="doc examples linguas_pt_BR lite"

DEPEND=""
RDEPEND="dev-python/numpy"

S="${WORKDIR}/${MY_P}"

src_install() {
	if ! use lite ; then
		ebegin "Installing corpora"
		insinto /usr/share/${MY_PN}
		doins -r "${WORKDIR}/corpora"
		doenvd "${FILESDIR}/99nltk-lite"
		eend 0
	fi
	if use doc ; then
		ebegin "Installing doc"
		if ! use linguas_pt_BR ; then
			rm -rf "${WORKDIR}/doc/pt-br"
		fi
		insinto /usr/share/${MY_PN}
		doins -r "${WORKDIR}/doc"
		eend 0
	fi
	if use examples ; then
		insinto /usr/share/${MY_PN}
		doins -r "${WORKDIR}/examples"
	fi

	dodoc README.txt

	distutils_src_install
}

pkg_postinst() {
	if use lite ; then
		elog "${PN} has been installed with the 'lite' USE flag enabled"
		elog "This means corpora hasn't been installed, which may be needed"
		elog "for the examples and apps developed using ${PN}."
	fi
}
