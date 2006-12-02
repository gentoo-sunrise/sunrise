# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit kde-functions

MY_P_KDE="QtCurve-KDE3-${PV}" 
MY_P_GTK2="QtCurve-Gtk2-${PV}"
MY_P_GTK1="QtCurve-Gtk1-0.42.2"

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
        gtk1? ( >=x11-libs/gtk+-1.2 )
	kde? ( kde-base/kwin )"

need-kde 3.5

RDEPEND="${DEPEND}"

S="${WORKDIR}"

src_compile() {
    use kde || use gtk || use gtk1 || die "one of gtk, gtk1 or kde needs to be selected"
    if use kde ; then
	cd ${S}/${MY_P_KDE}
	econf --without-arts || die "econf failed"
	emake || die "emake failed"
    fi
    if use gtk ; then
	cd ${S}/${MY_P_GTK2}
	econf || die "econf failed"
	emake || die "emake failed"
    fi
    if use gtk1 ; then
	cd ${S}/${MY_P_GTK1}
	econf || die "econf failed"
	emake || die "emake failed"
    fi 
}

src_install () {
    for pkg in ${MY_P_GTK2} ${MY_P_GTK1} ${MY_P_KDE} ; do
	if [[ -d ${S}/$pkg ]] ; then
	    cd ${S}/$pkg
	    emake DESTDIR="${D}" install || die "emake install failed"
	    docinto $pkg
	    dodoc ChangeLog README TODO
	fi
    done
}
