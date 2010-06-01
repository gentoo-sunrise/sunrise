# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=2
inherit perl-module

DESCRIPTION="Downloads videos from various Flash-based video hosting sites"
HOMEPAGE="http://code.google.com/p/get-flash-videos/"
SRC_URI="http://omploader.org/vNGdjYQ/${P}.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~x86"
IUSE=""

RDEPEND="dev-perl/WWW-Mechanize
	perl-core/Module-CoreList"
DEPEND="${RDEPEND}
	dev-perl/UNIVERSAL-require
	test? ( media-video/rtmpdump
		dev-perl/Tie-IxHash
		dev-perl/XML-Simple
		dev-perl/Crypt-Rijndael
		dev-perl/Data-AMF
		perl-core/IO-Compress )"

S="${WORKDIR}/${PN//_/-}"
SRC_TEST="do"
mymake="default ${PN}.1"
myinst="DESTDIR=${D}"

src_prepare() {
	sed -i -e 's#^check:#test:#' Makefile || die
}

pkg_postinst() {
	elog "Downloading videos from RTMP server requires the following packages :"
	elog "	media-video/rtmpdump"
	elog "	dev-perl/Tie-IxHash"
	elog "Others optional dependencies :"
	elog "	dev-perl/XML-Simple"
	elog "	dev-perl/Crypt-Rijndael"
	elog "	dev-perl/Data-AMF"
	elog "	perl-core/IO-Compress"
}
