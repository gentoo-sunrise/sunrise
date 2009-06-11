# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

WANT_AUTOMAKE="1.7"

#EGIT_BRANCH="vblank-rework"
EGIT_TREE="f57d7f4b0b14972f92a83f155ae8033478aa7729"
EGIT_REPO_URI="git://anongit.freedesktop.org/git/mesa/drm"
EGIT_PATCHES=( "${FILESDIR}/drm-fix-building-with-2.6.30.patch" )

inherit eutils x11 linux-mod autotools git

IUSE="kernel_linux kernel_FreeBSD"

# Make sure Portage does _NOT_ strip symbols.  We will do it later and make sure
# that only we only strip stuff that are safe to strip ...
# Tests require user intervention (see bug #236845)
RESTRICT="strip test"

S="${WORKDIR}/drm"

DESCRIPTION="Nouveau DRM Kernel Modules for X11"
HOMEPAGE="http://dri.sf.net"
SRC_URI=""

SLOT="0"
LICENSE="X11"
KEYWORDS="~amd64 ~x86"

DEPEND="kernel_linux? ( virtual/linux-sources )
	kernel_FreeBSD? ( sys-freebsd/freebsd-sources
			sys-freebsd/freebsd-mk-defs )
	!x11-base/x11-drm"
RDEPEND=""

pkg_setup() {
	# Setup the kernel's stuff.
	kernel_setup

	# Set video cards to build for.
	set_vidcards

	# Determine which -core dir we build in.
	get_drm_build_dir
}

src_unpack() {
	git_src_unpack

	# Substitute new directory under /lib/modules/${KV_FULL}
	cd "${SRC_BUILD}"
	sed -i -e "s:/kernel/drivers/char/drm:/${PN}:g" Makefile

	cp "${S}"/tests/*.c ${SRC_BUILD}

	src_unpack_os

	cd "${S}"
	eautoreconf -v --install
}

src_compile() {
	# Building the programs. These are useful for developers and getting info from DRI and DRM.
	#
	# libdrm objects are needed for drmstat.
	econf \
		--enable-static \
		--disable-shared
	emake || die "libdrm build failed."

	einfo "Building DRM in ${SRC_BUILD}..."
	src_compile_os
	einfo "DRM build finished".
}

src_install() {
	einfo "Installing DRM..."
	cd "${SRC_BUILD}"

	src_install_os

	dodoc "${S}/linux-core/README.drm"

	dobin ../tests/dristat || die dobin failed
	dobin ../tests/drmstat || die dobin failed
}

pkg_postinst() {
	if use video_cards_sis
	then
		einfo "SiS direct rendering only works on 300 series chipsets."
		einfo "SiS framebuffer also needs to be enabled in the kernel."
	fi

	if use video_cards_mach64
	then
		einfo "The Mach64 DRI driver is insecure."
		einfo "Malicious clients can write to system memory."
		einfo "For more information, see:"
		einfo "http://dri.freedesktop.org/wiki/ATIMach64."
	fi

	pkg_postinst_os
}

# Functions used above are defined below:

kernel_setup() {
	if use kernel_FreeBSD
	then
		K_RV=${CHOST/*-freebsd/}
	elif use kernel_linux
	then
		linux-mod_pkg_setup

		if kernel_is 2 4
		then
			eerror "Upstream support for 2.4 kernels has been removed, so this package will no"
			eerror "longer support them."
			die "Please use in-kernel DRM or switch to a 2.6 kernel."
		fi

		linux_chkconfig_builtin "DRM" && \
			die "Please disable or modularize DRM in the kernel config. (CONFIG_DRM = n or m)"

		CONFIG_CHECK="AGP"
		ERROR_AGP="AGP support is not enabled in your kernel config (CONFIG_AGP)"
	fi
}

set_vidcards() {
	VIDCARDS=""
	VIDCARDS="${VIDCARDS} nouveau.${KV_OBJ}"
}

get_drm_build_dir() {
	if use kernel_FreeBSD
	then
		SRC_BUILD="${S}/bsd-core"
	elif kernel_is 2 6
	then
		SRC_BUILD="${S}/linux-core"
	fi
}

patch_prepare() {
	# Handle exclusions based on the following...
	#     All trees (0**), Standard only (1**), Others (none right now)
	#     2.4 vs. 2.6 kernels
	if use kernel_linux
	then
	    kernel_is 2 6 && mv -f "${PATCHDIR}"/*kernel-2.4* "${EXCLUDED}"
	fi

	# There is only one tree being maintained now. No numeric exclusions need
	# to be done based on DRM tree.
}

src_unpack_linux() {
	convert_to_m "${SRC_BUILD}"/Makefile
}

src_unpack_freebsd() {
	# Link in freebsd kernel.
	ln -s "/usr/src/sys-${K_RV}" "${WORKDIR}/sys"
	# SUBDIR variable gets to all Makefiles, we need it only in the main one.
	SUBDIRS=${VIDCARDS//.ko}
	sed -i -e "s:SUBDIR\ =.*:SUBDIR\ =\ drm ${SUBDIRS}:" "${SRC_BUILD}"/Makefile
}

src_unpack_os() {
	if use kernel_linux; then
		src_unpack_linux
	elif use kernel_FreeBSD
	then
		src_unpack_freebsd
	fi
}

src_compile_os() {
	if use kernel_linux
	then
		src_compile_linux
	elif use kernel_FreeBSD
	then
		src_compile_freebsd
	fi
}

src_install_os() {
	if use kernel_linux
	then
		src_install_linux
	elif use kernel_FreeBSD
	then
		src_install_freebsd
	fi
}

src_compile_linux() {
	# remove leading and trailing space
	VIDCARDS="${VIDCARDS% }"
	VIDCARDS="${VIDCARDS# }"

	check_modules_supported
	MODULE_NAMES=""
	for i in drm.${KV_OBJ} ${VIDCARDS}; do
		MODULE_NAMES="${MODULE_NAMES} ${i/.${KV_OBJ}}(${PN}:${SRC_BUILD})"
		i=$(echo ${i} | tr '[:lower:]' '[:upper:]')
		eval MODULESD_${i}_ENABLED="yes"
	done

	# This now uses an M= build system. Makefile does most of the work.
	cd "${SRC_BUILD}"
	unset ARCH
	BUILD_TARGETS="modules"
	BUILD_PARAMS="DRM_MODULES='${VIDCARDS}' LINUXDIR='${KERNEL_DIR}' M='${SRC_BUILD}'"
	ECONF_PARAMS='' S="${SRC_BUILD}" linux-mod_src_compile

	if linux_chkconfig_present DRM
	then
		ewarn "Please disable in-kernel DRM support to use this package."
	fi
}

src_compile_freebsd() {
	cd "${SRC_BUILD}"
	# Environment CFLAGS overwrite kernel CFLAGS which is bad.
	local svcflags=${CFLAGS}; local svldflags=${LDFLAGS}
	unset CFLAGS; unset LDFLAGS
	MAKE=make \
		emake \
		NO_WERROR= \
		SYSDIR="${WORKDIR}/sys" \
		KMODDIR="/boot/modules" \
		|| die "pmake failed."
	export CFLAGS=${svcflags}; export LDFLAGS=${svldflags}

	cd "${S}/tests"
	# -D_POSIX_SOURCE skips the definition of several stuff we need
	# for these two to compile
	sed -i -e "s/-D_POSIX_SOURCE//" Makefile
	emake dristat || die "Building dristat failed."
	emake drmstat || die "Building drmstat failed."
	# Move these where the linux stuff expects them
	mv dristat drmstat ${SRC_BUILD}
}

die_error() {
	eerror "Portage could not build the DRM modules. If you see an ACCESS DENIED error,"
	eerror "this could mean that you were using an unsupported kernel build system."
	eerror "Only 2.6 kernels at least as new as 2.6.6 are supported."
	die "Unable to build DRM modules."
}

src_install_linux() {
	linux-mod_src_install

	# Strip binaries, leaving /lib/modules untouched (bug #24415)
	strip_bins \/lib\/modules
}

src_install_freebsd() {
	cd "${SRC_BUILD}"
	dodir "/boot/modules"
	MAKE=make \
		emake \
		install \
		NO_WERROR= \
		DESTDIR="${D}" \
		KMODDIR="/boot/modules" \
		|| die "Install failed."
}

pkg_postinst_os() {
	if use kernel_linux
	then
		linux-mod_pkg_postinst
	fi
}
