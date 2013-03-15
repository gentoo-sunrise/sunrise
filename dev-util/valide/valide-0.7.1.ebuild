# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=1

inherit multilib toolchain-funcs

DESCRIPTION="Val(a)IDE is an IDE for the Vala programming language"
HOMEPAGE="http://www.valaide.org/"
SRC_URI="http://launchpad.net/valide/trunk/${PV}/+download/${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="unique"

RDEPEND="dev-db/sqlite:3
	>=dev-lang/vala-0.12.0:0.12
	>=dev-libs/gdl-2.28
	dev-libs/glib:2
	dev-libs/libxml2
	>=x11-libs/gtk+-2.18.0:2
	>=x11-libs/gtksourceview-2.10
	dev-libs/gdl:1"
DEPEND="${RDEPEND}
	dev-lang/python"

src_compile() {
	tc-export CC CXX CPP AR RANLIB
	VALAC="valac-0.12" ./waf configure \
		--nocache \
		--prefix=/usr \
		--with-libdir=/usr/"$(get_libdir)" || die "Configure failed!"

	VALAC="valac-0.12" ./waf build || die "Build failed!"
}

src_install() {
	VALAC="valac-0.12" ./waf install --destdir="${D}" || die "Install to ${D} failed!"
}
