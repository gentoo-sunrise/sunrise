# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

DESCRIPTION="Package for controlling post emerge --sync operations"
HOMEPAGE="http://www.electron.me.uk/postsync"
SRC_URI="http://www.electron.me.uk/files/${P}.tar.bz2"
LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86"
IUSE=""
S=${WORKDIR}/${PN}

DEPEND=">=virtual/python-2.3"

RDEPEND="${DEPEND}"

src_install() {
	PORTCFG=$(python -c 'import portage; print portage.USER_CONFIG_PATH,') \
		|| die "Cannot get config path"
	exeinto /usr/sbin
	doexe postsync

	insinto ${PORTCFG}/bin
	doins bin/post_sync
	dosed "s:/etc/portage:${PORTCFG}:g" ${PORTCFG}/bin/post_sync

	insinto /usr/lib/postsync.d
	doins postsync.d/*

	fowners root:portage /usr/sbin/postsync ${PORTCFG}/bin/post_sync \
		/usr/lib/postsync.d/*

	dodoc README ChangeLog doc/*
}

pkg_postinst() {
	einfo
	einfo "Postsync programs and the postsync system are disabled by default."
	einfo "Use postsync -l to see what programs are available then"
	einfo "postsync -e -a <prog> [prog ...] to activate the ones you want."
	einfo
}

pkg_prerm() {
	/usr/sbin/postsync -d
}
