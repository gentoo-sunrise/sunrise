# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="2"

PYTHON_DEPEND="2"

inherit git-2 multilib python user

DESCRIPTION="An HMO and GoBack server for Tivo"
HOMEPAGE="http://pytivo.sourceforge.net/"
SRC_URI=""

EGIT_REPO_URI="git://github.com/wmcbrine/pytivo.git"
EGIT_COMMIT="cf0971e929661dabd3a34f363500f8d6f575d58f"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND=""
RDEPEND="${DEPEND}
	virtual/ffmpeg"

pkg_setup() {
	enewgroup pytivo
	enewuser pytivo -1 -1 -1 pytivo
	python_set_active_version 2
}

src_prepare() {
	python_convert_shebangs -r 2 .
}

src_install() {
	MY_LIBDIR="/usr/$(get_libdir)/${PN}"

	insinto $MY_LIBDIR
	doins *.py *.pyw  || die "Install failed"
	doins -r Cheetah mutagen plugins templates xmpp || die "Install failed"

	fperms 0755 ${MY_LIBDIR}/pyTivo.py || die "Cannot set permissions"

	doinitd "${FILESDIR}"/pytivo || die "Cannot create init.d launcher"

	dodoc README || die "Cannot install docs"
	newdoc pyTivo.conf.dist pyTivo.conf || die "Cannot install docs"

	dosym ${MY_LIBDIR}/pyTivo.py /usr/bin/pytivo \
		|| die "Cannot create symlink to launcher"
}

pkg_postinst() {
	ewarn "You must setup /etc/pyTivo.conf before pyTivo can be started. A"
	ewarn "sample configuration file pyTivo.conf is available in"
	ewarn "/usr/share/doc/${PF}"
	ewarn

	elog "pyTivo can be run as a normal user or it can be started"
	elog "automatically by adding pytivo to the default runlevel by"
	elog "	# rc-update add pytivo default"
	elog "as root."
}
