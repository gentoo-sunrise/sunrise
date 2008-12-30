# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=1

inherit eutils

DESCRIPTION="High-performance, two-pass large vocabulary continuous speech recognition"
HOMEPAGE="http://julius.sourceforge.jp/en_index.php"
SRC_URI="mirror://sourceforge.jp/${PN}/33146/${P}.tar.gz"

LICENSE="julius"
SLOT="0"
KEYWORDS="~x86"
IUSE=""

LANGS="ja"

for LNG in ${LANGS}; do
	IUSE="${IUSE} linguas_${LNG}"
done

DEPEND=">=sys-libs/readline-4.1
	media-libs/alsa-lib
	media-libs/libsndfile
	sys-libs/zlib"

src_unpack() {
	unpack ${A}
	cd "${S}"
	epatch "${FILESDIR}"/julius-4.1-makefile.patch
	epatch "${FILESDIR}"/julius-4.1-newParam.patch
	epatch "${FILESDIR}"/julius-4.1-mkfacrash.patch
}

src_install() {
	emake DESTDIR="${D}" install
	dodoc 00readme.txt Release.txt || die

	for LNG in ${LINGUAS}; do
		dodoc 00readme-${LNG}.txt Release-${LNG}.txt || die
	done
}
