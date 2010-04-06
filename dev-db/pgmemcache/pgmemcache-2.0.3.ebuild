# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

DESCRIPTION="A PostgreSQL API based on libmemcached to interface with memcached"
HOMEPAGE="http://pgfoundry.org/projects/pgmemcache"
SRC_URI="http://pgfoundry.org/frs/download.php/2637/${PN}_${PV}.tar.bz2"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND=">=virtual/postgresql-base-8.3
	>=dev-libs/libmemcached-0.38"
RDEPEND="${DEPEND}"

S=${WORKDIR}/${PN}

src_install() {
	emake DESTDIR="${D}" install || die "install failed"
	dodoc README.pgmemcache NEWS || die "install documentation failed"
}
