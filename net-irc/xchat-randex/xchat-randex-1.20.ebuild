# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="4"

inherit multilib

DESCRIPTION="XChat plugin for entropy exchange over IRC"
HOMEPAGE="http://www.mirbsd.org/"

# Version of arc4random.c to use for build
MY_ARC4RANDOM_V="1.28"

SRC_URI="http://www.mirbsd.org/MirOS/dist/hosted/xchat-randex/${P}.tar.gz
	http://www.mirbsd.org/MirOS/dist/hosted/other/arc4random.c.${MY_ARC4RANDOM_V}
	"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND="net-irc/xchat"

S="${WORKDIR}/${PN}"

src_unpack() {
	default

	cp "${DISTDIR}/arc4random.c.${MY_ARC4RANDOM_V}" "${S}/arc4random.c"
}

src_compile() {
	emake -f Make_lnx
}

src_install() {
	insinto "/usr/$(get_libdir)/xchat/plugins"

	doins randex.so
	dodoc README
}
