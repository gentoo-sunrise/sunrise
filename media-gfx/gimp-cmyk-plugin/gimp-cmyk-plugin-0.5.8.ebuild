# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=4

inherit eutils multilib toolchain-funcs

MY_P="separate+-${PV}"
SFNUM="47873"

DESCRIPTION="Gimp CMYK plug-in."
HOMEPAGE="http://cue.yellowmagic.info/softwares/separate.html"
SRC_URI="
	mirror://sourceforge.jp/separate-plus/${SFNUM}/${MY_P}.zip -> ${P}.zip
	http://download.adobe.com/pub/adobe/iccprofiles/win/AdobeICCProfilesCS4Win_end-user.zip"

LICENSE="GPL-2 Adobe"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND="media-gfx/gimp
	virtual/jpeg
	media-libs/lcms:0
	media-libs/tiff"
DEPEND="${RDEPEND}
	app-arch/unzip"

S=${WORKDIR}/${MY_P}

src_prepare() {
	epatch "${FILESDIR}"/${PV}-Makefile.patch
	sed -e "s:GENTOOLIBDIR:$(get_libdir):g" -i Makefile || die
}

src_compile() {
	emake CC="$(tc-getCC)"
}

src_install() {
	emake PREFIX="${D}/usr" install
	insinto /usr/share/color/icc
	doins -r sRGB
	cd "${WORKDIR}/Adobe ICC Profiles (end-user)"
	doins -r CMYK RGB
}
