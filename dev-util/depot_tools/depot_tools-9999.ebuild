# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=2

ESVN_REPO_URI="http://src.chromium.org/svn/trunk/tools/depot_tools"
PYTHON_DEPEND="2"

inherit eutils python subversion

DESCRIPTION="Scripts to manage integration with Chromium repository and development process"
HOMEPAGE="http://dev.chromium.org/developers/how-tos/depottools"
SRC_URI=""

LICENSE="BSD"
SLOT="0"
KEYWORDS=""
IUSE=""

RDEPEND=">=dev-vcs/git-1.6.6[curl]"

src_install() {
	insinto /opt/${PN}
	doins -r \
		git_cl_hooks.py presubmit_canned_checks.py breakpad.py \
		PRESUBMIT.py gclient.py	gclient_scm.py \
		WATCHLISTS gclient_utils.py codereview.settings weekly scm.py \
		tests zsh-goodies third_party || die "install failed"
	exeinto /opt/${PN}
	local exes="chrome-update.py cpplint.py create-chromium-git-src \
		drover drover.py gcl gcl.py gclient git-cl \
		git-cl-upload-hook git-gs git-try hammer \
		presubmit_support.py trychange.py watchlists.py wtf"
	doexe ${exes} || die "install failed"
	for i in ${exes}
	do
		make_wrapper $i /opt/${PN}/$i "" "" /opt/bin || die "make_wrapper failed"
	done
	dodoc README README.gclient || die "dodoc failed"
}
