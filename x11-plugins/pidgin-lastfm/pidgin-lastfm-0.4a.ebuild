# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="2"

inherit multilib

DESCRIPTION="Last.fm Plugin for the Pidgin Instant Messenger"
HOMEPAGE="http://pidgin-lastfm.naturalnet.de"
SRC_URI="mirror://sourceforge/${PN}/${PN}_${PV}_all.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND="net-im/pidgin[perl]"

src_install() {
	insinto /usr/$(get_libdir)/pidgin
	doins src/lastfm.pl || die "doins latfm.pl failed"
	dodoc docs/* || die "dodoc failed"
}

pkg_postinst() {
	if has_version "=net-im/pidgin-2.5*" && ! has_version "=dev-lang/perl-5.10*"; then
		elog "For Perl support in Pidgin 2.5.x, you will need"
		echo
		elog "\t>=dev-lang/perl-5.10"
		echo
		elog "Unfortunately, Perl 5.10 is not in portage yet. You can get it from the layman overlay perl-experimental."
		elog "See http://www.gentoo.org/proj/en/overlays/userguide.xml for further information!"
	fi

	if has_version "=net-im/pidgin-2.4*" && ! has_version "=dev-lang/perl-5.8*"; then
		elog "For Perl support in Pidgin 2.4.x, you will need"
		echo
		elog "\t<=dev-lang/perl-5.8"
	fi
}
