# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

DESCRIPTION="Tool to create virtual dsp to connect OSS-based apps to jack"
HOMEPAGE="http://fort2.xdas.com/~kor/oss2jack/"
SRC_URI="http://fort2.xdas.com/~kor/oss2jack/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86"
IUSE=""

DEPEND="media-libs/libsamplerate
	media-sound/fusd-kor
	sys-apps/realtime-lsm"
RDEPEND=${DEPEND}

src_compile() {
	econf --with-fusd=/usr || die "configure failed"
	emake || die "emake failed"
}

src_install() {
	dobin "${S}"/src/oss2jack/oss2jack
	dodoc README
}

pkg_postinst() {
	elog "To use oss2jack you need to first start jackd"
	elog "and then run oss2jack to create the dsp device"
}
