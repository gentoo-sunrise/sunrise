# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="2"

inherit git multilib

DESCRIPTION="An improved dynamic tiling window manager"
HOMEPAGE="http://i3.zekjur.net/"
SRC_URI=""
EGIT_REPO_URI="git://code.stapelberg.de/i3"

LICENSE="BSD"
SLOT="0"
KEYWORDS=""
IUSE="doc"

RDEPEND="x11-libs/libxcb
	x11-libs/xcb-util
	x11-libs/libX11
	dev-libs/libev"
DEPEND="${RDEPEND}
	x11-proto/xcb-proto
	>=app-text/asciidoc-8.3
	app-text/xmlto
	app-text/docbook-xml-dtd"

src_prepare() {
	sed -i \
		-e "s:/usr/local/include:/usr/include:" \
		-e "s:/usr/local/lib:/usr/$(get_libdir):" \
		Makefile || die "sed die"
}

src_compile() {
	emake || die "emake compile die"
	emake -C man || die "emake man die"
	use doc && { emake -C docs || die "emake docs die" ; }
}

src_install() {
	emake DESTDIR="${D}" install || die "emake install die"
	dodoc GOALS TODO CMDMODE || die "dodoc die"
	doman man/i3.1 || die "doman die"
	use doc && { dohtml -r website/* docs/*.html || die "dohtml die" ; }
}

pkg_postinst() {
	use doc && elog "Documentation in html is in /etc/share/doc/${P}"
}
