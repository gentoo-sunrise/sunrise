# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=2

USE_RUBY="ruby18"

# cannot run test and doc tasks, Rakefile not included 
#   (bug at: https://rubyforge.org/tracker/index.php?func=detail&aid=27825&group_id=2387&atid=9259)
RUBY_FAKEGEM_TASK_TEST=""
RUBY_FAKEGEM_TASK_DOC=""
RUBY_FAKEGEM_EXTRADOC="DNSSEC EXAMPLES README"

inherit ruby-fakegem

IUSE=""

DESCRIPTION="A pure Ruby DNS client library"
HOMEPAGE="http://rubyforge.org/projects/dnsruby/"

KEYWORDS="~amd64 ~x86"
LICENSE="Apache-2.0"
SLOT="0"
