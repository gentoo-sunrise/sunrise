# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit perl-module

DESCRIPTION="Crypt::Simple module for perl"
SRC_URI="http://search.cpan.org/CPAN/authors/id/K/KA/KASEI/${P}.tar.gz"
HOMEPAGE="http://search.cpan.org/~kasei/${P}"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86"
IUSE=""

DEPEND="virtual/libc
	>=dev-lang/perl-5
	>=dev-perl/Crypt-Blowfish-2.09-r3
	>=dev-perl/FreezeThaw-0.43-r1"

export OPTIMIZE="${CFLAGS}"
