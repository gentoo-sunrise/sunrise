# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit ruby

MY_P=${P/ruby-mpd/mpd-rb}

DESCRIPTION="Ruby class for communicating with an MPD server"
HOMEPAGE="http://www.andsoforth.com/geek/mpd_rb.html"
SRC_URI="http://rubyforge.org/frs/download.php/8040/${MY_P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND="media-sound/mpd"

S=${WORKDIR}/${MY_P}
