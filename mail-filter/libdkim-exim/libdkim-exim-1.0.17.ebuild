# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit eutils

MY_P="${P/-exim/}-tk"
DESCRIPTION="a library for exim to verify and create signatures of e-mail headers"
HOMEPAGE="http://wiki.exim.org/DKIM"
SRC_URI="http://duncanthrax.net/exim-experimental/${MY_P}.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND="dev-libs/openssl"
RDEPEND="${DEPEND}"

S=${WORKDIR}/${MY_P}/src

src_unpack() {
	unpack ${A}
	cd "${S}"

	# upstream makefile is not very useful.
	epatch "${FILESDIR}/${MY_P}-Makefile.patch" \
	       "${FILESDIR}/${MY_P}-missing-includes.patch"
}

src_install() {
	emake DESTDIR="${D}" install || die "emake failed"
	dodoc ../README || die "Install README failed"
}
