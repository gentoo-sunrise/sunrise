# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit eutils toolchain-funcs

DESCRIPTION="Exaile is a media player aiming to be similar to KDE's AmaroK, but for GTK"
HOMEPAGE="http://www.exaile.org"
SRC_URI="http://www.exaile.org/files/${PN}_${PV}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86"
IUSE=""

DEPEND=">=dev-lang/python-2.4
		>=dev-python/pygtk-2.0"
RDEPEND="${DEPEND}
		>=dev-python/pysqlite-2
		>=media-libs/gstreamer-0.10
		>=media-libs/gst-plugins-good-0.10
		>=dev-python/gst-python-0.10
		dev-python/pyogg
		dev-python/pymad
		sys-apps/dbus"

S=${WORKDIR}/${PN}

pkg_setup() {
	if ! built_with_use sys-apps/dbus python; then
		eerror "dbus has to be built with python support"
		die "dbus python use-flag not set"
	fi
}

src_compile() {
	emake CC=$(tc-getCC) || die "emake failed"
}

src_install() {
	emake DESTDIR="${D}" install || die "emake install failed"
}
