# Copyright 2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit eutils java-pkg

DESCRIPTION="Spark is an Open Source, cross-platform IM client optimized for businesses and organizations"
HOMEPAGE="http://www.igniterealtime.org/projects/spark/"
SRC_URI="http://www.igniterealtime.org/builds/spark/${PN//-/_}_${PV//./_}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="doc"

RDEPEND=">=virtual/jdk-1.5
	>=virtual/jre-1.5"
DEPEND="app-arch/unzip"

S=${WORKDIR}/Spark

src_install() {
	java-pkg_dojar lib/*.jar
	java-pkg_dojar .install4j/*.jar

	insinto /usr/share/spark
	doins -r resources xtra plugins

	dobin "${FILESDIR}"/spark.sh || die
	unzip -qq lib/spark.jar
	doicon "${WORKDIR}"/images/spark-64x64.png
	make_desktop_entry spark.sh "Spark IM" spark-64x64 "Network;InstantMessaging"

	if use doc; then
		dohtml -r documentation/*
	fi
}

pkg_postinst() {
	ewarn "If you have problems with system-tray, read following:"
	ewarn "http://www.igniterealtime.org/community/message/168762#168711"
	ewarn
	ewarn "And then, please, do:"
	ewarn "1. replace /usr/share/spark/plugins/jniwrapper.jar with attachment from the post above;"
	ewarn "2. remove ~/.Spark/plugins"
	ewarn "3. re-start Spark IM"
}