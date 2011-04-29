# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="3"

PYTHON_DEPEND="2"
SUPPORT_PYTHON_ABIS="1"
RESTRICT_PYTHON_ABIS="3.*"

inherit distutils

DESCRIPTION="A gui tool for changing settings for Grub, Grub2, Usplash and Splashy"
HOMEPAGE="http://web.telia.com/~u88005282/sum/index.html"
SRC_URI="mirror://sourceforge/startup-manager/${PN}_${PV}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

RDEPEND="dev-python/pygtk
		dev-python/gnome-python-desktop
		dev-python/gnome-python-extras
		gnome-extra/yelp
		media-gfx/imagemagick"
DEPEND="${RDEPEND}
		sys-devel/gettext
		>=dev-util/intltool-0.35"

PYTHON_MODNAME=bootconfig
