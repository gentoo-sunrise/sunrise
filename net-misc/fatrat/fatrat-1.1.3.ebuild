# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="2"

inherit cmake-utils

DESCRIPTION="Qt4-based download/upload manager"
HOMEPAGE="http://fatrat.dolezel.info/"
SRC_URI="http://www.dolezel.info/download/data/${PN}/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="bittorrent +curl doc jabber nls webinterface"

RDEPEND="dev-libs/qtgui:4[dbus]
	dev-libs/qtsvg:4
	bittorrent? ( >=net-libs/rb_libtorrent-0.14.5
			>=dev-cpp/asio-1.1.0
			dev-libs/qtwebkit:4 )
	curl? ( >=net-misc/curl-7.18.2 )
	doc? ( dev-libs/qthelp:4 )
	jabber? ( net-libs/gloox )
	webinterface? ( x11-libs/qt-script:4 )"
DEPEND="${RDEPEND}
	nls? ( sys-devel/gettext )"

src_configure() {
		local mycmakeargs="
			$(cmake-utils_use_with bittorrent) \
			$(cmake-utils_use_with curl) \
			$(cmake-utils_use_with doc DOCUMENTATION) \
			$(cmake-utils_use_with jabber) \
			$(cmake-utils_use_with nls) \
			$(cmake-utils_use_with webinterface)"
		cmake-utils_src_configure
}

src_install() {
	use bittorrent && echo "MimeType=application/x-bittorrent;" >> "${S}"/data/${PN}.desktop
	cmake-utils_src_install
}

pkg_postinst() {
	# this is a completely optional and NOT automagic dep
	if ! has_version dev-libs/geoip; then
		elog "If you want the GeoIP support, then emerge dev-libs/geoip."
	fi
}
