# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=4

inherit eutils toolchain-funcs multilib

DESCRIPTION="Takes node.js' architecture and dependencies and fits it in the Lua language"
HOMEPAGE="http://luvit.io/"
SRC_URI="http://${PN}.io/dist/${PV}/${P}.tar.gz"

KEYWORDS="~amd64 ~x86"
SLOT="0"
IUSE=""
LICENSE="Apache-2.0 MIT"

# fails in portage environment
# succeeds if run manually
RESTRICT="test"

RDEPEND="dev-lang/luajit:2
	dev-libs/openssl:0
	>=dev-libs/yajl-2.0.2
	>=dev-lua/luacrypto-0.3.1
	net-libs/http-parser
	=dev-libs/libuv-0.7.6_p20120404
	sys-libs/zlib"
DEPEND="${RDEPEND}
	virtual/pkgconfig"

src_prepare() {
	epatch "${FILESDIR}"/${PVR}-makefile.patch

	sed \
		-e "s:^YAJL_VERSION=.*:YAJL_VERSION=$(pkg-config --modversion yajl):" \
		-e "s:^LUAJIT_VERSION=.*:LUAJIT_VERSION=$(pkg-config --modversion luajit):" \
		-e "s:^UV_VERSION=.*:UV_VERSION=0.7.6_p20120404:" \
		-i Makefile || die "sed failed"
}

src_configure() {
	# skip python build system
	:
}

src_compile() {
	rm -r deps || die

	tc-export CC AR
	emake PREFIX=/usr all
}

src_install() {
	emake \
		PREFIX=/usr \
		LIBDIR=$(get_libdir) \
		DESTDIR="${D}" \
		install
}
