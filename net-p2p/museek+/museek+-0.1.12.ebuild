# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit qt3 eutils

DESCRIPTION="A SoulSeek client which uses a daemon and multiple gui clients."
HOMEPAGE="http://www.museek-plus.org"
SRC_URI="mirror://sourceforge/museek-plus/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86"
IUSE="debug gtk ncurses qsa qt3 trayicon vorbis"

LANGS="fr de es it pl ru pt_BR ja zh sk he ar cs"

for X in ${LANGS} ; do
	IUSE="${IUSE} linguas_${X}"
done

RDEPEND="dev-lang/python
		>=dev-cpp/libxmlpp-1.0.2
		gtk? ( >=dev-python/pygtk-2.6.1 )
		qsa? ( >=dev-libs/qsa-1.1.1 )
		qt3? ( $(qt_min_version 3.3) )
		vorbis? ( media-libs/libvorbis
				media-libs/libogg )"
DEPEND="${RDEPEND}
		>=dev-util/scons-0.96
		dev-lang/swig"

pkg_setup() {
	if use ncurses && ! built_with_use dev-lang/python ncurses ; then
		eerror "In order to build Mucous (museek ncurses client)"
		eerror "you need dev-lang/python built with ncurses USE flag enabled."
		die "no ncurses support in Python"
	fi

	if use qsa && ! use qt3 ; then
		eerror "In order to use QSA you need to build Museek+"
		eerror "with QT3 support too."
		die "using qsa without qt3"
	fi
}

src_compile() {
	local myconf=""
	use qt3 || myconf="${myconf} MUSEEQ=no"
	use qsa || myconf="${myconf} QSA=no"
	use gtk || myconf="${myconf} MUSETUPGTK=no"
	use ncurses || myconf="${myconf} MUCOUS=no"
	use vorbis || myconf="${myconf} VORBIS=no"
	use trayicon || myconf="${myconf} MUSEEQTRAYICON=no"
	use debug || myconf="${myconf} RELEASE=yes MULOG=none"

	local mylinguas=""
	for X in ${LANGS} ; do
		if use linguas_${X} ; then
			mylinguas="${mylinguas}${X},"
		fi
	done

	myconf="${myconf} MUSEEQTRANSLATIONS=${mylinguas/,$/}"

	scons ${myconf} CFLAGS="${CFLAGS}" PREFIX=/usr || die "scons failed"
}

src_install() {
	scons DESTDIR="${D}" install || die "scons install failed"
	dodoc README
	exeinto /usr/bin
	doexe ${FILESDIR}/museek

	if use qt3 ; then
		doicon "icons/museeq-circle2.png"
		make_desktop_entry museeq "Museeq" museeq-circle2.png "Qt;Network;P2P"
	fi
}

pkg_postinst() {
	elog "Use museek to manage start/restart/stop of the daemon,"
	elog "you can use it to launch museek applications too."
}
