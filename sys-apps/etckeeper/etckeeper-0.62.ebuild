# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=4

inherit eutils bash-completion-r1 python

DESCRIPTION="a collection of tools to let /etc be stored in a repository"
HOMEPAGE="http://kitenet.net/~joey/code/etckeeper/"
COMMIT="40eeedebb6be23035aea9d15aed1be706479ce79"
SRC_URI="http://git.kitenet.net/?p=etckeeper.git;a=snapshot;h=${COMMIT};sf=tgz
-> ${P}.tar.gz"

LICENSE="GPL-2"
IUSE="bazaar"
KEYWORDS="~amd64"
SLOT="0"

DEPEND="bazaar? ( || ( dev-lang/python:2.7 dev-lang/python:2.6 ) )"
RDEPEND="app-portage/portage-utils
	bazaar? ( dev-vcs/bzr )"

S="${WORKDIR}"/${PN}-${COMMIT:0:7}

SHAREDIR="/usr/share/${PN}"

src_prepare(){
	epatch "${FILESDIR}"/${P}-gentoo.patch
	if use bazaar; then
		python_convert_shebangs 2 "${S}"/etckeeper-bzr/__init__.py
	fi
}
src_compile(){
	if use bazaar; then
		emake
	fi
}
src_install(){
	emake DESTDIR="${D}" install
	newbashcomp bash_completion etckeeper
	if use bazaar; then
		./etckeeper-bzr/__init__.py install --root="${D}" || die "Error: bzr support installation"
	fi
	insinto ${SHAREDIR}
	doins "${FILESDIR}"/bashrc
}
pkg_postinst(){
	elog "You need to use either bzr, git or mercurial."
	elog "If you want dev-vcs/bzr, enable bzr useflag."
	elog "Run this command to add etckeeper to your /etc/portage/bashrc"
	elog ""
	elog "echo \"source ${SHAREDIR}/bashrc\" >> /etc/portage/bashrc"
	elog ""
	elog "or just put the content with your fancy feature additions into it directly"
	elog "Remember to fit /etc/etckeeper/etckeeper.conf to your needs!"
	elog "To initialise your etc-dir as a repository run:"
	elog ""
	elog "etckeeper init -d /etc"
	elog ""
}
