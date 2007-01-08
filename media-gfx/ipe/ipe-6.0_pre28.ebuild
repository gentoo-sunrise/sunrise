# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit qt4

MY_P="${P/_/}"
DESCRIPTION="An extensible drawing editor which creates figures for inclusion in LaTeX documents and makes PDF presentations."
HOMEPAGE="http://ipe.compgeom.org/"
SRC_URI="http://ipe.compgeom.org/${MY_P}-src.tar.gz
	http://tclab.kaist.ac.kr/ipe/${MY_P}-src.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86"
IUSE="firefox"

DEPEND="$(qt4_min_version 4.2)
	>=media-libs/freetype-2.1.8"
# The virtual/tetex dep is for pdfLaTeX and URW fonts.
RDEPEND="${DEPEND}
	virtual/tetex
	firefox? ( || ( www-client/mozilla-firefox
		www-client/mozilla-firefox-bin ) )"


S="${WORKDIR}/${MY_P}/src"

search_urw_fonts() {
	local texmfdist="$(kpsewhich -var-value=TEXMFDIST)" # colon-separated
														# list of paths
	local urwdir=fonts/type1/urw # according to TeX directory structure
	IFS="${IFS}:"				 # add colon as field separator
	for dir in ${texmfdist}; do
		if [[ -d "${dir}/${urwdir}" ]]; then
			URWFONTDIR="${dir}/${urwdir}"
			return 0
		fi
	done
	return 1
}

pkg_setup() {
	search_urw_fonts
	if [ $? -eq 0 ]; then
		einfo "URW fonts found in ${URWFONTDIR}."
	else
		ewarn "Could not find directory containing URW fonts.  Ipe will not"
		ewarn "function properly without them."
	fi
}

src_compile() {
	# until Ipe bug #206 is not resolved...
	# local myconf
	# use firefox && myconf="IPEBROWSER=firefox"
	use firefox && \
		sed -i -e "s/IPEBROWSER = mozilla/IPEBROWSER = firefox/" config.pri
	qmake \
		"IPEPREFIX=/usr" \
		"IPEDOCDIR=/usr/share/doc/${PF}" \
		${myconf} \
		main.pro || die "qmake failed"
	emake || die "emake failed"
}

src_install() {
	emake install "INSTALL_ROOT=${D}" || die "emake install failed"
	cd ${WORKDIR}/${MY_P}
	local fontmapdir=/usr/share/${PN}/${MY_P/${PN}-/}
	if [ -n ${URWFONTDIR} ]; then
		einfo "Creating fontmap ..."
		sed -e "s:/usr/share/texmf/type1/urw:${URWFONTDIR}:" \
			tetex-fontmap.xml > ${D}/${fontmapdir}/fontmap.xml
		eend $?
	fi
	dodoc install.txt news.txt readme.txt
}
