# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="2"

inherit eutils savedconfig toolchain-funcs

DESCRIPTION="Dynamic virtual terminal manager"
HOMEPAGE="http://www.brain-dump.org/projects/dvtm/"
SRC_URI="http://www.brain-dump.org/projects/dvtm/${P}.tar.gz"
LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="unicode"

DEPEND="sys-libs/ncurses[unicode?]"
RDEPEND=${DEPEND}

src_unpack() {
	unpack ${A}
	cd "${S}"

	sed -i \
		-e 's|FLAGS =|FLAGS +=|' \
		-e 's|-I/usr/local/include||' \
		-e 's|-L/usr/local/lib||' \
		-e 's|-Os||' \
		config.mk || die "sed config.mk failed"
	sed -i \
		-e '/strip/d' \
		Makefile || die "sed Makefile failed"

	use savedconfig && restore_config config.h
}

src_compile() {
	local msg=""
	local target="dvtm"
	use unicode && target="unicode"
	use savedconfig && msg=", please check the configfile"
	emake CC=$(tc-getCC) ${target} || die "emake failed${msg}"
}

src_install() {
	emake DESTDIR="${D}" PREFIX="/usr" install || die "emake install failed"

	insinto /usr/share/${PN}
	newins config.h ${PF}.config.h

	dodoc README

	save_config config.h
}

pkg_postinst() {
	elog "This ebuild has support for user defined configs"
	elog "Please read this ebuild for more details and re-emerge as needed"
	elog "if you want to add or remove functionality for ${PN}"
}
