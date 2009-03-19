# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="2"

# Must be before x-modular eclass is inherited
SNAPSHOT="yes"
GIT_ECLASS="git"

inherit x-modular

EGIT_TREE="cba114a4ffd8d834b8862f4ea9f8d02870608a38"
EGIT_REPO_URI="git://anongit.freedesktop.org/git/nouveau/${PN}"

DESCRIPTION="Nouveau video driver"
HOMEPAGE="http://nouveau.freedesktop.org/"
SRC_URI=""

LICENSE="MIT"
KEYWORDS="~amd64 ~x86"
IUSE=""

COMMON_DEPEND=">=x11-base/xorg-server-1.5.3[-minimal]"
DEPEND="${COMMON_DEPEND}
	x11-misc/util-macros
	x11-proto/fontsproto
	x11-proto/randrproto
	x11-proto/renderproto
	x11-proto/videoproto
	x11-proto/xextproto
	x11-proto/xf86driproto
	x11-proto/xproto
	|| ( x11-libs/libdrm_nouveau x11-libs/libdrm[video_cards_nouveau] )"

# need x11-base/x11-drm until nouveau drm enters the kernel
RDEPEND="${COMMON_DEPEND}
	|| ( x11-base/nouveau-drm x11-base/x11-drm[video_cards_nouveau] )"

