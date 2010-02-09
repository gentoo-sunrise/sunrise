# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="1"

MY_P=bot-sentry-${PV}
DESCRIPTION="A Pidgin plugin to prevent Instant Message spam"
HOMEPAGE="http://sourceforge.net/projects/pidgin-bs/"
SRC_URI="mirror://sourceforge/pidgin-bs/${MY_P}.tar.bz2"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

RDEPEND="net-im/pidgin
	dev-libs/glib:2"
DEPEND="${RDEPEND}
	dev-util/pkgconfig"

S="${WORKDIR}"/${MY_P}

src_install() {
	emake DESTDIR="${D}" install || die "Failed install phase"
}
