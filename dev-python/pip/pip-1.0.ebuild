# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="3"

PYTHON_DEPEND="*"
SUPPORT_PYTHON_ABIS="1"

inherit bash-completion distutils eutils

DESCRIPTION="Replacement for easy_install"
HOMEPAGE="http://pip.openplans.org/ http://pypi.python.org/pypi/pip/"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="MIT"
KEYWORDS="~amd64 ~x86"
SLOT="0"
IUSE="doc bash-completion zsh-completion"

src_prepare() {
	epatch "${FILESDIR}"/${P}-unversioned.patch
	distutils_src_prepare
}

src_install() {
	distutils_src_install
	COMPLETION="${T}/completion.tmp"
	export PYTHONPATH="${S}:${PYTHONPATH}"

	if use bash-completion; then
		cd "${S}" && python pip/runner.py completion --bash > "${COMPLETION}" || die
		dobashcompletion "${COMPLETION}" ${PN}
	fi

	if use zsh-completion; then
		cd "${S}" && python pip/runner.py completion --zsh > "${COMPLETION}" || die
		insinto /usr/share/zsh/site-functions
		newins "${COMPLETION}" _pip || die
	fi

	if use doc; then
		dohtml -r docs/_build/* || die
	fi
}
