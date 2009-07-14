# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

DESCRIPTION="A simple, customizable, /etc inspired initrd or initramfs creator that supports root on mdadm / lvm"
HOMEPAGE="https://sourceforge.net/projects/aeuio/"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.lzma"

LICENSE=" || ( GPL-2 GPL-3 LGPL-3 BSD CCPL-Attribution-3.0 )"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

RDEPEND="sys-apps/busybox"
# also depends on make, but make should be there on a gentoo system.

pkg_setup() {
	# While I believe this should go under /etc, especially intrepreting http://devmanual.gentoo.org/general-concepts/filesystem/index.html , I use the above location by request that I -not- use /etc
	#	local myDir="/etc/early-userspace/aeuio"
	myDir="/usr/src/aeuio"
}

src_unpack() {
	unpack ${A}
	# Create update-initramfs-clean - This will be in the next (>0.0.3) upstream release
	echo -e '#!/bin/bash'"\nOUTDIR=\"\$PWD\"\ncd \"${myDir}\"\nmake distclean nuke\nmake initramfs_gz initramfs_lzma && cp initramfs* \"\$OUTDIR\"" > ${S}/tools/update-initramfs-clean
}

src_compile() {
	# Stop the default 'make' action.
	true
}

src_install() {
	# The Easy way, at least until things are more complicated.
	dodir "${myDir}" || die "Install basedir failed!"
	cp --no-dereference --preserve=links -R [^IL]* "${D}${myDir}/" || die "Install failed!"

	insinto "${myDir}"
	newins "INSTALL" "USAGE" || die
	dosbin "tools/update-initramfs-clean" || die

	elog "Please follow the instructions in ${myDir}/USAGE"
	elog "You may also want to read ${myDir}/tools/process.txt"
	elog "If your system only uses bare partitions, mdadm and/or lvm,"
	elog " you may alternatly use update-initramfs-clean to generate"
	elog " initramfs images in ${myDir}"
}
