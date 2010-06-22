# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=2
PYTHON_DEPEND="2:2.5"
SUPPORT_PYTHON_ABIS="1"
RESTRICT_PYTHON_ABIS="3.*"

inherit distutils python

DESCRIPTION="A server and J2ME client to control various media players"
HOMEPAGE="http://code.google.com/p/remuco"
SRC_URI="http://${PN}.googlecode.com/files/${P}.tar.gz"
LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="amarok audacious banshee exaile mpd mplayer quodlibet rhythmbox totem tvtime vlc"

DEPEND="dev-python/dbus-python
	dev-python/imaging
	dev-python/pybluez
	dev-python/pygobject
	dev-python/pyxdg"

RDEPEND="${DEPEND}
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

DOCS="doc/AUTHORS doc/CHANGES doc/README doc/api.html"

src_compile() {
	local adapter
	export REMUCO_CLIENT_DEST="share/${P}/client"
	export REMUCO_COMPONENTS="client"

	for adapter in ${IUSE}; do
		use ${adapter} && REMUCO_COMPONENTS="${REMUCO_COMPONENTS},${adapter}"
	done

	distutils_src_compile
}

pkg_postinst() {
	distutils_pkg_postinst

	einfo "The JAR and JAD files for your mobile phone or other J2ME device can"
	einfo "be found in /usr/share/${P}/client."
	einfo
	einfo "For the usage info take a look at:"
	einfo "${HOMEPAGE}/wiki/GettingStarted#Usage"
}
