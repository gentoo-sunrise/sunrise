# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=2

USE_RUBY="ruby18"

RUBY_FAKEGEM_TASK_TEST=""

RUBY_FAKEGEM_DOCDIR="html"
RUBY_FAKEGEM_EXTRADOC="DNSSEC EXAMPLES README"

inherit ruby-fakegem

DESCRIPTION="A pure Ruby DNS client library"
HOMEPAGE="http://rubyforge.org/projects/dnsruby/"

KEYWORDS="~amd64 ~x86"
LICENSE="Apache-2.0"
SLOT="0"
IUSE=""

each_ruby_test() {
	# only run offline tests
	#${RUBY} -I lib test/ts_dnsruby.rb || die "test failed"
	${RUBY} -I lib test/ts_offline.rb || die "test failed"
}

