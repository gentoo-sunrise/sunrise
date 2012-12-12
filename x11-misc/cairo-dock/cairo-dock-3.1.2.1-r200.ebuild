# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="5"

inherit cmake-utils versionator

MY_PN="${PN}-core"
MY_PV=$(get_version_component_range '1-2')
MY_PVL=$(get_version_component_range '1-3')

DESCRIPTION="The only OpenGL & OpenSource dock!"
HOMEPAGE="http://www.glx-dock.org"
SRC_URI="http://launchpad.net/${MY_PN}/${MY_PV}/${MY_PVL}/+download/${P}.tar.gz"

LICENSE="GPL-3"
SLOT="2"
KEYWORDS="~amd64"
IUSE=""

LANGS="ar be bn ca cs cy de el en eo es et eu fi fo fr gl he hu id it ja ko nb nl oc pl pt_BR pt ro ru sk sl sr sv tr uk vi zh_CN zh_TW"
for lang in ${LANGS}; do
	IUSE+=" linguas_${lang}"
done
unset lang

RDEPEND="
	!x11-misc/cairo-dock:3
	dev-libs/atk
	dev-libs/dbus-glib
	dev-libs/glib:2
	dev-libs/libxml2:2
	gnome-base/librsvg:2
	media-libs/fontconfig
	media-libs/freetype:2
	net-misc/curl
	sys-apps/dbus
	virtual/glu
	virtual/libintl
	virtual/opengl
	x11-libs/cairo
	x11-libs/gdk-pixbuf:2
	x11-libs/gtk+:2
	x11-libs/gtkglext
	x11-libs/libX11
	x11-libs/libXcomposite
	x11-libs/libXinerama
	x11-libs/libXrandr
	x11-libs/libXrender
	x11-libs/libXtst
	x11-libs/pango[X]"

DEPEND="${RDEPEND}
	sys-devel/gettext
	virtual/pkgconfig
	x11-proto/xproto"

PDEPEND="=x11-plugins/cairo-dock-plugins-${MY_PVL}*:2"

S="${WORKDIR}/${PN}-${MY_PVL}"

src_prepare() {

	# Remove forced gcc optimization level

	sed -i -e 's/add_definitions (-O3)//' "${S}/CMakeLists.txt" || die "sed failed"

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

	local mycmakeargs=(
		-Dforce-gtk2=yes
		-DCMAKE_SKIP_BUILD_RPATH=ON
	  	-DCMAKE_INSTALL_RPATH_USE_LINK_PATH=ON
	)
	cmake-utils_src_configure
}
