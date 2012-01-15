# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="4"

inherit eutils

MY_PN="psd"
DESCRIPTION="Symlinks and syncs browser profile dirs to RAM thus reducing HDD/SDD calls and speeding-up browsers"
HOMEPAGE="https://wiki.archlinux.org/index.php/Profile-sync-daemon"
SRC_URI="http://repo-ck.com/source/${PN}/${P}.tar.xz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND="app-arch/xz-utils"
RDEPEND="net-misc/rsync"

src_prepare() {
	# fix manpage/readme for proper gentoo instructions
	epatch "${FILESDIR}"/${MY_PN}-manreadme.patch
	# fix script to work with our daemon
	epatch "${FILESDIR}"/${MY_PN}-pid.patch
}

src_install() {
	# install script
	dobin ${PN}

	# install conf
	insinto /etc
	doins ${MY_PN}.conf

	# install optional cronjob
	insinto /usr/share/${PN}
	doins "${FILESDIR}"/cronjob

	# install our daemon
	newinitd "${FILESDIR}"/daemon ${MY_PN}

	# manpage, readme
	newdoc README* README
	dodoc CHANGELOG
	newman ${MY_PN}.manpage ${PN}.1
}

pkg_postinst() {
	elog "For adding a cronjob use the file"
	elog "/usr/share/${PN}/cronjob"
}
