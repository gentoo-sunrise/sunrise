# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit eutils multilib

DESCRIPTION="Gofer interpreter including Tcl/Tk interface"
HOMEPAGE="http://www.informatik.uni-ulm.de/pm/projekte/TkGofer/"
SRC_URI="http://www.informatik.uni-ulm.de/pm/projekte/TkGofer/tkg${PV}.tar.gz"

LICENSE="as-is" # see ${S}/Sources/goferite.h for exact wording
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND=">=dev-lang/tcl-7.6
	>=dev-lang/tk-4.2
	sys-libs/readline"
RDEPEND=${DEPEND}

S=${WORKDIR}/${PN}${PV}

src_unpack() {
	unpack ${A}
	cd "${S}"
	epatch "${FILESDIR}/2.1-include-string.patch" \
	"${FILESDIR}/2.1-gentoo-config.patch"
}

src_compile() {
	lib="/usr/$(get_libdir)/${PN}"
	rm Sources/prelude.h Sources/Makefile # ensure regeneration
	./tkgofer.install || die "tkgofer.install failed"
	sed -i	-e"s:${S}:/usr:" \
		-e"s:\\(PreludeDir=\"\\).*\":\\1${lib}/Preludes\":" \
		-e"s:\\(BinDir=\"\\).*\":\\1${lib}/Bin\":" \
		-e"s:\\(TclDir=\"\\).*\":\\1${lib}/Tcl\":" \
		-e"s:\\(HelpDir=\"\\).*\":\\1/usr/share/doc/${PF}\":" \
		Bin/tkgofer || die "sed for tkgofer failed"
}

src_install() {
	insinto ${lib}/Preludes || die
	doins Preludes/* || die
	insinto ${lib}/Tcl || die
	doins Tcl/* || die
	exeinto ${lib}/Bin || die
	doexe Bin/{site.specific,tkgofer.exe} || die
	dobin Bin/tkgofer
	dodoc readme Doc/* || die
}
