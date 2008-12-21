# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="1"
inherit eutils kde

KEYWORDS="~x86"

MY_P=${P/kmp/KmP}

DESCRIPTION="A graphical MPEG2 encoder frontend, for producing 100% DVD compatible MPEG2 streams."
HOMEPAGE="http://sourceforge.net/projects/kmpg2"
SRC_URI="mirror://sourceforge/${PN}/${MY_P}.tar.bz2"
LICENSE="GPL-2"
SLOT="0"
IUSE=""

DEPEND=""
RDEPEND="|| ( kde-base/kommander:3.5 kde-base/kdewebdev:3.5 )
	media-video/ffmpeg
	media-video/transcode
	media-sound/sox
	media-video/y4mscaler
	>=media-video/mjpegtools-1.8.0"

need-kde 3.5

S=${WORKDIR}/${MY_P}

src_unpack() {
	unpack ${A}
	cp "${FILESDIR}/kmpg2.desktop" "${FILESDIR}/kmpg2profiler.desktop" "${S}"
	cd "${S}"

	sed -i \
		-e "s#/\(Profiles\)#/../share/apps/${PN}/\1#" \
		KmPg2.kmdr

	sed -i -e "s|@KDEDIR@|${KDEDIR}|" \
		kmpg2.desktop kmpg2profiler.desktop || die "sed failed"

}

src_compile() {
	einfo "This is a Kommander script, nothing to compile"
}

src_install() {
	insinto "${KDEDIR}/share/apps/${PN}"
	doins -r Profiles

	into ${KDEDIR}
	dobin KmPg2*.kmdr YUV*.sh

	domenu kmpg2.desktop kmpg2profiler.desktop

	dodoc Changelog README
}
