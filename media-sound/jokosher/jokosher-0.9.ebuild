# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

NEED_PYTHON=2.4

inherit gnome2 distutils

DESCRIPTION="A simple yet powerful multi-track studio"
HOMEPAGE="http://www.jokosher.org/"
SRC_URI="http://www.jokosher.org/downloads/source/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND="dev-python/dbus-python
	dev-python/gnome-python
	>=dev-python/gst-python-0.10.6
	dev-python/pycairo
	>=dev-python/pygtk-2.8
	dev-python/pyxml
	dev-python/setuptools
	gnome-base/librsvg
	>=media-libs/gnonlin-0.10.6
	>=media-libs/gst-plugins-good-0.10.5
	>=media-libs/gst-plugins-bad-0.10.3
	>=media-libs/gstreamer-0.10.11
	>=media-plugins/gst-plugins-alsa-0.10.9
	>=media-plugins/gst-plugins-flac-0.10
	>=media-plugins/gst-plugins-gnomevfs-0.10
	>=media-plugins/gst-plugins-lame-0.10.3
	>=media-plugins/gst-plugins-ogg-0.10
	>=media-plugins/gst-plugins-vorbis-0.10
	x11-themes/hicolor-icon-theme"

DEPEND="${RDEPEND}"

PYTHON_MODNAME=Jokosher
DOCS="AUTHORS README"

src_unpack() {
	gnome2_src_unpack
	sed -i -e "s/#Non-documen.*/import sys;sys.exit(0)/g" \
		setup.py || die "sed failed"
	sed -i -e "s/^Categories=.*/Categories=GNOME;GTK;Application;AudioVideo/g" \
		bin/jokosher.desktop || die "sed failed"
}

pkg_postinst() {
	distutils_pkg_postinst
	gnome2_pkg_postinst
}

pkg_postrm() {
	distutils_pkg_postrm
	gnome2_pkg_postrm
}
