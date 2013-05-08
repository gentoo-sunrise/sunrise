# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="5"

inherit git-2 bash-completion-r1

EGIT_REPO_URI="git://github.com/visionmedia/git-extras.git"
DESCRIPTION="Little git extras"
HOMEPAGE="https://github.com/visionmedia/git-extras"

LICENSE="MIT"
SLOT="0"

RDEPEND="dev-vcs/git"

src_compile() {
	:;
	# we skip this because the first target of the
	# Makefile is "install" and plain "make" would
	# actually run "make install"

}

src_install() {
	emake DESTDIR="${D}" PREFIX="/usr" install
	nonfatal dodoc Readme.md
	nonfatal newbashcomp "${D}/etc/bash_completion.d/${PN}" ${PN}
}
