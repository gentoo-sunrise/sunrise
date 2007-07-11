# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-tv/freevo/freevo-1.5.4-r2.ebuild,v 1.1 2006/10/24 18:38:21 mattepiu Exp $

inherit distutils

MY_P="${P/_rc/-rc}"

IUSE="dvd lirc matrox minimal mixer nls sqlite tv X directfb fbcon"
DESCRIPTION="Digital video jukebox (PVR, DVR)."
HOMEPAGE="http://www.freevo.org/"
S="${WORKDIR}/${MY_P}"
SRC_URI="mirror://sourceforge/${PN}/${MY_P}.tar.gz"
RESTRICT="nomirror"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"

RDEPEND=">=dev-python/pygame-1.5.6
	>=dev-python/pyxml-0.8.2
	>=dev-python/imaging-1.1.3
	=dev-python/twisted-2.4*
	>=dev-python/twisted-web-0.5.0-r1
	!minimal? ( >=media-video/mplayer-0.92 )
	>=media-libs/freetype-2.1.4
	>=media-libs/libsdl-1.2.5
	>=sys-apps/sed-4
	>=dev-python/elementtree-1.2.6
	>=dev-python/beautifulsoup-3.0
	>=dev-python/kaa-base-0.1.3
	>=dev-python/kaa-metadata-0.6.1
	>=dev-python/kaa-imlib2-0.2.1
	dvd? ( >=media-video/xine-ui-0.9.22 >=media-video/lsdvd-0.10 )
	tv? ( media-tv/tvtime !minimal? ( media-tv/xmltv ) )
	mixer? ( media-sound/aumix )
	matrox? ( >=media-video/matroxset-0.3 )
	lirc? ( app-misc/lirc >=dev-python/pylirc-0.0.3 )
	sqlite? ( =dev-python/pysqlite-1* )"

pkg_setup() {
	if use directfb ; then
		use dvd && ! (built_with_use media-libs/xine-lib directfb) && ewarn "media-libs/xine-lib" was not built with directfb support
		! (built_with_use media-video/mplayer directfb) && ewarn "media-video/mplayer" was not built with directfb support
		if ! (built_with_use media-libs/libsdl directb) ; then
			eerror "media-libs/libsdl" was not built with directdb support
			eerror Please re-emerge libsdl with the directfb use flag
			die "directfb use flag specified but no support in libsdl and others"
		fi
	fi

	if use fbcon ; then
		use dvd && ! (built_with_use media-libs/xine-lib fbcon) && ewarn "media-libs/xine-lib" was not built with fbcon support
		! (built_with_use media-video/mplayer fbcon) && ewarn "media-video/mplayer" was not built with fbcon support
		if ! (built_with_use media-libs/libsdl fbcon) ; then
			eerror "media-libs/libsdl" was not built with fbcon support
			eerror Please re-emerge libsdl with the fbcon use flag
			die "fbcon use flag specified but no support in media-libs/libsdl and others"
		fi
	fi

	if ! (use X || use directfb || use fbcon || use matrox) ; then
		ewarn
		ewarn WARNING - no specific video support specified in USE
		ewarn Please be sure that libsdl supports whatever video
		ewarn support \(X11, fbcon, directfb, etc\) you plan on using
		ewarn
	fi
}

src_unpack() {
	unpack ${A}
	cp "${FILESDIR}/freevo.rc6" "${WORKDIR}/"
	if use X ; then
		sed -e 's/lircd/lircd xdm/g' "${WORKDIR}/freevo.rc6" > "${WORKDIR}/freevo.rc6b"
	else
		sed -e 's/lircd/lircd local/g' "${WORKDIR}/freevo.rc6" > "${WORKDIR}/freevo.rc6b"
	fi
}

src_install() {
	distutils_src_install

	insinto /etc/freevo
	newins local_conf.py.example local_conf.py

	if [ "${PROFILE_ARCH}" == "xbox" ]; then
		sed -i -e "s/# MPLAYER_AO_DEV.*/MPLAYER_AO_DEV='alsa1x'/" ${D}/etc/freevo/local_conf.py
		newins ${FILESDIR}/xbox-lircrc lircrc
	fi

	if use X; then
		echo "#!/bin/bash" > freevo
		echo "${ROOT}/usr/bin/freevoboot startx" >> freevo
		exeinto /etc/X11/Sessions/
		doexe freevo

		KDFREEVO=`kde-config --prefix`
		if [ "x$KDFREEVO" != "x" ]; then
			FREEVOSESSION=`grep ^SessionsDirs= ${KDFREEVO}/share/config/kdm/kdmrc | cut -d= -f 2 | cut -d: -f1`
			if [ "x${FREEVOSESSION}" != "x" ]; then
				insinto ${FREEVOSESSION}
				doins "${FILESDIR}/freevo.desktop" freevo.desktop
			fi
		fi

		insinto /etc/X11/dm/Sessions
		doins "${FILESDIR}/freevo.desktop" freevo.desktop
	fi

	exeinto ${ROOT}/usr/bin
	newexe "${FILESDIR}/freevo.boot" freevoboot
	newconfd "${FILESDIR}/freevo.conf" freevo

	rm -rf "${D}/usr/share/doc"
	newdoc Docs/README README.docs
	dodoc BUGS COPYING ChangeLog FAQ INSTALL PKG-INFO README TODO \
		Docs/{CREDITS,NOTES,plugins/*.txt}
	cp -r Docs/{installation,plugin_writing} "${D}/usr/share/doc/${PF}"

	use nls || rm -rf ${D}/usr/share/locale

	local myconf
	if [ "`${ROOT}/bin/ls -l /etc/localtime | grep -e "Europe\|GMT"`" ] || [ "`${ROOT}/bin/cat /etc/timezone | grep -e "Europe\|GMT"`" ] ; then
		myconf="${myconf} --tv=pal"
	fi
	if [ "${PROFILE_ARCH}" == "xbox" ]; then
		myconf="${myconf} --geometry=640x480 --display=x11"
	elif use matrox && use directfb; then
		myconf="${myconf} --geometry=768x576 --display=dfbmga"
	elif use matrox ; then
		myconf="${myconf} --geometry=768x576 --display=mga"
	elif use directfb; then
		myconf="${myconf} --geometry=768x576 --display=directfb"
	elif use X ; then
		myconf="${myconf} --geometry=800x600 --display=x11"
	else
		myconf="${myconf} --geometry=800x600 --display=fbdev"
	fi

	sed -i 's/\/etc\/freevo\/freevo.conf/freevo.conf/g' ${S}/src/setup_freevo.py || die
	cd src
	python setup_freevo.py ${myconf} || die "configure problem"
	insinto ${ROOT}/etc/freevo
	newins freevo.conf freevo.conf || die "configure issue"
}

pkg_postinst() {
	einfo
	einfo "Please check /etc/freevo/freevo.conf and"
	einfo "/etc/freevo/local_conf.py before starting Freevo."
	einfo "To rebuild freevo.conf with different parameters,"
	einfo "please run:"
	einfo "    freevo setup"

	ewarn
	ewarn "Freevo starting method for freevo-only-systems is changed, because"
	ewarn "initscript would run it as root and this may cause insecurity."
	ewarn "That is now substituted with freevoboot, a wrapper to be runned"
	ewarn "as user. Configuration is still in /etc/conf.d/freevo"
	ewarn "and you can always use freevo directly."
	if use X ; then
		echo
		ewarn "If you're using a Freevo-only system with X, you'll need"
		ewarn " to setup the autologin (as user) and choose freevo as"
		ewarn "default session. If you need to run recordserver/webserver"
		ewarn "at boot, please use /etc/conf.d/freevo as always."
		echo
		ewarn "Should you decide to personalize your freevo.desktop"
		ewarn "session, keep inside ${ROOT}/usr/bin/freevoboot startx (wrapper)."
	else
		echo
		ewarn "If you want Freevo to start automatically,you'll need"
		ewarn "to follow instructions at :"
		ewarn "http://freevo.sourceforge.net/cgi-bin/doc/BootFreevo"
		echo
		ewarn "*NOTE: you can use mingetty or provide a login"
		ewarn "program for getty to autologin as limited privileges user"
		ewarn "a tutorial for getty is at:"
		ewarn "http://ubuntuforums.org/showthread.php?t=152274"
		echo
		ewarn "Sorry for the disadvantage, this is done for bug #150568."
	fi

	if [ -e "${ROOT}/etc/init.d/freevo" ] ; then
		ewarn
		ewarn "Please remove ${ROOT}/etc/init.d/freevo as is a security"
		ewarn "threat. To set autostart read above."
	fi

	if [ -e "${ROOT}/opt/freevo" ] ; then
		ewarn
		ewarn "Please remove ${ROOT}/opt/freevo because it is no longer used."
	fi
	if [ -e "${ROOT}/etc/freevo/freevo_config.py" ] ; then
		ewarn
		ewarn "Please remove ${ROOT}/etc/freevo/freevo_config.py."
	fi
	if [ -e "${ROOT}/etc/init.d/freevo-record" ] ; then
		ewarn
		ewarn "Please remove ${ROOT}/etc/init.d/freevo-record"
	fi
	if [ -e "${ROOT}/etc/init.d/freevo-web" ] ; then
		ewarn
		ewarn "Please remove ${ROOT}/etc/init.d/freevo-web"
	fi

	if ! (use X || use directfb || use fbcon || use matrox) ; then
		ewarn
		ewarn WARNING - no specific video support specified in USE
		ewarn Please be sure that libsdl supports whatever video
		ewarn support \(X11, fbcon, directfb, etc\) you plan on using,
		ewarn as well as all other modules \(mplayer, etc\)
		ewarn
	else
		einfo
		use directfb && use dvd && ! (built_with_use media-libs/xine-lib directfb) && ewarn "media-libs/xine-lib" was not built with directfb support
		use directfb && ! (built_with_use media-video/mplayer directfb) && ewarn "media-video/mplayer" was not built with directfb support
		use fbcon && use dvd && ! (built_with_use media-libs/xine-lib fbcon) && ewarn "media-libs/xine-lib" was not built with fbcon support
		use fbcon && ! (built_with_use media-video/mplayer fbcon) && ewarn "media-video/mplayer" was not built with fbcon support
		einfo
		einfo If you wish to use video methods that were not specified
		einfo in USE, please ensure that media-libs/libsdl is emerged with
		einfo appropriate support, as well as other modules \(mplayer, etc\)
		einfo
	fi
	echo
}
