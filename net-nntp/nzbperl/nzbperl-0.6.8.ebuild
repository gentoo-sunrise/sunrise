# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit eutils

DESCRIPTION="nzb based nntp/usenet downloader in perl"
HOMEPAGE="http://noisybox.net/computers/nzbperl/"
SRC_URI="http://noisybox.net/computers/nzbperl/${P}.pl"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="ipv6 ssl"

DEPEND="dev-lang/perl
	app-text/uudeview
	virtual/perl-Time-HiRes
	virtual/perl-Getopt-Long
	dev-perl/TermReadKey
	virtual/perl-Term-ANSIColor
	dev-perl/XML-DOM
	ssl? ( dev-perl/IO-Socket-SSL )
	ipv6? ( dev-perl/IO-Socket-INET6 )
"

src_unpack() {
	:
}

src_install() {
	newbin "${DISTDIR}/${P}.pl" ${PN}
	dodoc "${FILESDIR}/${PN}rc.sample"
}

pkg_postinst() {
	if ! built_with_use dev-lang/perl ithreads; then
		ewarn "WARNING: dev-lang/perl was built with ithreads disabled, please start nzbperl"
		ewarn "with --dthreadct 0 to use single-threaded nzbperl OR remerge dev-lang/perl"
		ewarn "with ithreads in your USE flags."
		ewarn ""
		ewarn "Note that using --dthreadct 0 will cause downloads to pause during decoding,"
		ewarn "so it is recommended that you build perl with ithreads enabled."
	fi

	elog "A sample config file has been copied into /usr/share/doc/${PF}"
	elog "You may want to take it as a sample for your ~/.nzbperlrc"
}
