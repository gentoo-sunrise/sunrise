# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=4

inherit git-2

DESCRIPTION="A command line utility for viewing youtube-videos in Mplayer"
HOMEPAGE="http://trizen.googlecode.com"
EGIT_REPO_URI="git://github.com/trizen/${PN}.git"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS=""
IUSE=""

RDEPEND="dev-lang/perl
	dev-perl/URI
	dev-perl/XML-Fast
	virtual/perl-Scalar-List-Utils"

src_install() {
	dobin ${PN}
}
