# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="2"

inherit base

DESCRIPTION="Libpurple (Pidgin) plug-in supporting microblog services like Twitter"
HOMEPAGE="http://code.google.com/p/microblog-purple/"
MY_P="${P/pidgin-/}"
SRC_URI="http://microblog-purple.googlecode.com/files/${MY_P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND="net-im/pidgin[gtk]"
DEPEND="${RDEPEND}
	dev-util/pkgconfig"
S="${WORKDIR}/${MY_P}"
