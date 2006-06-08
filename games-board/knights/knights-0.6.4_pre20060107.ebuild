# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit eutils kde cvs

ECVS_SERVER="knights.cvs.sourceforge.net:/cvsroot/${PN}"
ECVS_MODULE="${PN}"
ECVS_CO_OPTS="-D ${PV#*_pre}"
ECVS_UP_OPTS="-dP ${ECVS_CO_OPTS}"

S=${WORKDIR}/${ECVS_MODULE}

MY_PV=${PV/_/-}
THEME=${PN}-themepack-0.5.9
DESCRIPTION="KDE Chess Interface"
HOMEPAGE="http://knights.sourceforge.net/"
SRC_URI="mirror://sourceforge/knights/${THEME}.tar.gz"
S="${WORKDIR}/${PN}"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86 ~ppc ~sparc ~amd64"
IUSE=""

DEPEND="|| ( kde-base/kdebase-kioslaves
		kde-base/kdebase )"
RDEPEND="${DEPEND}"

need-kde 3

src_unpack() {
	cvs_src_unpack
	cd ${WORKDIR}
	unpack ${A}
	cd ${S}
	sed -i "s:\(the same spot\):\1\n/*:" knights/logic.cpp || die "sed failed"
	sed -i "s:\(// restore the backup\):*/\n\t\t}\n\t}\n\t\1:" \
		knights/logic.cpp || die "sed failed"
	sed -i "s:head -\([0-9]\+\):head -n \1:" admin/cvs.sh || die "sed failed"
	sed -i "s: theme.cpp::" knights/Makefile.am || die "sed failed"

	epatch ${FILESDIR}/knights-no-arts.patch

	make -f Makefile.dist || die "make -f Makefile.dist failed"
}

src_install() {
	kde_src_install

	cd ../${PN}-themepack || die "Themes seem to be missing."
	insinto /usr/share/apps/knights/themes
	doins *.tar.gz || die "doins failed"
}
