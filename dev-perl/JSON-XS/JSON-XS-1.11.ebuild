# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit perl-module

DESCRIPTION="JSON Perl module"
SRC_URI="mirror://cpan/authors/id/M/ML/MLEHMANN/${P}.tar.gz"
HOMEPAGE="http://search.cpan.org/~mlehmann/JSON-XS-1.11/"

SLOT="0"
LICENSE="|| ( Artistic GPL-2 )"
KEYWORDS="~amd64 ~x86"
IUSE=""
SRC_TEST="do"


DEPEND="dev-lang/perl"
