# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

DESCRIPTION="System of hooks for portage"
HOMEPAGE="http://www.salug.it/~sydro/progetti/"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86"
IUSE=""

src_install() {
	insinto /etc/portage
	doins "${FILESDIR}/portage-hooks" || die "Error copy portage-hooks into /etc/portage directory"
}

pkg_postinst() {
	elog "You must create a directory in /etc/portage/hooks with ebuild phase name."
	elog "Es. EBUILD_PHASE=preinst  The directory should be /etc/portage/hooks/preinst.d"
	elog "In each directory there are any numbered scripts:  10example 20example"
	elog
	elog  "If you would use portage-hooks system you need to append the"
	elog  "following statement to your"
	elog  "/etc/portage/bashrc file:"
	elog
	elog  "source /etc/portage/portage-hooks"
	elog
}
