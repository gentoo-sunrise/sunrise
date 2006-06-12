# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit eutils gnome2

DESCRIPTION="Data-protection and recovery tool for DVDs"
HOMEPAGE="http://dvdisaster.berlios.de/"
SRC_URI="http://download.berlios.de/dvdisaster/${P}.tar.bz2"

LICENSE="GPL-2"
IUSE="gnome nls"
KEYWORDS="~x86 ~amd64"
SLOT="0"

DEPEND=">=x11-libs/gtk+-2.2
	dev-util/pkgconfig
	nls? ( sys-devel/gettext )"

RESTRICT="mirror"

src_unpack() {
	unpack ${A}
	cd "${S}"
	# This patch lets dvdisaster work with DVD-ROM booktype discs
	epatch ${FILESDIR}/dvd-rom-${PV}.patch || die "patch failed"
}

src_compile() {
	local myconf
	# use_with won't work
	if use nls ; then
		myconf="${myconf} --with-nls=yes --localedir=/usr/share/locale"
	else
		myconf="${myconf} --with-nls=no"
	fi
	use debug && myconf="${myconf} --debug --with-memdebug=yes"
	econf ${myconf} --docdir=/usr/share/doc || die "econf failed"
	emake || die "emake failed"
}

src_install() {
	make install \
	BINDIR=${D}/usr/bin \
	DOCSUBDIR=${D}/usr/share/doc/${P} \
	MANDIR=${D}/usr/share/man \
	LOCALEDIR=${D}/usr/share/locale \
	|| die "make install failed"

	insinto /usr/share/pixmaps
	newins contrib/${PN}48.png ${PN}.png
	for res in 16 32 48 64 ; do
		insinto /usr/share/icons/hicolor/${res}x${res}/apps/
		newins contrib/${PN}${res}.png ${PN}.png
	done

	sed -i -e "s:48::" ${S}/contrib/${PN}.desktop || die "sed failed"
	insinto /usr/share/applications
	doins contrib/${PN}.desktop

	rm -f ${D}/usr/bin/*.sh
}

pkg_postinst() {
	use gnome && gnome2_pkg_postinst
}

pkg_postrm() {
	use gnome && gnome2_pkg_postrm
}
