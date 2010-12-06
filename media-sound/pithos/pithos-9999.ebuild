# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="3"
PYTHON_DEPEND="2:2.6"
SUPPORT_PYTHON_ABIS="1"
inherit bzr distutils

DESCRIPTION="A Pandora Radio (pandora.com) player for the GNOME Desktop"
HOMEPAGE="http://kevinmehall.net/p/pithos/"
EBZR_REPO_URI="lp:${PN}"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS=""
IUSE="gnome"

DEPEND="dev-python/python-distutils-extra"

RDEPEND="dev-python/pyxdg
	dev-python/pygobject
	dev-python/notify-python
	dev-python/pygtk
	dev-python/gst-python
	dev-python/dbus-python
	media-libs/gst-plugins-good
	media-libs/gst-plugins-bad
	media-plugins/gst-plugins-faad
	media-plugins/gst-plugins-soup
	gnome? ( gnome-base/gnome-settings-daemon )
	!gnome? ( dev-libs/keybinder )"

RESTRICT_PYTHON_ABIS="2.[45] 3.*"

src_prepare() {
	# bug #216009
	# avoid writing to /root/.gstreamer-0.10/registry.xml
	export GST_REGISTRY="${T}"/registry.xml
	python_copy_sources
}

src_install() {
	installation() {
		"$(PYTHON)" \
		setup.py \
		install --root="${D}" --no-compile --prefix="${EPREFIX}"/usr
	}
	python_execute_function -s installation
}
