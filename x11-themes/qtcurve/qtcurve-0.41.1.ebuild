# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit kde-functions

MY_P_GTK1="${PN/qtcurve/QtCurve-Gtk1}-0.41" # no .1 release for this
MY_P_GTK2="${P/qtcurve/QtCurve-Gtk2}"
MY_P_KDE="${P/qtcurve/QtCurve-KDE3}"

DESCRIPTION="A set of widget styles for KDE, GTK1, and GTK2 based apps."
HOMEPAGE="http://www.kde-look.org/content/show.php?content=40492"
SRC_URI="kde? ( http://home.freeuk.com/cpdrummond/${MY_P_KDE}.tar.gz )
		gtk1? ( http://home.freeuk.com/cpdrummond/${MY_P_GTK1}.tar.gz )
		gtk? ( http://home.freeuk.com/cpdrummond/${MY_P_GTK2}.tar.gz )"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="gtk gtk1 kde"
DEPEND="
	gtk? (
		dev-libs/atk
		dev-libs/glib
		x11-libs/cairo
		>=x11-libs/gtk+-2.0
		x11-libs/pango
	)
	gtk1? ( =x11-libs/gtk+-1.2* )
	kde? ( kde-base/kdelibs >=x11-libs/qt-3.3 )
"
RDEPEND="${DEPEND}"

S="${WORKDIR}"

src_compile() {
	if use kde ; then
		cd ${S}/${MY_P_KDE}
		econf --without-arts || die "econf failed"
		emake || die "emake failed"
	fi
	if use gtk1 ; then
		cd ${S}/${MY_P_GTK1}
		econf || die "econf failed"
		emake || die "emake failed"
	fi
	if use gtk ; then
		cd ${S}/${MY_P_GTK2}
		econf || die "econf failed"
		emake || die "emake failed"
	fi
}

src_install () {
	for pkg in ${MY_P_GTK1} ${MY_P_GTK2} ${MY_P_KDE} ; do
		if [[ -d ${S}/$pkg ]] ; then
			cd ${S}/$pkg
			emake DESTDIR="${D}" install || die "emake install failed"
			docinto $pkg
			dodoc ChangeLog README TODO
		fi
	done
}
