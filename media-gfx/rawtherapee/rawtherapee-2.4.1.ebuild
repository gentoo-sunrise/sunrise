# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="2"

inherit versionator

MY_PV=$(delete_all_version_separators)
MY_P=${PN}${MY_PV}
MY_PN=RawTherapee

DESCRIPTION="THe Experimental RAw Photo Editor"
HOMEPAGE="http://www.rawtherapee.com/"
SRC_URI=" x86? ( http://www.rawtherapee.com/${MY_P}.tgz )
	  amd64? ( http://www.rawtherapee.com/${MY_P}_64.tgz ) "

LICENSE="freedist"
SLOT="0"
KEYWORDS="~amd64 ~x86"

IUSE=""
LANGS="cs da de en_US en_GB el es eu fr he hu it ja lv nl nn pl ru sk fi sv tr zh_CN zh_TW"
for lng in ${LANGS}; do
	IUSE="${IUSE} linguas_${lng}"
done

RDEPEND="dev-cpp/gtkmm:2.4
	media-libs/jpeg
	media-libs/tiff
	media-libs/libpng"

RESTRICT="strip"

S=${WORKDIR}/${MY_PN}${MY_PV}

src_install() {
	insinto "/usr/share/pixmaps"
	doins "${FILESDIR}/${PN}.png" || die
	insinto "/usr/share/applications"
	doins "${FILESDIR}/${PN}.desktop" || die
	dobin "${FILESDIR}/rtstart" || die

	exeinto "/opt/${MY_PN}"
	doexe rt librtengine.so rtstart rwz_sdk.so || die

	insinto "/opt/${MY_PN}"
	doins -r options images profiles themes || die

	insinto "/opt/${MY_PN}/languages"
	doins "languages/english-us" || die # Always install english lang. file

	for lng in ${LINGUAS}; do
		case $lng in
			cs) doins "languages/czech" || die ;;
			da) doins "languages/dansk" || die ;;
			de) doins "languages/deutsch" || die ;;
			en_GB) doins "languages/english-uk" || die ;;
			es) doins "languages/espanol" || die ;;
			eu) doins "languages/euskara" || die ;;
			el) doins "languages/greek" || die ;;
			fr) doins "languages/francais" || die ;;
			he) doins "languages/hebrew" || die ;;
			hu) doins "languages/magyar" || die ;;
			it) doins "languages/italian" || die ;;
			ja) doins "languages/japanese" || die ;;
			lv) doins "languages/latvian" || die ;;
			nl) doins "languages/nederlands" || die ;;
			nn) doins "languages/norsk-bm" || die ;;
			pl) doins "languages/polish" || die ;;
			ru) doins "languages/russian" || die ;;
			sk) doins "languages/slovak" || die ;;
			fi) doins "languages/suomi" || die ;;
			sv) doins "languages/swedish" || die ;;
			tr) doins "languages/turkish" || die ;;
			zh_CN) doins "languages/chinese simplified" || die ;;
			zh_TW) doins "languages/chinese traditional" || die ;;
		esac
	done
}
