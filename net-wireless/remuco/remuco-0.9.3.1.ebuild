# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=2
PYTHON_DEPEND="2:2.6"
SUPPORT_PYTHON_ABIS="1"
JAVA_PKG_OPT_USE="client"

inherit distutils python java-pkg-opt-2 java-ant-2

MY_P=${PN}-source-${PV}
DESCRIPTION="A server and J2ME client to control various media players"
HOMEPAGE="http://code.google.com/p/remuco"
SRC_URI="http://${PN}.googlecode.com/files/${MY_P}.tar.gz"

LICENSE="Apache-2.0 GPL-3 LGPL-2.1"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="amarok audacious banshee exaile mpd mplayer quodlibet rhythmbox totem tvtime vlc"

COMMON_DEPEND="dev-python/dbus-python
	dev-python/imaging
	dev-python/pybluez
	dev-python/pygobject
	dev-python/pyxdg"
DEPEND="${COMMON_DEPEND}
	client? (
		>=virtual/jdk-1.1
		dev-java/ant-nodeps
		dev-java/ant-apache-regexp
		dev-java/proguard[ant]
	)"
RDEPEND="${COMMON_DEPEND}
	amarok? ( >=media-sound/amarok-2.0 )
	audacious? ( >=media-sound/audacious-1.5.1 )
	banshee? ( >=media-sound/banshee-1.4 )
	exaile? ( >=media-sound/exaile-0.3 )
	mpd? (
		>=media-sound/mpd-0.13.2
		>=dev-python/python-mpd-0.2
	)
	mplayer? ( media-video/mplayer )
	quodlibet? ( >=media-sound/quodlibet-2.2 )
	rhythmbox? (
		>=media-sound/rhythmbox-0.11.5
		dev-python/gconf-python
	)
	totem? ( >=media-video/totem-2.22 )
	tvtime? ( >=media-tv/tvtime-0.9.11 )
	vlc? ( >=media-video/vlc-0.9[dbus] )"

RESTRICT_PYTHON_ABIS="3.*"
S=${WORKDIR}/${MY_P}

DOCS="doc/AUTHORS doc/CHANGES doc/README doc/api.html"

src_compile() {
	local adapter
	export REMUCO_CLIENT_DEST="share/${P}/client"
	export REMUCO_COMPONENTS

	for adapter in ${IUSE}; do
		use ${adapter} && REMUCO_COMPONENTS+="${adapter},"
	done
	REMUCO_COMPONENTS=${REMUCO_COMPONENTS%,}

	distutils_src_compile

	if use client; then
		ANT_TASKS="ant-nodeps ant-apache-regexp"
		eant -f client/midp/libgen/build.xml \
			-Dproguard.jar=$(java-pkg_getjars proguard) \
			setup

		eant -f client/midp/build.xml dist
	fi
}

pkg_postinst() {
	distutils_pkg_postinst

	if use client; then
		einfo "The JAR and JAD files for your mobile phone or other J2ME"
		einfo "device can be found in /usr/share/${P}/client"
	else
		einfo "Both MIDP and Android clients can be found in the official binary tarball:"
		einfo "http://${PN}.googlecode.com/files/${P}.tar.gz"
	fi
	einfo
	einfo "For the usage info take a look at:"
	einfo "${HOMEPAGE}/wiki/GettingStarted#Usage"
}
