# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

MODULE_AUTHOR=TSCH
MY_PN=Gnome2-Vte
inherit perl-module

DESCRIPTION="Gnome2 Vte Perl interface to the Virtual Terminal Emulation library"
HOMEPAGE="http://search.cpan.org/~tsch/Gnome2-Vte-0.09/"

SLOT="0"
LICENSE="Artistic"
KEYWORDS="~amd64 ~x86"
IUSE=""

SRC_TEST="do"

mydoc="TODO"

DEPEND="dev-lang/perl
	dev-perl/glib-perl
	dev-perl/gtk2-perl"
RDEPEND="${DEPEND}"