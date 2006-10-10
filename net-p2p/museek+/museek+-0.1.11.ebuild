# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit qt3 eutils flag-o-matic

DESCRIPTION="a SoulSeek client which uses a daemon and multiple gui clients."
HOMEPAGE="http://museek-plus.sourceforge.net/"
SRC_URI="mirror://sourceforge/${PN/+/-plus}/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86"
IUSE="debug gtk ncurses qsa qt3 vorbis"

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
		=dev-util/scons-0.96*
		dev-lang/swig"

pkg_setup() {
	if use ncurses && ! built_with_use dev-lang/python ncurses ; then
		eerror "In order to build Mucose (museek ncurses client)"
		eerror "you need dev-lang/python built with ncurses USE flag enabled."
		die "no ncurses support in Python"
	fi

	if use qsa && ! use qt3 ; then
		eerror "In order to use QSA you need to build Museek+"
		eerror "with QT3 support too."
		die "using qsa without qt3"
	fi
}

src_unpack() {
	unpack ${A}
	cd "${S}"
	epatch "${FILESDIR}/${P}-defaults.py.patch"
	epatch "${FILESDIR}/${P}-SConstruct.patch"
}

src_compile() {
	local myconf=""
	use qt3 || myconf="${myconf} MUSEEQ=no"
	use qsa || myconf="${myconf} QSA=no"
	use gtk || myconf="${myconf} MUSETUPGTK=no"
	use ncurses || myconf="${myconf} MUCOUS=no"
	use vorbis || myconf="${myconf} VORBIS=no"
	use debug && myconf="${myconf} MULOG=cycle,debug"

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

	if use qt3 ; then
		doicon "icons/museeq-circle2.png"
		make_desktop_entry ${PN/k+/q} "Museeq" museeq-circle2.png \
		"Qt;Network;P2P"
	fi

	# conf.d and init.d scripts by SeeSchloss
	#newinitd "${FILESDIR}/init.d-mulog" mulog
	newinitd "${FILESDIR}/init.d-museekd" museekd

	#newconfd "${FILESDIR}"/conf.d-mulog mulog
	newconfd "${FILESDIR}/conf.d-museekd" museekd
}

pkg_postinst() {
	elog "Look at /etc/conf.d/museekd and configure all options"
	elog "before starting it. When you are done,"
	elog "configure all settings with musetup or musetup-gtk."
}
