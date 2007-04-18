# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit eutils python
DESCRIPTION="A simple yet powerful multi-track studio"
HOMEPAGE="http://www.jokosher.org/"
SRC_URI="http://www.jokosher.org/scripts/download.php/src/www.jokosher.org/${PV}/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND=">=dev-lang/python-2.4
	dev-python/dbus-python
	dev-python/gnome-python
	>=dev-python/gst-python-0.10.6
	dev-python/pycairo
	>=dev-python/pygtk-2.8
	dev-python/pyxml
	dev-python/setuptools
	gnome-base/librsvg
	>=media-libs/gnonlin-0.10.6
	>=media-libs/gst-plugins-good-0.10.5
	>=media-libs/gstreamer-0.10.11
	>=media-plugins/gst-plugins-alsa-0.10.9
	>=media-plugins/gst-plugins-flac-0.10
	>=media-plugins/gst-plugins-gnomevfs-0.10
	>=media-plugins/gst-plugins-lame-0.10.3
	>=media-plugins/gst-plugins-ogg-0.10
	>=media-plugins/gst-plugins-vorbis-0.10
	x11-themes/hicolor-icon-theme"

DEPEND="${RDEPEND}"

pkg_setup() {
	# warn if dbus python bindings are not available (in case of <dbus-0.90)
	if ! has_version dev-python/dbus-python && ! built_with_use sys-apps/dbus python
	then
		echo
		eerror "Python dbus bindings not found."
		eerror "Either emerge dev-python/dbus-python, or alternatively, rebuild"
		eerror "<sys-apps-dbus-0.90 with python USE flag. To do so, try"
		eerror "# echo \"sys-apps/dbus python\" >>/etc/portage/package.use"
		eerror "or add python to USE in /etc/make.conf, and then run"
		eerror "# emerge <sys-apps/dbus-0.90"
		echo
		die "Python dbus bindings must be installed."
	fi
}

src_install() {

	dobin "${FILESDIR}"/jokosher

	cd "${WORKDIR}"
	dodoc AUTHORS README

	insinto /usr/share/jokosher
	doins -r extensions images Instruments
	doins Jokosher/*
	fperms 755 /usr/share/jokosher/{Jokosher,JokosherApp.py}
	doicon images/jokosher-icon.png
	domenu jokosher.desktop

	insinto /usr/share/locale
	cd locale
	doins -r *
}

pkg_postinst() {
	python_mod_optimize ${ROOT}usr/share/jokosher
	echo
	einfo "Use /usr/bin/jokosher to run Jokosher ${PV}"
	echo
}

pkg_postrm() {
	python_mod_cleanup ${ROOT}usr/share/jokosher
}
