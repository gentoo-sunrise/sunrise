# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=2

RUBY_FAKEGEM_DOCDIR="html"
RUBY_FAKEGEM_NAME="gd2"
USE_RUBY="ruby18"

inherit eutils ruby-fakegem

DESCRIPTION="Ruby bindings for the GD 2.x graphics library"
HOMEPAGE="http://gd2.rubyforge.org/"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="test"

DEPEND="test? ( media-libs/gd[truetype] )"
RDEPEND="media-libs/gd[truetype]"

ruby_add_bdepend "doc? ( virtual/ruby-rdoc )"

RUBY_PATCHES=( ${P}-raketasks.patch ${P}-raketasks-gentoo.patch )
