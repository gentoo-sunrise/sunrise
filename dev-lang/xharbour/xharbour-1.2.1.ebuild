# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit base toolchain-funcs

DESCRIPTION="An extended implementation of the Clipper dialect of the xBase language family"
HOMEPAGE="http://www.xharbour.org/"
SRC_URI="mirror://sourceforge/${PN}/${P}.src.tar.gz"

LICENSE="GPL-2-with-exceptions"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="allegro doc gpm slang threads X"

RDEPEND="sys-libs/ncurses
	dev-db/unixODBC
	allegro? ( media-libs/allegro )
	gpm? ( sys-libs/gpm )
	slang? ( sys-libs/slang )
	X? ( media-libs/freetype
		 x11-libs/libX11
		 x11-libs/libXext
		 x11-libs/libXmu
		 x11-libs/libXpm
		 x11-libs/libXt )"
DEPEND="${RDEPEND}
	sys-devel/bison"

src_compile() {
	# xHarbour uses environment vars to configure the build
	export \
		C_USR="${CFLAGS}" \
		L_USR="${LDFLAGS}" \
		HB_GTALLEG=$(use allegro && echo yes) \
		HB_GPM_MOUSE=$(use gpm && echo yes) \
		HB_WITHOUT_GTSLN=$(use slang || echo yes) \
		HB_MT=$(use threads && echo MT) \
		HB_WITHOUT_X11=$(use X || echo yes) \
		HB_COMPILER="gcc" \
		HB_CMP="$(tc-getCC)" \
		HB_ARCHITECTURE="$(uname -s | sed -e 's/-//g;y/BDFHLNOPSUX/bdfhlnopsux/;s/.*bsd/bsd/')" \
		HB_GT_LIB="gtstd" \
		HB_MULTI_GT="yes" \
		HB_COMMERCE="no"
	emake -j1 || die
}

src_test() {
	emake -C utils/hbtest || die
	utils/hbtest/*/*/hbtest
	einfo "In general, the package works if 'Total calls passed' figure above"
	einfo "is 90% or greater."
}

src_install() {
	# xHarbour uses environment vars to configure the install
	export _DEFAULT_BIN_DIR=/usr/bin
	export _DEFAULT_INC_DIR=/usr/include/xharbour
	export _DEFAULT_LIB_DIR=/usr/lib/xharbour
	export HB_BIN_INSTALL="${D}"/usr/bin
	export HB_INC_INSTALL="${D}"/usr/include/xharbour
	export HB_LIB_INSTALL="${D}"/usr/lib/xharbour
	emake install || die

	insinto /etc/harbour
	doins source/rtl/gtcrs/hb-charmap.def || die
	cat > "${D}"/etc/harbour.cfg <<-EOF
		CC=$(tc-getCC)
		CFLAGS=-c -I${_DEFAULT_INC_DIR} ${CFLAGS}
		VERBOSE=YES
		DELTMP=YES
	EOF

	# build utils with shared libs
	L_USR="${L_USR} -L${HB_LIB_INSTALL} -l${PN}"
	export PRG_USR="\"-D_DEFAULT_INC_DIR='${_DEFAULT_INC_DIR}'\""
	for utl in hbdict hbmake hbpp hbrun xbscript; do
		emake -C utils/${utl} install || die
	done

	dosym xbscript /usr/bin/pprun
	dosym xbscript /usr/bin/xprompt

	# remove unused files
	rm -f "${HB_BIN_INSTALL}"/{hbdict*.hit,gharbour,harbour-link}

	dodoc ChangeLog || die
	if ! has nodoc ${FEATURES} && use doc; then
		dodoc doc/*.txt || die
		strip-linguas en es
		for LNG in ${LINGUAS}; do
			docinto "${LNG}"
			dodoc doc/${LNG}/*.txt || die
		done
		docinto ct
		dodoc doc/en/ct/*.txt || die
	fi
}
