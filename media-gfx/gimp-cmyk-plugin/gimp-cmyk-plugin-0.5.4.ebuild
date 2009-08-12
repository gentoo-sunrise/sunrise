# Copyright 2007-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit base toolchain-funcs

MY_P="separate+-${PV}"

DESCRIPTION="Gimp CMYK plug-in."
HOMEPAGE="http://cue.yellowmagic.info/softwares/separate.html"
SRC_URI="mirror://sourceforge.jp/separate-plus/41810/${MY_P}.zip
	 http://download.adobe.com/pub/adobe/iccprofiles/win/AdobeICCProfilesCS4Win_end-user.zip"

LICENSE="GPL-2 Adobe"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND="media-libs/lcms
	media-libs/tiff
	media-gfx/gimp"
DEPEND="${RDEPEND}"

S="${WORKDIR}/${MY_P}"

PATCHES=(
	"${FILESDIR}"/${PV}-Makefile.patch
	)

src_compile() {
	emake \
		CC="$(tc-getCC)" \
		|| die "compilation failed"
}

src_install() {
	emake PREFIX="${D}/usr" install || die "emake install failed"
	insinto /usr/share/color/icc
	doins -r sRGB || die "doins failed installing sRGB icc profiles"
	cd "${WORKDIR}/Adobe ICC Profiles (end-user)"
	doins -r CMYK RGB || die "doins failed installing Adobe CMYK and RGB icc profiles"
}
