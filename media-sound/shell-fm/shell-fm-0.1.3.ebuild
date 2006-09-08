# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit eutils toolchain-funcs

DESCRIPTION="Command line radio player for Last.fm"
HOMEPAGE="http://lizer.syslinx.org/shell-fm/"
SRC_URI="${HOMEPAGE}/releases/${P/-/.}.tar.bz2"
S=${WORKDIR}/${PN}

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~ppc ~x86"
IUSE=""

DEPEND=">=sys-libs/readline-4.3
	>=media-libs/libmad-0.15
	>=dev-libs/openssl-0.9"
RDEPEND="${DEPEND}"


src_unpack() {
	unpack ${A}
	cd "${S}"
	epatch "${FILESDIR}/${P}-makefile.patch"
}

src_compile() {
	# Just in case... It comes with a x86 precompiled binary!
	rm -f shell-fm
	emake CC="$(tc-getCC)" || die "emake failed"
}

src_install() {
	dobin shell-fm
	dodoc shell-fm.rc-example
}

pkg_postinst() {
	elog "Sample config file has been installed into ${ROOT}usr/share/doc/${PF}"
}
