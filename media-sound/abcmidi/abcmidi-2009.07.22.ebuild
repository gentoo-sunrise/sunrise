# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

MY_PV=${PV//./-}
DESCRIPTION="Programs for processing ABC music notation files"
HOMEPAGE="http://abc.sourceforge.net/abcMIDI/"
SRC_URI="http://ifdo.pugmarks.com/~seymour/runabc/abcMIDI-${MY_PV}.zip"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

S=${WORKDIR}/${PN}

src_compile() {
	emake -f makefiles/unix.mak CFLAGS="-c -DANSILIBS ${CFLAGS}" \
	  || die "emake failed"
}

src_install() {
	dobin abc2abc abc2midi abcmatch mftext midi2abc midicopy yaps || die
	doman doc/*.1 || die
	dodoc doc/AUTHORS doc/CHANGES doc/*.txt || die
	docinto programming || die
	dodoc doc/programming/* || die
	insinto /usr/share/doc/${P} || die
	doins demo.abc || die
}
