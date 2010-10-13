# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=2

USE_RUBY="ruby18"

inherit ruby-ng

MY_P=mpd-rb-${PV}

DESCRIPTION="Ruby class for communicating with an MPD server"
HOMEPAGE="http://rubyforge.org/projects/mpd"
SRC_URI="http://rubyforge.org/frs/download.php/8040/${MY_P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND="media-sound/mpd"

S=${WORKDIR}/${MY_P}

each_ruby_install() {
	doruby lib/mpd.rb
}
