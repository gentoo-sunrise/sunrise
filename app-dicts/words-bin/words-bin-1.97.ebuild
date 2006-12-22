# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit eutils

MY_P="${P/-bin}"

DESCRIPTION="Latin-English dictionary."
HOMEPAGE="http://users.erols.com/whitaker/words.htm"
SRC_URI="ftp://petrus.thomasaquinas.edu/pub/linux/words/${MY_P}-linux.tar.gz"

SLOT="0"
LICENSE="words"
KEYWORDS="~x86"

IUSE=""
DEPEND=""
RDEPEND=""

S=${WORKDIR}/${MY_P}

src_unpack(){
	unpack ${A}
	cd "${S}"
	epatch "${FILESDIR}"/words_dir.patch
}

src_install() {
	insinto /opt/${MY_P}
	dodir /usr/bin
	dodoc wordsdoc*
	rm wordsdoc*
	doins *
	dosym "${D}"/opt/${MY_P}/latin /usr/bin/latin
	fperms 755 /opt/${MY_P}/{latin,words}
}

pkg_postinst() {
	elog "Dictionary is launched through 'latin' command"
}
