# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

NEED_PYTHON=2.4

inherit distutils

DESCRIPTION="Automates commit and QA procedures for Gentoo ebuild repositories"
HOMEPAGE="http://gentooexperimental.org/~shillelagh/"
SRC_URI="http://gentooexperimental.org/~shillelagh/${P}.tar.bz2"

LICENSE="public-domain"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="doc subversion" #"cvs doc git paludis pkgcore subversion"

DEPEND=">=app-portage/gentoolkit-dev-0.2.6.6
	>=sys-apps/portage-2.1
	subversion? ( dev-python/pysvn )"
	#cvs?        ( dev-util/cvs )
	#git?        ( dev-util/git )
	#paludis?    ( sys-apps/paludis )
	#pkgcore?    ( sys-apps/pkgcore )
RDEPEND="${DEPEND}"

src_install() {
	distutils_src_install
	insinto /etc/pusher
	doins etc/pusher.conf
	use doc && dohtml -r doc/html/*
}

pkg_postinst() {
	distutils_pkg_postinst
	ewarn "This is an alpha version, so make sure you know how to use your Subversion"
	ewarn "client's revert feature before you use Pusher. Better make backups too. ;)"
	einfo
	einfo "Plug-ins for CVS, Git, Qualudis and Pcheck aren't implemented in this version."
	einfo
	einfo "Don't forget to set appropriate values for each echangelogUser key in"
	einfo "/etc/pusher/pusher.conf."
}
