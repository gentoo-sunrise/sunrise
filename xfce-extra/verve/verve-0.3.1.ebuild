# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit xfce44

DESCRIPTION="Xfce4 panel plugin for small command line"
KEYWORDS="~amd64 ~x86"

RDEPEND=">=xfce-base/libxfce4util-${XFCE_BETA_VERSION}
	>=xfce-extra/exo-0.3.1.6_beta
	dev-libs/libpcre"
DEPEND="${RDEPEND}
	>=xfce-base/xfce4-panel-${XFCE_BETA_VERSION}"

xfce44_beta
xfce44_goodies_panel_plugin

src_unpack() {
	unpack ${A}
	cd "${S}"

	# Fix compile error; fixed in SVN.
	sed -i -e '7d' Makefile.am
	sed -i -e '250d' Makefile.in
}
