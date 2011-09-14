# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=4

RUBY_FAKEGEM_DOCDIR="rdoc"
USE_RUBY="ruby18"

inherit eutils ruby-fakegem

DESCRIPTION="Git Library for Ruby"
HOMEPAGE="http://rubyforge.org/projects/grit http://github.com/mojombo/grit"
SRC_URI="https://github.com/mojombo/grit/tarball/v2.4.1 -> ${P}.tar.gz
	test? ( ftp://mirror.ohnopub.net/mirror/${P}.git.tar.bz2 http://mirror.ohnopub.net/mirror/${P}.git.tar.bz2 )"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"
IUSE="doc"

RDEPEND="dev-vcs/git"
DEPEND="test? ( dev-vcs/git )"

ruby_add_bdepend "doc? ( virtual/ruby-rdoc )
	test? ( dev-ruby/mime-types
		dev-ruby/diff-lcs )"
ruby_add_rdepend "dev-ruby/mime-types
	dev-ruby/diff-lcs"

# Override fakegem's all_ruby_unpack() for github fix.
all_ruby_unpack() {
	unpack ${A}
	mv mojombo-${PN}-* "${S}" || die "Removing githubiness."

	# Tests require the grit directory to look like a git repo.
	if [[ -e ${P}.git ]]; then
		mv ${P}.git "${S}"/.git || die "Inserting .git for tests."
	fi
}
