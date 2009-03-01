# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/x11-libs/libdrm/libdrm-2.4.4.ebuild,v 1.2 2009/02/05 13:33:40 remi Exp $

EAPI="2"

# Must be before x-modular eclass is inherited
SNAPSHOT="yes"

inherit x-modular

DRM_P="${P/_nouveau/}"

DESCRIPTION="X.Org libdrm nouveau library"
HOMEPAGE="http://dri.freedesktop.org/"
SRC_URI="http://dri.freedesktop.org/libdrm/${DRM_P}.tar.gz"

LICENSE="libdrm"
KEYWORDS="~amd64 ~x86"
IUSE=""
RESTRICT="test" # see bug #236845

RDEPEND="dev-libs/libpthread-stubs
	!x11-libs/libdrm[video_cards_nouveau]
	~x11-libs/libdrm-${PV}"
DEPEND="${RDEPEND}"

S="${WORKDIR}/${DRM_P}"
PATCHES="${FILESDIR}/${DRM_P}-nouveau.patch"
CONFIGURE_OPTIONS="--enable-udev --enable-nouveau-experimental-api"

# FIXME, we should try to see how we can fit the --enable-udev configure flag

src_install() {
	x-modular_src_install
	# do not install files already installed by libdrm
	find "${D}" \( -type f -o -type l \) \! -name "*nouveau*" -exec rm '{}' \;
	rm "${D}"/usr/include/drm/nouveau_drm.h
}

pkg_postinst() {
	x-modular_pkg_postinst

	ewarn "libdrm's ABI may have changed without change in library name"
	ewarn "Please rebuild media-libs/mesa, x11-base/xorg-server and"
	ewarn "your video drivers in x11-drivers/*."
}
