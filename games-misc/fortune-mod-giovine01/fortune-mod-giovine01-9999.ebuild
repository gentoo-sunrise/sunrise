# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit mercurial

MY_PN=${PN/mod-/}
DESCRIPTION="Quotes from the italian blog 'Giovine01 - una mente binaria'"
HOMEPAGE="http://fortune-giovine01.googlecode.com"
SRC_URI=""

LICENSE="CC-BY-SA-3.0"
SLOT="0"
KEYWORDS=""
IUSE=""

RDEPEND="games-misc/fortune-mod"

EHG_REPO_URI="https://fortune-giovine01.googlecode.com/hg/"

src_install() {
	insinto /usr/share/fortune
	doins ${MY_PN} ${MY_PN}.dat || die
}
