# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit eutils qt4

# usefull for test/rc releases
MY_PV="${PV/_/-}"
MY_P="${PN}-${MY_PV}"

HTTPMIRR="http://vivid.dat.pl/psi"
IUSE="ssl crypt xmms xscreensaver"
#QV="2.0"

DESCRIPTION="QT 4.x Jabber Client, with Licq-like interface"
HOMEPAGE="http:/psi-im.org/"
# translations from http://tanoshi.net/language.html
# polish translation contains special texts for patches from extras-version
SRC_URI="mirror://sourceforge/psi/${MY_P}.tar.bz2
		${HTTPMIRR}/psi-branchupdate-20060618.patch.bz2"
#		linguas_ar? ( ${HTTPMIRR}/psi_ar-0.9.3.tar.bz2 )
#		linguas_bg? ( ${HTTPMIRR}/psi_bg-0.10-a.tar.bz2 )
#		linguas_ca? ( ${HTTPMIRR}/psi_ca-0.9.3.tar.bz2 )
#		linguas_cs? ( ${HTTPMIRR}/psi_cs-0.9.3-a.tar.bz2 )
#		linguas_da? ( ${HTTPMIRR}/psi_da-0.9.3.tar.bz2 )
#		linguas_de? ( ${HTTPMIRR}/psi_de-0.9.3-c.tar.bz2 )
#		linguas_ee? ( ${HTTPMIRR}/psi_ee-0.9.3_rc1.tar.bz2 )
#		linguas_el? ( ${HTTPMIRR}/psi_el-0.9.3-a.tar.bz2 )
#		linguas_eo? ( ${HTTPMIRR}/psi_eo-0.10-a.tar.bz2 )
#		linguas_es? ( ${HTTPMIRR}/psi_es-0.10-a.tar.bz2 )
#		linguas_et? ( ${HTTPMIRR}/psi_et-0.9.3-a.tar.bz2 )
#		linguas_fi? ( ${HTTPMIRR}/psi_fi-0.9.3.tar.bz2 )
#		linguas_fr? ( ${HTTPMIRR}/psi_fr-0.9.3-a.tar.bz2 )
#		linguas_it? ( ${HTTPMIRR}/psi_it-0.9.3.tar.bz2 )
#		linguas_jp? ( ${HTTPMIRR}/psi_jp-0.9.3.tar.bz2 )
#		linguas_hu? ( ${HTTPMIRR}/psi_hu-0.10-a.tar.bz2 )
#		linguas_mk? ( ${HTTPMIRR}/psi_mk-0.10-a.tar.bz2 )
#		linguas_nl? ( ${HTTPMIRR}/psi_nl-0.10-a.tar.bz2 )
#		linguas_pl? ( ${HTTPMIRR}/psi_pl-0.9.3-1.tar.bz2 )
#		linguas_pt? ( ${HTTPMIRR}/psi_pt-0.9.3.tar.bz2 )
#		linguas_ptBR? ( ${HTTPMIRR}/psi_ptBR-0.10-a.tar.bz2 )
#		linguas_ru? ( ${HTTPMIRR}/psi_ru-0.9.3-a.tar.bz2 )
#		linguas_se? ( ${HTTPMIRR}/psi_se-0.9.3_rc1.tar.bz2 )
#		linguas_sk? ( ${HTTPMIRR}/psi_sk-0.9.3-a.tar.bz2 )
#		linguas_sl? ( ${HTTPMIRR}/psi_sl-0.10-a.tar.bz2 )
#		linguas_sr? ( ${HTTPMIRR}/psi_sr-0.9.3.tar.bz2 )
#		linguas_sv? ( ${HTTPMIRR}/psi_sv-0.9.3.tar.bz2 )
#		linguas_sw? ( ${HTTPMIRR}/psi_sw-0.9.3.tar.bz2 )
#		linguas_vi? ( ${HTTPMIRR}/psi_vi-0.10-a.tar.bz2 )
#		linguas_zh? ( ${HTTPMIRR}/psi_zh-0.9.3-a.tar.bz2 )"

SLOT="0"
LICENSE="GPL-2"
KEYWORDS="~x86 ~amd64"

#After final relase we do not need this
S="${WORKDIR}/${MY_P}"

DEPEND=">app-crypt/qca-1.99
	$(qt4_min_version 4.1.3)
	xscreensaver? ( x11-misc/xscreensaver )
	xmms? ( media-sound/xmms )"

RDEPEND="${DEPEND}
	ssl? ( app-crypt/qca-openssl )
	crypt? ( app-crypt/qca-gnupg )"

src_unpack() {
		einfo "This package fails building on some systems. Work is in progress
		to fix those issues"
		unpack ${A}

		cd ${S}
		epatch ${WORKDIR}/psi-branchupdate-20060618.patch
		epatch ${FILESDIR}/psi-slotted_qca2.patch
#		epatch ${FILESDIR}/psi-pathfix2.patch
#		epatch ${FILESDIR}/psi-desktop2.patch
#		epatch ${FILESDIR}/psi-reverse_trayicon2.patch

		einfo ""
		einfo "Unpacking language files, you must have linguas_* in USE where"
		einfo "'*' is the language files you wish. English is always available"
		einfo ""
		cd ${WORKDIR}
		if ! [ -d langs ] ; then
			mkdir langs
		fi
		local i
		for i in  `ls -c1 | grep "\.{ts,qm}$"` ; do
			mv $i langs
		done
}

src_compile() {
	# growl is mac osx extension only - maybe someday we will want this
	local myconf="--disable-growl"

	use xscreensaver || myconf="${myconf} --disable-xss"
	use xmms || myconf="${myconf} --disable-xmms"

	QTDIR=/usr/lib ./configure --prefix=/usr ${myconf} || die "configure failed"

	# for CXXFLAGS from make.conf
	cd ${S}/src
	qmake src.pro \
		QTDIR=/usr/lib \
		QMAKE_CXXFLAGS_RELEASE="${CXXFLAGS}" \
		QMAKE=/usr/bin/qmake \
		QMAKE_RPATH= \
		|| die "qmake failed"

	cd ${S}
	qmake psi.pro \
		QTDIR=/usr/lib \
		QMAKE_CXXFLAGS_RELEASE="${CXXFLAGS}" \
		QMAKE=/usr/bin/qmake \
		QMAKE_RPATH= \
		|| die "qmake failed"

	emake || die "make failed"

	einfo "Building language packs"
	cd ${WORKDIR}/langs
	for i in `ls -c1 | grep "\.ts$"` ; do
		lrelease $i
	done;
}

src_install() {
	einfo "Installing"
	make INSTALL_ROOT="${D}" install || die "Make install failed"

	#this way the docs will also be installed in the standard gentoo dir
	for i in roster system emoticons; do
		newdoc ${S}/iconsets/${i}/README README.${i}
	done;
	newdoc certs/README README.certs
	dodoc ChangeLog README TODO

	#Install language packs
	cp ${WORKDIR}/langs/psi_*.qm ${D}/usr/share/psi/
}
