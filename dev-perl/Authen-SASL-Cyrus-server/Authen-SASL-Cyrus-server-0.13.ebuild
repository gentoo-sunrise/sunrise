# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit perl-module

MY_P="${P//-server}-server"
AUTHOR="PBOETTCH"
DESCRIPTION="A Perl SASL interface using the Cyrus SASL library (server version)"
HOMEPAGE="http://search.cpan.org/~pboettch/Authen-SASL-Cyrus/"
SRC_URI="mirror://cpan/authors/id/${AUTHOR:0:1}/${AUTHOR:0:2}/${AUTHOR}/${MY_P}.tar.gz"

LICENSE="|| ( Artistic GPL-2 )"
SLOT="0"
KEYWORDS="~x86"
IUSE=""

DEPEND=">=dev-perl/Authen-SASL-2.06
	>=dev-libs/cyrus-sasl-2"
RDEPEND="${DEPEND}
	!dev-perl/Authen-SASL-Cyrus"

S="${WORKDIR}/${MY_P}"

SRC_TEST="do"
export OPTIMIZE="$CFLAGS"
myconf="INC=-I/usr/include/sasl LIBS=-lsasl2 DEFINE=-DSASL2"
