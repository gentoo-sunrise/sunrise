# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="2"

ESVN_REPO_URI="http://freenet.googlecode.com/svn/trunk/apps/Freemail"
ESVN_OPTIONS="--ignore-externals"
EANT_BUILD_TARGET="dist"
inherit eutils java-pkg-2 java-ant-2 subversion

DESCRIPTION="Anonymous IMAP/SMTP e-mail server over Freenet"
HOMEPAGE="http://www.freenetproject.org/tools.html"
SRC_URI=""

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

CDEPEND="dev-java/bcprov
	net-p2p/freenet[freemail]"
DEPEND="${CDEPEND}
	>=virtual/jdk-1.5"
RDEPEND="${CDEPEND}
	>=virtual/jre-1.5"

src_unpack() {
	subversion_src_unpack
	cd "${S}"
	epatch "${FILESDIR}"/build.patch
	java-pkg_jar-from bcprov bcprov.jar
	java-pkg_jar-from freenet freenet.jar
}

src_install() {
	java-pkg_dojar lib/Freemail.jar
	dodir /var/freenet/plugins
	dosym ../../../usr/share/Freemail/lib/Freemail.jar /var/freenet/plugins/Freemail.jar
	dodoc README || die "installation of documentation failed"
}

pkg_postinst () {
	elog "To load Freemail, go to the plugin page of freenet and enter at"
	elog "Plugin-URL: plugins/Freemail.jar. This should load the Freemail plugin."
	elog "Set your email client to IMAP port 3143 and SMTP port 3025 on localhost."
	elog "To bind freemail to different ports, or to a different freenet node, edit"
	elog "/var/freenet/globalconfig."
}
