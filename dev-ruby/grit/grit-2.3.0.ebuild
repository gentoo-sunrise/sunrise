# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=2

RUBY_FAKEGEM_DOCDIR="rdoc"
USE_RUBY="ruby18"

inherit eutils ruby-fakegem

DESCRIPTION="Git Library for Ruby"
HOMEPAGE="http://rubyforge.org/projects/grit http://github.com/mojombo/grit"
# http://github.com/mojombo/grit/issues/issue/33
SRC_URI="ftp://mirror.calvin.edu/~binki/${P}.tar.bz2
	test? ( ftp://mirror.calvin.edu/~binki/${P}-dot_git.tar.bz2 )"

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

RUBY_PATCHES=(${P}-sorted-refs.patch)
