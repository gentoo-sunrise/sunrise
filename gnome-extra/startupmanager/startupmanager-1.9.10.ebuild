# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit distutils

DESCRIPTION="a gui tool for changing settings for Grub, Grub2, Usplash and Splashy"
HOMEPAGE="http://web.telia.com/~u88005282/sum/index.html"
SRC_URI="mirror://sourceforge/startup-manager/${P}.tar.gz"

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
