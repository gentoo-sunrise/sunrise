# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=4
PYTHON_DEPEND="2"

inherit eutils python

DESCRIPTION="Wallpaper downloader and rotator that uses Flickr and Webshots"
HOMEPAGE="http://www.webilder.org/"

SRC_URI="http://www.webilder.org/static/downloads/Webilder-${PV}.tar.gz"
LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND="dev-libs/libappindicator:0
	dev-python/gnome-applets-python
	dev-python/gnome-python-base
	dev-python/gnome-python-desktop-base
	dev-python/gnome-python-extras-base
	dev-python/imaging
	dev-python/libgnome-python
	dev-python/pygtk
	gnome-base/libgnomeui"

DEPEND="${RDEPEND}"

pkg_setup() {
	python_set_active_version 2
	python_pkg_setup
}

src_prepare() {
	python_convert_shebangs -r 2 .
}

src_install() {
	$(PYTHON) setup.py install --root="${D}" || die "Install failed"

	# we dont want to force autostart
	rm "${D}"/usr/share/gnome/autostart/webilder_indicator.desktop || die
}

pkg_postinst() {
	python_mod_optimize webilder
}

pkg_postrm() {
	python_mod_cleanup webilder
}

pkg_postinst() {
	elog "UNITY/OTHERS: Start the 'Webilder Indicator Applet' app and"
	elog "add it to your autostart (webilder_unity_indicator)."
	elog ""
	elog "GNOME: Right-click on the GNOME panel, choose 'Add to panel'"
	elog "and select 'Webilder Webshots Applet'."
	elog "If it is not in the list - log off and log in again."
	elog ""
	elog "Command-Line: Run webilder_desktop or webilder_downloader."
	elog ""
	elog "KDE4: Currently not supported."
}
