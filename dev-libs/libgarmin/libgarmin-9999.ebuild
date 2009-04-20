# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit autotools subversion

DESCRIPTION="Experimental driver for Garmin IMG maps"
HOMEPAGE="http://libgarmin.sourceforge.net/"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS=""
IUSE=""

ESVN_REPO_URI="http://libgarmin.svn.sourceforge.net/svnroot/${PN}/${PN}/dev"
ESVN_PROJECT="libgarmin"
##Upstream's bootstrap runs configure, which is evil
ESVN_BOOTSTRAP="eautoreconf"

src_install() {
	emake DESTDIR="${D}" install || die "Install failed"
}
