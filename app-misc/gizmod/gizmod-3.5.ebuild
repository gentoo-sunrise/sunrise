# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="2"

inherit cmake-utils linux-info multilib

DESCRIPTION="Input event scripting utility that has special support for fancy keyboards, mice, USB dials and more"
HOMEPAGE="http://gizmod.sourceforge.net"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.bz2"
LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="libvisual"
RDEPEND="x11-libs/libXext
	>=dev-libs/boost-1.34[python]
	amd64? ( >=dev-libs/boost-1.36[python] )
	x11-libs/libICE
	media-libs/alsa-lib
	libvisual? ( >=media-libs/libvisual-0.4.0 )"
DEPEND="${RDEPEND}"

CONFIG_CHECK="INPUT_EVDEV INOTIFY INOTIFY_USER"

ERROR_INPUT_EVDEV="
Gizmo Daemon needs input evdev support from the kernel.
Please select \"Event interface\" (CONFIG_INPUT_EVDEV) under
\"Device Drivers->Input Device Support->Event interface\".
This option can be built directly into the kernel or as
a module.
"

ERROR_INOTIFY="
Gizmo Daemon needs inotify support built into the kernel.
Please select \"Inotify file change notifification\"
(CONFIG_INOTIFY) under \"Device Drivers->File systems\". This
option can only be built directly into the kernel.
"

ERROR_INOTIFY_USER="
Gizmo Daemon needs userspace inotify support built into the kernel.
Please select \"Inotify file change notifification\"
(CONFIG_INOTIFY) followed by \"Inotify support for userspace\"
(CONFIG_INOTIFY_USER) under \"Device Drivers->File systems\". These
options can only be built directly into the kernel.
"

src_prepare() {
	# straighten up the paths
	sed -i CMakeLists.txt -e /DefineInstallationPaths/d || die "sed: removal of DefineInstallationPaths failed"
	sed -i libGizmod/CMakeLists.txt -e 's:lib$:${LIB_INSTALL_DIR}:' || die "sed: replacing lib with LIB_INSTALL_DIR failed"
}

src_configure() {
	local mycmakeargs="
		-DSYSCONF_INSTALL_DIR=/etc
		-DLIB_INSTALL_DIR=/usr/$(get_libdir)
		$(cmake-utils_use_build libvisual VIS_PLUGIN)
	"
	cmake-utils_src_configure
}
