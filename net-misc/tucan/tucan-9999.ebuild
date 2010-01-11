# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="2"

inherit eutils subversion

# There's no other way to checkout the repository.
# The certificated used by https protocol is provided by
# GTE CyberTrust Global Root (ca-certificates).
ESVN_REPO_URI="https://forja.rediris.es/svn/cusl3-tucan/trunk/"

DESCRIPTION="Manages automatic downloads and uploads from one-click hosting sites like RapidShare"
HOMEPAGE="http://tucaneando.com/"
SRC_URI=""

LICENSE="GPL-3"
SLOT="0"
KEYWORDS=""
IUSE="gtk"

RDEPEND="dev-lang/python
	gtk? ( dev-python/pygtk
		gnome-base/librsvg )
	app-text/tesseract[linguas_en]
	dev-python/imaging"

src_install() {
	emake DESTDIR="${D}"/usr install || die "emake install failed"
	dodoc CHANGELOG README || die "dodoc failed"
	if use gtk ; then
		doicon media/tucan.svg || die "doicon failed"
		make_desktop_entry tucan Tucan
	fi
}
