# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

DESCRIPTION="A Pidgin plugin to prevent Instant Message spam"
HOMEPAGE="http://sourceforge.net/projects/pidgin-bs/"
SRC_URI="mirror://sourceforge/pidgin-bs/bot-sentry-${PV}.tar.bz2"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

RDEPEND="net-im/pidgin
	>=dev-libs/glib-2.0"
DEPEND="${RDEPEND}
	dev-util/pkgconfig"

S="${WORKDIR}"/bot-sentry-${PV}

src_install() {
	emake DESTDIR="${D}" install || die "Failed install phase"
}
