# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit eutils

DESCRIPTION="Merging locate is an utility to index and quickly search for files"
HOMEPAGE="http://carolina.mff.cuni.cz/~trmac/blog/mlocate/"
SRC_URI="http://people.redhat.com/mitr/${PN}/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86"
IUSE=""

DEPEND="sys-apps/shadow"
RDEPEND="${DEPEND}
	!sys-apps/slocate
	!sys-apps/rlocate"

pkg_setup() {
	enewgroup locate
}

src_compile() {
	econf || die
	emake groupname=locate || die "emake failed"
}

src_install() {
	emake groupname=locate DESTDIR="${D}" install || die "emake install failed"
	dodoc AUTHORS ChangeLog README NEWS

	insinto /etc
	doins "${FILESDIR}/updatedb.conf"
	fperms 0644 /etc/updatedb.conf

	insinto /etc/cron.daily
	newins "${FILESDIR}/mlocate.cron" mlocate
	fperms 0755 /etc/cron.daily/mlocate

	fowners root:locate /usr/bin/locate
	fperms go-r,g+s /usr/bin/locate

	chown -R root:locate "${D}/var/lib/mlocate"
	fperms 0750 /var/lib/mlocate

	touch "${D}/var/lib/mlocate/mlocate.db"
}

pkg_postinst() {
	einfo "Note that the /etc/updatedb.conf file is generic"
	einfo "Please customize it to your system requirements"
}
