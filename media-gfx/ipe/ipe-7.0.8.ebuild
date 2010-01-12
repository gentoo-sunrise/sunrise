# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="2"
inherit eutils toolchain-funcs qt4-r2

DESCRIPTION="A drawing editor which creates figures for inclusion in LaTeX documents and makes PDF presentations."
HOMEPAGE="http://tclab.kaist.ac.kr/ipe/"
SRC_URI="mirror://sourceforge/ipe7/ipe/${P}-src.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="seamonkey"

DEPEND=">=x11-libs/qt-core-4.5:4
	>=x11-libs/qt-gui-4.5:4
	>=media-libs/freetype-2.1.8
	>=x11-libs/cairo-1.8.0
	>=dev-lang/lua-5.1
	app-text/texlive-core"

RDEPEND="${DEPEND}
	!seamonkey? ( || ( www-client/mozilla-firefox
		www-client/mozilla-firefox-bin ) )
	seamonkey? ( || ( www-client/seamonkey
		www-client/seamonkey-bin ) )"

S=${S}/src

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
	# fix detection of lua
	sed -i -e 's/lua5.1/lua/g' config.mak || die
	# don't strip installed binaries
	sed -i -e 's/install -s/install/' common.mak || die

	# -j1, since there are no deps in the Makefiles on libipe
	emake -j1 CXX=$(tc-getCXX) $myconf IPEPREFIX="/usr" IPEDOCDIR="/usr/share/doc/${PF}" || die "emake failed"
}

src_install() {
	emake install IPEPREFIX="/usr" IPEDOCDIR="/usr/share/doc/${PF}" INSTALL_ROOT="${D}" || die "emake install failed"
	dodoc ../{news,readme}.txt || die
}
