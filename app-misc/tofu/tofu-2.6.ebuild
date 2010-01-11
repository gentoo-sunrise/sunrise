# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="2"

DESCRIPTION="Plain (stupid) text-based todo manager"
HOMEPAGE="http://requiescant.tuxfamily.org/tofu/index.html"
SRC_URI="http://requiescant.tuxfamily.org/${PN}/${P}.tar.gz"

LICENSE="|| ( MIT X11 )"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND="dev-lang/perl"

# configure script is broken
src_configure() { :; }

src_install() {
	dodoc CHANGELOG PLAY playground.pl README || die "dodoc failed"
	doman share/* || die "doman failed"
	dobin ${PN} || die "dobin failed"
}

pkg_postinst() {
	einfo "Once the installation  is done, the first thing you should do is to"
	einfo "create in our home a stack, which must be a sub-directory of the "
	einfo "'~/.tofu' directory. Example, initializing the \"project\" stack:"
	einfo ""
	einfo "$ mkdir -p ~/.tofu/project"
	einfo ""
	einfo "Now you are ready to use tofu. To begin, you should read"
	einfo "\"man 1 tofu\" or, if you prefer a concrete approach, follow the"
	einfo "mini-tutorial which is contained in the"
	einfo "/usr/share/doc/${P}/PLAY.bz2 file."
}
