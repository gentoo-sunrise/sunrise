# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit eutils linux-mod

DESCRIPTION="Another Unionfs is an entirely re-designed and re-implemented Unionfs."
HOMEPAGE="http://aufs.sourceforge.net/"
SRC_URI="http://www.fh-kl.de/~torsten.kockler/gentoo/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="ksize nfs"

MODULE_NAMES="aufs(addon/fs/${PN}:)"
BUILD_PARAMS="KDIR=${KV_DIR} -f local.mk"
BUILD_TARGETS="all"

pkg_setup(){
	# kernel version check
	if kernel_is lt 2 6 16
	then
		eerror
		eerror "Aufs is being developed and tested on linux-2.6.16 and later."
		eerror "Make sure you have a proper kernel version!"
		eerror
		die "Wrong kernel version"
	fi

	linux-mod_pkg_setup
}

src_install() {
	exeinto /sbin
	exeopts -m0500
	doexe mount.aufs umount.aufs auplink aulchown
	doman aufs.5
	linux-mod_src_install
}

pkg_postinst() {

	# ksize Patch
	if use ksize
	then
		# Check if Kernel is already patched
		if grep -qs "EXPORT_SYMBOL(ksize);" "${KV_DIR}/mm/slab.c"
		then
			einfo "Your kernel has already been patched for ksize"
		else
			# Patch kernel
			cd "${KV_DIR}"
			epatch "${S}/ksize.patch"
			ewarn
			ewarn
			ewarn "You have to recompile your kernel to make ksize work"
			ewarn
		fi
	fi

	# lhash Patch
	if use nfs && kernel_is ge 2 6 19
	then
		# Check if kernel is already patched
		if grep -qs "EXPORT_SYMBOL(__lookup_hash);" "${KV_DIR}/fs/namei.c" ||
		grep -qs "struct dentry * __lookup_hash(struct qstr *name, struct dentry
		* base, struct nameidata *nd);" "${KV_DIR}/fs/namei.h"
		then
			einfo "Your kernel has already been patched for lhash"
		else
			# Patch kernel
			cd "${KV_DIR}"
			epatch "${S}/lhash.patch"
			ewarn
			ewarn
			ewarn "You have to recompile your kernel to make the lhash patch for nfs-support work"
			ewarn
		fi
	fi

	linux-mod_pkg_postinst

	einfo
	einfo "To be able to use aufs, you have to load the kernel module by typing:"
	einfo "modprobe aufs"
	einfo
	einfo "For further information refer to the aufs man page"
	einfo
}
