# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="2"

inherit git

DESCRIPTION="statistics generator for git"
HOMEPAGE="http://gitstats.sourceforge.net/"
SRC_URI=""
EGIT_REPO_URI="git://repo.or.cz/gitstats.git"

LICENSE="|| ( GPL-2 GPL-3 )"

SLOT="0"
KEYWORDS="~amd64 ~x86"

IUSE=""
RDEPEND="sci-visualization/gnuplot[gd]
	 dev-util/git"

src_prepare() {
	sed "s:basedir = os.path.dirname(os.path.abspath(__file__)):basedir = '/usr/share/gitstats':g" \
	-i gitstats || die "failed to fix static files path"
}

src_configure() {
	true
}

src_compile() {
	true
}

src_install() {
	insinto /usr/share/${PN}
	doins gitstats.css sortable.js *gif || die "failed to install static files"

	dobin gitstats || die "failed to install ${PN}"

	dodoc doc/{README,{TODO,author}.txt} || die "doc install failed"
}
