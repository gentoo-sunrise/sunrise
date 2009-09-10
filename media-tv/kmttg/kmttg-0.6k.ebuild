# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="2"
JAVA_PKG_IUSE="source"

inherit eutils java-pkg-2 java-ant-2

DESCRIPTION="A free multi-platform replacement for the TiVo Desktop software."
HOMEPAGE="http://code.google.com/p/kmttg/"
SRC_URI="http://omploader.org/vMmFqbA/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="encode"

RDEPEND="encode? ( media-video/ffmpeg )
	media-video/tivodecode
	net-misc/curl
	>=virtual/jre-1.5"
DEPEND=">=virtual/jdk-1.5"

src_prepare() {
	epatch "${FILESDIR}/${PN}-settings.patch"
}

src_install() {
	java-pkg_dojar release/kmttg.jar
	java-pkg_dolauncher kmttg --java_args "-Djava.net.preferIPv4Stack=true -Xmx256m"

	insinto /usr/share/${PN}/encode
	doins release/encode/*.enc || die

	use source && java-pkg_dosrc src/com
}
