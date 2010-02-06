# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="2"

MY_P="birthday_reminder-${PV}"
DESCRIPTION="Pidgin Birthday Reminder reminds you of your buddies birthdays"
HOMEPAGE="https://sourceforge.net/projects/pidgin-birthday"
SRC_URI="mirror://sourceforge/${PN}/${MY_P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND="net-im/pidgin[gtk]"
RDEPEND="${DEPEND}"

S=${WORKDIR}/${MY_P}

src_install() {
	emake install DESTDIR="${D}" || die "install fail"
	dodoc AUTHORS ChangeLog || die "doc install fail"
}
