# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit cmake

KEYWORDS="~x86"

DESCRIPTION="A C++ library to develop web applications."
HOMEPAGE="http://jose.med.kuleuven.be/wt/Home.fcg"
SRC_URI="mirror://sourceforge/witty/${P}.tar.gz"
LICENSE="GPL-2"
SLOT="0"
IUSE="debug examples"

CDEPEND=">=dev-libs/boost-1.31.0
		dev-libs/xerces-c
		debug? ( dev-util/valgrind )
		examples? ( >=dev-db/mysql++-2 )"
DEPEND="${CDEPEND}
		>=dev-util/cmake-2.4
		>=dev-libs/fcgi-2.4.0"
RDEPEND="${CDEPEND}
		|| ( >=net-www/mod_fastcgi-2.4.2
			>=www-apache/mod_fcgid-1.07 )
		net-www/apache"

src_unpack() {
	unpack ${A}
	cd "${S}"
	sed -i \
		-e '/SET_TARGET_PROPERTIES/,/)/d' \
		src/CMakeLists.txt
	sed -i \
		-e 's#\(/include\)#\1/wt#' \
		src/wt/CMakeLists.txt \
		xlobject/src/CMakeLists.txt
}

src_compile() {
	ecmake \
		$(cm_enable CMAKE_SKIP_RPATH) \
		$(cm_use_enable debug VALGRIND_SUPPORT) \
		$(cm_use_set_string debug CMAKE_BUILD_TYPE Debug Release) \
		$(cm_set_path CMAKE_INSTALL_PREFIX "${D}/usr") \
		$(cm_set_path RUNDIR "/var/run/wt") \
		$(cm_set_path DEPLOYROOT "${D}/usr/share/${PN}/examples") \
		.

	emake || die "emake failed"
	if use examples ; then
		emake -C examples || die "emake failed"
	fi
}

src_install() {
	emake install || die "emake install failed"

	mkdir -p "${D}/var/run/wt"
	fowners apache:apache /var/run/wt

	dodoc AUTHORS BUGS Changelog ReleaseNotes.txt doc/tutorial/*.pdf
	dohtml -A xhtml -r doc/reference doc/tutorial

	if use examples ; then
		cd examples
		for example in $(sed -e 's/.*(\(.*\)).*/\1/p' -e 'd' CMakeLists.txt); do
			cd "${S}/examples/${example}"
			./deploy.sh
		done
	fi
}
