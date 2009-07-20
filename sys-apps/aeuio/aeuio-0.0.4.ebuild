# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="0"
inherit base

DESCRIPTION="Make an initramfs/initrd with root on crypto, lvm, mdadm, etc."
HOMEPAGE="https://sourceforge.net/projects/aeuio/"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.gz"	# or .lzma

LICENSE=" || ( GPL-2 GPL-3 LGPL-3 BSD CCPL-Attribution-3.0 )"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

DEPEND=""
RDEPEND="sys-apps/busybox"

pkg_postinst() {
	elog "Please follow the instructions in /usr/src/aeuio/USAGE"
	elog "You may also want to read /usr/src/aeuio/process.txt"
	elog "If your system only uses bare partitions, mdadm, lvm, and"
	elog " any encrypted root  / swap devices are mentioned in a debian"
	elog " style /etc/crypttab file then the automatic tool may be used."
	elog " update-initramfs-aeuio will generate an initramfs in \$PWD."
}
