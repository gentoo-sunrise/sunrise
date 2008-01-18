# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit webapp java-utils-2

MY_P=${P/webcamserver-client/webcam_server}

DESCRIPTION="webcam_server is a program that allows others to view your webcam from a web browser"
HOMEPAGE="http://webcamserver.sourceforge.net/"
SRC_URI="mirror://sourceforge/${PN}/${MY_P}.tar.gz"

LICENSE="GPL-2"
KEYWORDS="~x86"
IUSE=""

DEPEND=">=virtual/jdk-1.4"
RDEPEND=">=virtual/jre-1.4"

S=${WORKDIR}/${MY_P}/src/client

src_compile() {
	# Remove existing jar
	rm *.jar
	ejavac *.java || die "ejavac failed!"
	jar cf "${S}/applet.jar" *.class || die "jar failed!"
}

src_install() {
	webapp_src_preinst
	cp *.jar *.html *.jpg "${D}/${MY_HTDOCSDIR}"
	webapp_postinst_txt en "${FILESDIR}/postinstall-en-${PV}.txt"
	webapp_src_install
}
