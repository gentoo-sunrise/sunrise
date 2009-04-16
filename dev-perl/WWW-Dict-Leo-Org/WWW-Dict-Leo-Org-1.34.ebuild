# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

MODULE_AUTHOR="TLINDEN"
inherit perl-app

DESCRIPTION="commandline interface to http://dict.leo.org/"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND="dev-lang/perl
	dev-perl/HTML-TableParser"
DEPEND="${RDEPEND}"

