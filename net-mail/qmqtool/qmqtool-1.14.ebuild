# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=2

DESCRIPTION="A qmail queue manipulation program"
HOMEPAGE="http://jeremy.kister.net/code/qmqtool/"
SRC_URI="http://jeremy.kister.net/code/qmqtool/files/${P}.tgz"

LICENSE="Artistic"
SLOT="0"
KEYWORDS="~x86"
IUSE=""

RDEPEND="virtual/qmail
	dev-lang/perl"

src_prepare() {
	# make the configure script less capricious and ${ROOT}-friendly
	# i.e. replace real directory/file checks with non-empty var checks
	# and disallow calling perl
	sed -i \
		-e 's:\[ -[dx]:[ -n:g' \
		-e 's:\[ ! -[dx]:[ ! -n:g' \
		-e '/^$perl/d' \
		configure || die
}

src_configure() {
	# econf-incompatible
	./configure \
		--prefix="${D}"/usr \
		--scriptdir="${D}"/usr/bin \
		--perl=/usr/bin/perl \
		--qmaildir=/var/qmail \
		|| die
}

src_install() {
	emake install || die
	dodoc README FAQ ChangeLog || die "dodoc failed"

	docinto contrib/argus
	dodoc contrib/argus/* || die "dodoc failed"

	docinto contrib/cricket
	dodoc contrib/cricket/* || die "dodoc failed"
}
