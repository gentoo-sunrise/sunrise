# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=2

inherit linux-mod

DESCRIPTION="Driver for Syntek webcams"
HOMEPAGE="http://syntekdriver.sourceforge.net/"
SRC_URI="mirror://sourceforge/syntekdriver/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

MODULE_NAMES="stk11xx(media/video:)"
BUILD_TARGETS="stk11xx.ko"
CONFIG_CHECK="VIDEO_DEV VIDEO_V4L1_COMPAT"

src_prepare() {
	epatch "${FILESDIR}"/${PN}-v4l_compat_ioctl32.diff
	BUILD_PARAMS="-C ${KV_DIR} SUBDIRS=${S}"
}

src_install() {
	linux-mod_src_install
	dodoc README || die "dodoc failed"
}
