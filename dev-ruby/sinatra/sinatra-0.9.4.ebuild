# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

USE_RUBY="ruby18 ruby19"
inherit gems

DESCRIPTION="DSL for quickly creating web applications in Ruby with minimal effort"
HOMEPAGE="http://www.sinatrarb.com"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~x86"
IUSE=""

RDEPEND=">=dev-ruby/rack-1.0.0"
DEPEND="${RDEPEND}"
