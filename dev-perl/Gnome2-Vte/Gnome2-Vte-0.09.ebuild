# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

MODULE_AUTHOR=TSCH
inherit perl-module

DESCRIPTION="Gnome2 Vte Perl interface to the Virtual Terminal Emulation library"

SLOT="0"
LICENSE="LGPL-2.1"
KEYWORDS="~amd64 ~x86"
IUSE=""

SRC_TEST="do"

RDEPEND="dev-lang/perl
	dev-perl/glib-perl
	dev-perl/gtk2-perl"
DEPEND="${RDEPEND}
	dev-perl/extutils-depends
	dev-perl/extutils-pkgconfig"
