# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=2

USE_RUBY="ruby18"
RUBY_FAKEGEM_DOCDIR="rdoc"

inherit ruby-fakegem

DESCRIPTION="Ruby monitoring framework which replaces monit"
HOMEPAGE="http://god.rubyforge.org/"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

# jabber test requires xmpp4r
# webhook and campfire tests require json
# twitter test requires twitter
ruby_add_bdepend "doc? ( dev-ruby/jeweler
		virtual/ruby-rdoc )
	test? ( dev-ruby/jeweler
		dev-ruby/json
		dev-ruby/mocha
		dev-ruby/twitter
		dev-ruby/xmpp4r )"

# After all of our work fixing test dependencies, we can't run them
# because they always fail (at least for god-0.11.0).
RESTRICT="test"

all_ruby_prepare() {
	# the campfire test requires dev-ruby/tinder which would have to
	# be ebuildized.
	rm -v test/test_campfire.rb || die
	# prowly isn't yet an ebuild either
	rm -v test/test_prowl.rb || die
}

each_ruby_test() {
	if hasq userpriv ${FEATURES}; then
		ewarn "${PN} requires root priviliges to run its test. Thus, I am not running ${PN}'s"
		ewarn "tests. Remove \"userpriv\" from FEATURES to run the tests."
	else
		each_fakegem_test
	fi
}
