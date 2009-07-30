# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="2"
ESVN_REPO_URI="http://tesseract-polish.googlecode.com/svn/trunk/tessdata/"

inherit subversion

DESCRIPTION="Polish data files for tesseract OCR"
HOMEPAGE="http://code.google.com/p/tesseract-polish/"
SRC_URI=""

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS=""
IUSE=""

src_unpack() {
	# First we get 'tessdata' subdir with ESVN_REPO_URI specified above.
	subversion_src_unpack

	# Then we get few remaining needed files from the SVN root (--depth=files
	# makes SVN not descend into subdirectories), making sure we get them from
	# the same revision.
	ESVN_REPO_URI=http://tesseract-polish.googlecode.com/svn/trunk/@${ESVN_WC_REVISION} \
		ESVN_OPTIONS='--depth=files' subversion_src_unpack

	# Some more explanation:
	# We don't want to get the whole repo, because 'src' subdir is four times
	# larger than everything else and we certainly won't use it.

	# One more note: I don't think we need to override src_prepare() (we don't
	# bootstrap here) nor pkg_preinst() (both checkouts use same rev).
}

src_install() {
	# Both checkouts put the files into the same directory, that's OK.

	insinto /usr/share/tessdata
	doins pol.* || die "doins failed"

	dodoc ATTRIBUTIONS BUGS NOTICE README || die "dodoc failed"
}
