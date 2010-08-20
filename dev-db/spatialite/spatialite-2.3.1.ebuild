# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header $

EAPI="3"

inherit multilib

MY_P="lib${PN}-amalgamation-${PV}"

DESCRIPTION="A complete Spatial DBMS in a nutshell built upon sqlite"
HOMEPAGE="http://www.gaia-gis.it/spatialite"
SRC_URI="http://www.gaia-gis.it/spatialite/${MY_P}.tar.gz
	doc? ( http://www.gaia-gis.it/${PN}/${PN}-sql-${PV}.html )"

LICENSE="MPL-1.1"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="doc geos proj static-libs"

RDEPEND="dev-db/sqlite:3[extensions]
	geos? ( sci-libs/geos )
	proj? ( sci-libs/proj )"
DEPEND="${RDEPEND}"

S=${WORKDIR}/${MY_P}

src_configure() {
	econf \
		$(use_enable geos) --with-geos-lib=/usr/$(get_libdir) \
		$(use_enable proj) --with-proj-lib=/usr/$(get_libdir) \
		$(use_enable static-libs static)

}

src_install() {
	emake DESTDIR="${D}" install || die

	if use doc; then
		dohtml "${DISTDIR}"/${PN}-sql-${PV}.html || die
	fi
}
