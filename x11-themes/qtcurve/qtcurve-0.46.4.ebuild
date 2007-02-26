# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

MY_P_GTK1="QtCurve-Gtk1-0.42.2"
MY_P_GTK2="QtCurve-Gtk2-${PV}"
MY_P_KDE="QtCurve-KDE3-${PV}"

DESCRIPTION="A set of widget styles for KDE, GTK1, and GTK2 based apps."
HOMEPAGE="http://www.kde-look.org/content/show.php?content=40492"
SRC_URI="kde? ( http://www.cpdrummond.freeuk.com/${MY_P_KDE}.tar.gz )
		gtk1? ( http://www.cpdrummond.freeuk.com/${MY_P_GTK1}.tar.gz )
		gtk? ( http://www.cpdrummond.freeuk.com/${MY_P_GTK2}.tar.gz )"
LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="gtk1 gtk kde"
DEPEND="gtk? ( >=x11-libs/gtk+-2.6 )
	gtk1? ( =x11-libs/gtk+-1.2* )
	kde? ( kde-base/kdelibs )"

RDEPEND="${DEPEND}"

S="${WORKDIR}"

src_compile() {
	use kde || use gtk || use gtk1 || die "one of gtk, gtk1 or kde needs to be selected"
	if use kde ; then
		cd "${S}"/${MY_P_KDE}
		econf --without-arts || die "econf failed"
		emake || die "emake failed"
	fi
	if use gtk1 ; then
		cd "${S}"/${MY_P_GTK1}
		econf || die "econf failed"
		emake || die "emake failed"
	fi
	if use gtk ; then
		cd "${S}"/${MY_P_GTK2}
		econf || die "econf failed"
		emake || die "emake failed"
	fi
}

src_install () {
	for pkg in ${MY_P_GTK1} ${MY_P_GTK2} ${MY_P_KDE} ; do
		if [[ -d "${S}"/${pkg} ]] ; then
			cd "${S}"/${pkg}
			emake DESTDIR="${D}" install || die "emake install failed"
			docinto ${pkg}
			dodoc ChangeLog README TODO
		fi
	done
}

pkg_postinst(){
	if use gtk1 ; then
		elog "For GTK1 copy /usr/share/themes/QtCurve/gtk/gtkrc"
		elog " to either"
		elog "     /etc/gtk/gtkrc        To enable this theme for *all* users"
		elog " or"
		elog "     ~/.gtkrc              To enable for just yourself."
		elog " Alternatively, edit ~/.gtkrc so that it looks like:"
		elog "     include \"/usr/share/themes/QtCurve/gtk/gtkrc\""
		elog ""
	fi
	if use gtk2 ; then
		elog "For GTK2 edit ~/.gtkrc-2.0 so that it for example looks like:"
		elog  "     include \"/usr/share/themes/QtCurve/gtk-2.0/gtkrc\""
		elog  "     style \"user-font\""
		elog  "     {"
		elog  "         font_name=\"Helvetica 9\""
		elog  "     }"
		elog  "     widget_class \"*\" style \"user-font\""
		elog  "     gtk-theme-name=\"QtCurve\""
		elog  "     gtk-font-name=\"Helvetica 9\""
		elog  " "
	fi
}
