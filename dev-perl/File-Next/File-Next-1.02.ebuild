# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit perl-module

DESCRIPTION="File::Next is an iterator-based module for finding files"
HOMEPAGE="http://search.cpan.org/search?query=File-Next"
SRC_URI="mirror://cpan/authors/id/P/PE/PETDANCE/${P}.tar.gz"


IUSE=""

SLOT="0"
LICENSE="|| ( Artistic GPL-2 )"
KEYWORDS="~x86"

DEPEND="dev-lang/perl
virtual/perl-File-Spec
virtual/perl-Test-Simple"
