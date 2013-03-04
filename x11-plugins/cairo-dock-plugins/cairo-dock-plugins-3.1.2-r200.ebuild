# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="5"

PYTHON_DEPEND="2:2.7"

inherit cmake-utils python versionator

MY_PN="cairo-dock-plug-ins"
MY_PV=$(get_version_component_range '1-2')
MY_PVL=$(get_version_component_range '1-3')

DESCRIPTION="The official set of plugins for cairo-dock"
HOMEPAGE="http://www.glx-dock.org"
SRC_URI="http://launchpad.net/${MY_PN}/${MY_PV}/${MY_PVL}/+download/${P}.tar.gz"

LICENSE="GPL-3"
SLOT="2"
KEYWORDS="~amd64"
IUSE="alsa disks doncky gmenu gnome kde nwmon scooby webkit xfce"

LANGS="ar cs de el en es et eu fr he hr hu id it ja lt nb nl pl pt_BR pt ru sk sr sv tr uk zh_CN zh_TW"
for lang in ${LANGS}; do
	IUSE+=" linguas_${lang}"
done
unset lang

RDEPEND="
	!x11-plugins/cairo-dock-plugins:3
	dev-libs/atk
	dev-libs/dbus-glib
	dev-libs/glib:2
	dev-libs/libical
	dev-libs/libxml2
	gnome-base/librsvg:2
	media-libs/fontconfig
	media-libs/freetype:2
	media-libs/libexif
	net-libs/libetpan
	net-misc/curl
	sys-apps/dbus
	virtual/glu
	virtual/libintl
	virtual/opengl
	sys-apps/lm_sensors
	sys-power/upower
	x11-libs/cairo
	x11-libs/gdk-pixbuf:2
	x11-libs/gtk+:2
	x11-libs/libxklavier
	x11-libs/libX11
	x11-libs/libXcomposite
	x11-libs/libXinerama
	x11-libs/libXrandr
	x11-libs/libXrender
	x11-libs/libXtst
	x11-libs/libXxf86vm
	x11-libs/pango[X]
	x11-libs/vte:0
	=x11-misc/cairo-dock-${MY_PVL}*:2
	alsa? ( media-libs/alsa-lib )
	gmenu? ( gnome-base/gnome-menus )
	kde? (
		kde-base/kdelibs
		dev-libs/qtcore )
	webkit? ( net-libs/webkit-gtk:2 )
	xfce? ( xfce-base/thunar )"

DEPEND="${RDEPEND}
	sys-devel/gettext
	virtual/pkgconfig
	x11-proto/xproto "

S="${WORKDIR}/${PN}-${MY_PVL}"

pkg_setup() {

	python_set_active_version 2
}

src_prepare() {

	# Following adjustments done by removing parts of the CMakeLists until upstream makes these parts configuration switches dependent.

	# Remove forced gcc optimization level

	sed -i -e 's/add_definitions (-O3)//' "${S}/CMakeLists.txt"  || die "sed failed"

	# Don't build code forcing unwanted automagic dependencies on unstable / controversial / huge stuff
	sed -i \
		-e '/INDICATOR-APPLET/,/SHARED LIBRARIES/d' \
		-e '/STATUS \"> Impulse:\"/,/\#\# ILLUSION/d' \
		-e '/RECENT-EVENTS/,/\#\# REMOTE/d' \
		"${S}/CMakeLists.txt" || die

	# Don't build ruby \(until clean install possible\) \/ mono and vala bindings {I know nothing about that stuff\.\.\.\}
	# Not really sure that escape sequences are needed as part of comments but... [Semi-Private joke]

	sed -i -e '/STATUS \" \* Ruby:\"/,/GETTEXT_DBUS/ { /GETTEXT_DBUS/ !{d}}' "${S}/CMakeLists.txt"  || die "sed failed"

	# Not really needed to explicitly remove as the status notifier won't get built anyway, but some do not like the look of the build log if it is not...

	sed -i -e '/STATUS NOTIFIER/,/\#\# SWITCHER/d' "${S}/CMakeLists.txt"  || die "sed failed"

	# Localization

	local lang

	if [[ -z ${LINGUAS} ]]; then
		touch po/slctd_linguas
	else
		for lang in ${LINGUAS}; do
			echo "\"${S}\"/po/${lang}.po" >> po/slctd_linguas
		done
	fi
	sed -e "s/^\(file (\)GLOB \(PO_FILES\).*$/\1STRINGS slctd_linguas \2)/" -i po/CMakeLists.txt  || die "sed failed"
}

src_configure() {

	# Don't use standard cmake-utils_use* functions because upstream tests STREQUAL "no/yes"

	local mycmakeargs=(
		"-DROOT_PREFIX=${D}"
		$(usex alsa "" "-Denable-alsa=no")
		$(usex disks "-Denable-disks=yes")
		$(usex doncky "-Denable-doncky=yes")
		$(usex gmenu "" "-Denable-gmenu=no")
		$(usex gnome "" "-Denable-gnome-integration=no")
		$(usex kde "-Denable-kde-integration=yes" "")
		$(usex nwmon "-Denable-network-monitor=yes" "")
		$(usex scooby "-Denable-scooby-do=yes" "")
		$(usex webkit "" "-Denable-weblets=no")
		$(usex xfce "" "-Denable-xfce-integration=no")
	)
	cmake-utils_src_configure
}
