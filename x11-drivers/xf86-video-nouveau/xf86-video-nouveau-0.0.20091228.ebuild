# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="2"

# Must be before x-modular eclass is inherited
SNAPSHOT="yes"
GIT_ECLASS="git"

inherit x-modular

EGIT_COMMIT="6992d0e7a0cb3c32b16af0b724246e44f7a35d7e"
EGIT_REPO_URI="git://anongit.freedesktop.org/git/nouveau/${PN}"

DESCRIPTION="Nouveau video driver"
HOMEPAGE="http://nouveau.freedesktop.org/"
SRC_URI=""

LICENSE="MIT"
KEYWORDS="~amd64 ~ppc ~x86"
IUSE=""

COMMON_DEPEND=">=x11-base/xorg-server-1.5.3[-minimal]"
DEPEND="${COMMON_DEPEND}
	x11-proto/fontsproto
	x11-proto/randrproto
	x11-proto/renderproto
	x11-proto/videoproto
	x11-proto/xextproto
	x11-proto/xf86driproto
	x11-proto/xproto
	>=x11-libs/libdrm-2.4.17"

# need x11-base/nouveau-drm until nouveau drm enters the kernel
RDEPEND="${COMMON_DEPEND}
	x11-base/nouveau-drm"
