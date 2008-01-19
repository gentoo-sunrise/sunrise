# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="1"
inherit eutils

CLAMTK_KDEVER="0.07"
DESCRIPTION="A frontend for ClamAV using Gtk2-perl."
HOMEPAGE="http://clamtk.sourceforge.net/"
SRC_URI="mirror://sourceforge/clamtk/${P}.tar.gz
	kde? ( mirror://sourceforge/clamtk/clamtk-kde-${CLAMTK_KDEVER}.tar.gz )"

LICENSE="Artistic GPL-2"
SLOT="0"
KEYWORDS="~x86"

LANGS="cs da de es fr gl it pl pt_BR ru sv zh_CN"
IUSE="nls kde"
for i in ${LANGS}; do
	IUSE="${IUSE} linguas_${i}"
done

DEPEND=""
RDEPEND=">=dev-perl/gtk2-perl-1.140
	dev-perl/File-Find-Rule
	dev-perl/libwww-perl
	dev-perl/Date-Calc
	>=app-antivirus/clamav-0.83
	nls? ( dev-perl/Locale-gettext )
	kde? ( || ( kde-base/konqueror:3.5 kde-base/kdebase:3.5 ) )"

src_install() {
	dobin clamtk

	doicon clamtk.png
	domenu clamtk.desktop

	dodoc CHANGES DISCLAIMER README
	doman clamtk.1.gz

	if use nls ; then
		cd po/
		mv cs_CZ.mo cs.mo
		for n in *.mo ; do
			if use linguas_${n/.mo} ; then
				insinto /usr/share/locale/${n/.mo}/LC_MESSAGES
				newins ${n} clamtk.mo
			fi
		done
	fi

	if use kde ; then
		cd "${WORKDIR}"/${PN}-kde-${CLAMTK_KDEVER}
		doicon ${PN}-kde.xpm
		doman ${PN}-kde.1.gz
		docinto KDE
		dodoc CHANGES README
		insinto /usr/share/apps/konqueror/servicemenus
		doins ${PN}-kde.desktop
	fi
}
