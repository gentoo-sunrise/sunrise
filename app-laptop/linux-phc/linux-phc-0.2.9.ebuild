# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

WANT_AUTOCONF=2.5
WANT_AUTOMAKE=1.9
inherit linux-info eutils autotools

DESCRIPTION="A kernel patch to change the voltage/frequency pairs of processors from userspace."
HOMEPAGE="https://www.dedigentoo.org/trac/linux-phc/"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86"
IUSE=""

which_patch() {
	if kernel_is 2 6 20
	then
		PATCH="kernel-patch/${P}-kernel-vanilla-2.6.20.patch"
	elif kernel_is 2 6 19
	then
		PATCH="kernel-patch/${P}-kernel-vanilla-2.6.19.patch"
	elif kernel_is 2 6 18
	then
		PATCH="kernel-patch/${P}-kernel-vanilla-2.6.18.patch"
	elif kernel_is 2 6 17
	then
		PATCH="kernel-patch/${P}-kernel-vanilla-2.6.17.patch"
	elif kernel_is 2 6 16
	then
		PATCH="kernel-patch/${P}-kernel-vanilla-2.6.16.patch"
	elif kernel_is 2 6 15
	then
		PATCH="kernel-patch/${P}-kernel-vanilla-2.6.15.patch"
	else
		die "No ${PN} patch for kernel version ${KV_FULL} -- sorry not supported"
	fi
}

collision_check() {
	if has collision-protect ${FEATURES}; then
		ewarn "Collisions are expected as this patches kernel code. Disable"
		ewarn "FEATURES=collision-protect before use"
		die 'incompatible FEATURES=collision-protect'
	fi
}

pkg_setup() {
	linux-info_pkg_setup
	collision_check
}

src_unpack() {
	which_patch

	if egrep -q 'linux-phc' \
		"${KV_DIR}"/arch/i386/kernel/cpu/cpufreq/speedstep-centrino.c
	then
		ewarn "already installed ${PN} for kernel ${KV_FULL}"
		ewarn "If this is an upgrade attempt, reemerge your kernel sources"
		ewarn "and try emerging this package again."
		die
	fi

	unpack ${A}
	cd "${S}"

	# linux-headers-2.6.20 doesn't have asm/msr.h
	epatch "${FILESDIR}"/${P}-msr_h-fix.patch || die "epatch failed"

	local mydir="arch/i386/kernel/cpu/cpufreq"
	mkdir -p "${S}"/${mydir}

	cp -P "${KV_DIR}"/${mydir}/Kconfig "${S}"/${mydir}/
	cp -P "${KV_DIR}"/${mydir}/Makefile "${S}"/${mydir}/
	cp -P "${KV_DIR}"/${mydir}/speedstep-centrino.c "${S}"/${mydir}/

	epatch "${S}"/${PATCH}
}

src_compile() {
	einfo "Compiling measurefreq"
	cd "${S}"/utils/measurefreq
	eautoconf
	eautomake
	econf || die "econf failed"
	emake || die "emake failed"
}

src_install() {
	insinto "$(/bin/readlink -f ${KV_DIR})"
	doins -r arch
	dodoc README
	doinitd gentoo/etc/init.d/undervolt
	doconfd gentoo/etc/conf.d/undervolt
	cd "${S}"/utils/measurefreq
	emake DESTDIR="${D}" install || die "emake failed"
}

pkg_preinst() {
	collision_check
}

pkg_postinst() {
	elog  "Please read https://www.dedigentoo.org/trac/linux-phc/#Documentation before using linux-phc"
	elog  "You can use the utility measurefreq to find appropriate voltage values."
	ewarn "Edit /etc/conf.d/undervolt before using the initscript"
}

pkg_postrm() {
	ewarn "Unmerging this ebuild won't revert the patches in your kernel"
	ewarn "Reemerge your kernel if you want that"
}
