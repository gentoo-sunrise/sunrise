# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit toolchain-funcs

SLOT="2"
MY_P="${PN}${SLOT}-${PV}"

DESCRIPTION="a general purpose messaging, notification and menuing program for
X11."
HOMEPAGE="http://gotmor.googlepages.com/dzen"
SRC_URI="http://gotmor.googlepages.com/${MY_P}.tar.gz"

LICENSE="MIT"
KEYWORDS="~x86"
IUSE=""

RDEPEND="x11-libs/libX11"
DEPEND="${RDEPEND}
	x11-proto/xineramaproto"

S=${WORKDIR}/${MY_P}

src_unpack() {
	unpack ${A}
	cd "${S}"
	sed -e "s:/usr/local:/usr:g" -e "s/-Os/${CFLAGS}/g" \
		-e "/CC/s:cc:$(tc-getCC):" \
		-i config.mk || die "sed failed"
}

src_install() {
	emake DESTDIR="${D}" install || die "emake install failed"
	dodoc README
}
