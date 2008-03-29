# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="1"
## We need virtualx for src_test's Xmake stuff.
inherit eutils multilib virtualx

DESCRIPTION="A gnome applet interface to SSH."
HOMEPAGE="http://sshmenu.sourceforge.net"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS=""
IUSE="gnome"

#Note: We need to depend on dev-ruby/ruby-gnome2
#until the issues in bug #215329 are fixed.
RDEPEND="dev-lang/ruby:1.8
	dev-ruby/ruby-gtk2
	gnome? ( dev-ruby/ruby-gconf2
		dev-ruby/ruby-panel-applet2
		dev-ruby/ruby-gnome2 )
	|| ( net-misc/x11-ssh-askpass net-misc/gtk2-ssh-askpass )"

src_unpack() {
	unpack ${A}
	cd "${S}"
	epatch "${FILESDIR}"/${P}-fixmultilib.patch
}

src_test() {
	Xmake TEST || die "Tests failed!"
}

src_install() {
	emake LIBDIR="$(get_libdir)" DESTDIR="${D}" install || die "Install failed!"

	if ! use gnome; then
		rm "${D}"/usr/$(get_libdir)/ruby/1.8/gnome-sshmenu.rb
		rm "${D}"/usr/bin/sshmenu-gnome
		rm -rf "${D}"/usr/share/icons
	fi
}
