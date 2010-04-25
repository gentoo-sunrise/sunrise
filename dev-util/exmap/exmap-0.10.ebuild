# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=2

inherit eutils linux-mod

DESCRIPTION="A memory analysis kernel module with userland tool"
HOMEPAGE="http://www.berthels.co.uk/exmap/"
SRC_URI="http://www.berthels.co.uk/${PN}/download/${P}.tgz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="gtk"

RDEPEND="dev-libs/libpcre
	gtk? ( x11-libs/gtk+:2 )"
DEPEND="${RDEPEND}
	dev-libs/boost
	dev-util/pkgconfig"

MODULE_NAMES="exmap(misc:${S}/kernel)"
BUILD_TARGETS="clean kernel_modules"

src_prepare() {
	# patch find_task_by_pid to pid_task and &proc_root to NULL
	epatch "${FILESDIR}/${P}-kernel.patch"

	# use $(MAKE), remove -g on CXXFLAGS, clean up CXX/LD invocations/
	epatch "${FILESDIR}/${P}-makefiles.patch"

	# somthing strange between linux-mod supplied ARCH and old kernels
	# which leads to arch/x86/Makefile: file/dir x86 not found
	if kernel_is lt 2 6 25 ; then
		sed -i -e 's:\$(MAKE):unset ARCH ; \$(MAKE):' kernel/Makefile || die
	fi

	# new gcc include behavior
	epatch "${FILESDIR}/${P}-gcc.patch"

	# fix for 64bit from http://www.kdedevelopers.org/node/4166
	epatch "${FILESDIR}/${P}-fix64bit.patch"

	rm -v src/{*.so,munged-ls-threeloads,prelinked-amule} || die
}

src_compile() {
	export KERNEL_DIR
	linux-mod_src_compile

	emake CXX="$(tc-getCXX)" LD="$(tc-getLD)" -C jutil || die
	emake CXX="$(tc-getCXX)" LD="$(tc-getLD)" -C src $(use gtk || echo exmtool) || die
}

src_install() {
	linux-mod_src_install

	dobin src/exmtool || die
	use gtk && { dobin src/gexmap || die ; }
	dodoc TODO README || die
}

pkg_postinst() {
	linux-mod_pkg_postinst

	elog "Please load the exmap kernel module before running exmtool or gexmap."
}
