# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

CMAKE_MIN_VERSION="2.8.4"

inherit cmake-utils

DESCRIPTION="Advanced and secure webserver"
HOMEPAGE="http://www.hiawatha-webserver.org"
SRC_URI="http://www.hiawatha-webserver.org/files/${P}.tar.gz"

# NB: version 9.1.1 is a "Gentoo-only" release, which removed the dependency on
# the bundled PolarSSL
# --> it is not anounced on the hiawatha homepage

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64"
IUSE="debug +cache chroot ipv6 monitor +rewrite rproxy ssl tomahawk xsl"

DEPEND="
	sys-libs/zlib
	ssl? ( >=net-libs/polarssl-1.2 )
	xsl? (	dev-libs/libxslt
			dev-libs/libxml2 )"

RDEPEND="${DEPEND}"
PDEPEND="monitor? ( www-apps/hiawatha-monitor )"

src_configure() {
	local mycmakeargs=(
		$(cmake-utils_use_enable cache CACHE)
		$(cmake-utils_use_enable chroot CHROOT)
		$(cmake-utils_use_enable ipv6 IPV6)
		$(cmake-utils_use_enable debug DEBUG)
		$(cmake-utils_use_enable monitor MONITOR)
		$(cmake-utils_use_enable rewrite TOOLKIT)
		$(cmake-utils_use_enable rproxy RPROXY)
		$(cmake-utils_use_enable ssl SSL)
		$(cmake-utils_use_use    ssl SYSTEM_POLARSSL)
		$(cmake-utils_use_enable xsl XSLT)

		$(cmake_utils_use_enable kernel_linux LOADCHECK)
		-DLOG_DIR:STRING=/var/log/hiawatha
		-DPID_DIR:STRING=/var/run
		-DWEBROOT_DIR:STRING=/var/www/hiawatha
		-DWORK_DIR:STRING=/var/lib/hiawatha
		-DCONFIG_DIR:STRING=/etc/hiawatha
		)
	cmake-utils_src_configure
}

src_install() {
	cmake-utils_src_install

	newinitd "${FILESDIR}"/hiawatha.initd  hiawatha

	keepdir /var/{lib,log}/hiawatha
}
