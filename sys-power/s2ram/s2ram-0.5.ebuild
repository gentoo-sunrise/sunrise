# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header$

inherit linux-info toolchain-funcs

MY_P=suspend-${PV}

DESCRIPTION="Suspend-to-RAM utility from Linux Suspend project"
SRC_URI="mirror://sourceforge/suspend/${MY_P}.tar.gz"
HOMEPAGE="http://en.opensuse.org/S2ram http://sf.net/projects/suspend/"
KEYWORDS="~x86"

SLOT="0"
LICENSE="GPL-2"
IUSE=""

DEPEND="sys-apps/pciutils"
RDEPEND=""

S=${WORKDIR}/${MY_P}

src_unpack() {
	unpack ${A}
	cd "${S}"
	sed -i -e "s@CFLAGS :=@CFLAGS +=@" Makefile || die "sed failed in Makefile"
}

pkg_setup() {
	if kernel_is lt 2 6 17 ; then
		eerror "2.6.17 or higher kernel is required to use ${PN}"
		die "This will only work with recent 2.6 kernels"
	fi

	if has_version =sys-apps/pciutils-2.2.4* ; then
		if built_with_use --missing true =sys-apps/pciutils-2.2.4* zlib ; then
			eerror "Compile will fail with =sys-apps/pciutils-2.2.4* emerge with USE=zlib"
			eerror "If you dislike this, then attach a patch to Bug 128468"
			die "You MUST build pciutils without the zlib USE flag"
		fi
	fi
	
	if kernel_is lt 2 6 23 ; then
		CONFIG_CHECK="SOFTWARE_SUSPEND"
	else
		CONFIG_CHECK="HIBERNATION"
	fi

	linux-info_pkg_setup
}

src_compile() {
	emake CC=$(tc-getCC) s2ram || die "compile failed"
}

src_install() {
	dosbin s2ram || die "install failed"
	newdoc README.s2ram-whitelist README
}

pkg_postinst() {
	if ! has_version sys-apps/vbetool ; then
		elog "If you get blank screen on resume, then emerge sys-apps/vbetool"
		elog "and read the supplied documentation."
	fi

	if ! has_version app-laptop/radeontool ; then
		elog "To control backlight on suspend with ATI Radeon Mobility graphics cards,"
		elog "you will need to emerge app-laptop/radeontool"
	fi

	elog "See README in /usr/share/doc/${PF} and ${PN} -h for quick usage instructions."
}
