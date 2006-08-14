# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit eutils wxwidgets autotools

MY_P=XaraLX-${PV/_pre/r}

DESCRIPTION="Xara LX is a commercial vector graphics platform, recently made
available on Gentoo as a free OpenSource port."
HOMEPAGE="http://www.xaraxtreme.org"
SRC_URI="http://downloads2.xara.com/opensource/${MY_P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86"
IUSE=""

RDEPEND="x11-libs/gtk+
	>=x11-libs/wxGTK-2.6.3
	virtual/libintl
	>=media-libs/libpng-1.2.8
	>=media-libs/jpeg-6b
	app-arch/zip
	dev-lang/perl
	>=dev-libs/libxml2-2.6.0"
DEPEND="${RDEPEND}
	dev-util/pkgconfig
	>=sys-devel/gettext-0.14.3"

S=${WORKDIR}/${MY_P}

pkg_setup() {
	export WX_GTK_VER="2.6"
	need-wxwidgets unicode
}

src_unpack() {
	unpack ${A}
	cd "${S}"

	eautoreconf
}

src_compile() {
	econf --with-wx-config=${WX_CONFIG} --with-wx-base-config=${WX_CONFIG} \
		|| die "econf failed"

	emake || die "emake failed"
}

src_install() {
	# For now installs just the bin
	emake DESTDIR="${D}" install || die "emake install failed"

	doicon ${PN}.png
	dodoc README

	# Fix and install desktop file
	sed -i -e "s#c=xaralx#c=XaraLX#g" ${PN}.desktop
	domenu ${PN}.desktop
}
