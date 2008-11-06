# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="1"
inherit qt4 eutils

MY_P="${P/_/}"
DESCRIPTION="A drawing editor which creates figures for inclusion in LaTeX documents and makes PDF presentations."
HOMEPAGE="http://tclab.kaist.ac.kr/ipe/"
SRC_URI="http://luaforge.net/frs/download.php/3824/${MY_P}-src.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="seamonkey"

DEPEND=">=x11-libs/qt-4.2:4
	>=media-libs/freetype-2.1.8"
# The virtual/tetex dep is for pdfLaTeX and URW fonts.
RDEPEND="${DEPEND}
	virtual/latex-base
	!seamonkey? ( || ( www-client/mozilla-firefox
		www-client/mozilla-firefox-bin ) )
	seamonkey? ( || ( www-client/seamonkey
		www-client/seamonkey-bin ) )"

S="${WORKDIR}/${MY_P}/src"

search_urw_fonts() {
	local texmfdist="$(kpsewhich -var-value=TEXMFDIST)"	# colon-separated list of paths
	local urwdir=fonts/type1/urw	# according to TeX directory structure
	local IFS="${IFS}:"		# add colon as field separator
	for dir in ${texmfdist}; do
		if [[ -d "${dir}/${urwdir}" ]]; then
			URWFONTDIR="${dir}/${urwdir}"
			return 0
		fi
	done

	return 1
}

pkg_setup() {
	if has_version ">=x11-libs/qt-4.2.2" ; then
		QT4_BUILT_WITH_USE_CHECK="qt3support"
		qt4_pkg_setup
	fi

	if search_urw_fonts; then
		einfo "URW fonts found in ${URWFONTDIR}."
	else
		ewarn "Could not find directory containing URW fonts.  Ipe will not"
		ewarn "function properly without them."
	fi
}

src_compile() {
	# Ipe's default browser is Firefox
	local myconf
	use seamonkey && myconf="IPEBROWSER=seamonkey"

	eqmake4 main.pro \
		${myconf} \
		"IPEPREFIX=/usr" \
		"IPEDOCDIR=/usr/share/doc/${PF}"
	emake || die "emake failed"
}

src_install() {
	emake install INSTALL_ROOT="${D}" || die "emake install failed"

	cd "${WORKDIR}"/${MY_P}
	local fontmapdir=/usr/share/${PN}/${MY_P/${PN}-/}
	if [ -n ${URWFONTDIR} ]; then
		einfo "Creating fontmap ..."
		sed -e "s:/usr/share/texmf/fonts/type1/urw:${URWFONTDIR}:" \
			tetex-fontmap.xml > "${D}/${fontmapdir}/fontmap.xml"
		eend $?
	fi

	dodoc install.txt news.txt readme.txt
}
