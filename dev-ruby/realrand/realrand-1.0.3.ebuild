# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=2

USE_RUBY="ruby18"
RUBY_FAKEGEM_TASK_TEST=""

inherit ruby-fakegem

DESCRIPTION="Generate real random numbers in Ruby."
HOMEPAGE="http://realrand.rubyforge.org/"

KEYWORDS="~x86"
LICENSE="Ruby"
SLOT="0"
IUSE=""

pkg_postinst() {
	elog "All the HTTP services supported and used by this library are"
	elog "offered for free by their respective owners. Please have a look at"
	elog "their websites to make sure you follow their terms of use."
	elog
	elog "http://www.random.org/"
	elog "http://www.fourmilab.ch/hotbits/"
	elog "http://random.hd.org/"
}
