# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit eutils

MY_P="${P/-bin}Ed"

DESCRIPTION="Latin--English dictionary."
HOMEPAGE="http://users.erols.com/whitaker/words.htm"
SRC_URI="http://atrey.karlin.mff.cuni.cz/~sanda/mirror/${MY_P}-linux.tar.gz"

SLOT="0"
LICENSE="words"
KEYWORDS="~x86"

IUSE=""
DEPEND=""
RDEPEND=""

S="${WORKDIR}/${MY_P}"

src_unpack(){
	unpack ${A}
	cd "${S}"
	epatch "${FILESDIR}"/words_dir.patch
}

src_install() {
	insinto /opt/${MY_P}
	dodoc wordsdoc*
	rm wordsdoc*
	doins *
	dosym /opt/${MY_P}/latin /usr/bin/latin
	fperms 755 /opt/${MY_P}/{latin,words}
}

pkg_postinst() {
	elog "Dictionary is launched through 'latin' command"
}
