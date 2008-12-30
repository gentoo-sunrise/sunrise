# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit eutils

DESCRIPTION="Gofer interpreter including Tcl/Tk interface"
HOMEPAGE="http://www.informatik.uni-ulm.de/pm/projekte/TkGofer/"
SRC_URI="http://www.informatik.uni-ulm.de/pm/projekte/TkGofer/tkg${PV}.tar.gz"

LICENSE="as-is" # see ${S}/Sources/goferite.h for exact wording
SLOT="0"
KEYWORDS="~x86"
IUSE=""

DEPEND=">=dev-lang/tcl-7.6
	>=dev-lang/tk-4.2
	sys-libs/readline"

S=${WORKDIR}/${PN}${PV}

src_unpack() {
	unpack ${A}
	cd "${S}"
	epatch "${FILESDIR}/2.1-include-string.patch"
	epatch "${FILESDIR}/2.1-gentoo-config.patch"
}

src_compile() {
	rm Sources/prelude.h Sources/Makefile # ensure regeneration
	./tkgofer.install || die "tkgofer.install failed"
	sed -i	-e"s:${S}:/usr:" \
		-e"s:\\(PreludeDir=\"\\).*\":\\1/usr/lib/${PN}/Preludes\":" \
		-e"s:\\(BinDir=\"\\).*\":\\1/usr/lib/${PN}/Bin\":" \
		-e"s:\\(TclDir=\"\\).*\":\\1/usr/lib/${PN}/Tcl\":" \
		-e"s:\\(HelpDir=\"\\).*\":\\1/usr/share/doc/${PF}\":" \
		Bin/tkgofer || die "sed for tkgofer failed"
}

src_install() {
	insinto /usr/lib/${PN}/Preludes || die
	doins Preludes/* || die
	insinto /usr/lib/${PN}/Tcl || die
	doins Tcl/* || die
	exeinto /usr/lib/${PN}/Bin || die
	doexe Bin/site.specific || die
	doexe Bin/tkgofer.exe || die
	dobin Bin/tkgofer # || die
	dodoc readme Doc/* || die
}
