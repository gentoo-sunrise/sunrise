# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit cvs

ECVS_SERVER="panotools.cvs.sourceforge.net:/cvsroot/panotools"
ECVS_MODULE="clens"
# There is no 0.3.1 branch, we use a date instead
ECVS_CO_OPTS="-D 6/19/06"
ECVS_UP_OPTS="-dP -D 6/19/06"

DESCRIPTION="A command-line version of PTLens"
SRC_URI=""
HOMEPAGE="http://panotools.sourceforge.net/"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86"
IUSE=""

DEPEND="media-gfx/ptlens-profiles
	>=media-libs/libpano12-2.8.4"
RDEPEND="${DEPEND}"

PTLENS_PROFILES="/usr/share/ptlens/profiles/profile.txt"

S="${WORKDIR}/${ECVS_MODULE}"

src_compile() {
	./bootstrap || die "bootstrap failed"
	econf || die "econf failed"
	emake || die "emake failed"
}

src_install() {
	emake DESTDIR="${D}" install || die "emake install failed"
	echo "CLENS_PROFILE=\"${PTLENS_PROFILES}\"" > 99clens
	doenvd 99clens
}
