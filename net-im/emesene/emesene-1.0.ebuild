# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit eutils

DESCRIPTION="Platform independent MSN Messenger client written in Python+GTK"
HOMEPAGE="http://www.emesene.org"
SRC_URI="http://downloads.sourceforge.net/${PN}/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"

KEYWORDS="~amd64 ~x86"

DEPEND=">=dev-lang/python-2.4.3
	>=x11-libs/gtk+-2.8.20
	>=dev-python/pygtk-2.8.6"

RDEPEND="${DEPEND}"

S=${WORKDIR}/${PN}

src_install() {
	insinto /usr/share/emesene
	rm GPL PSF LGPL
	doins -r *
	echo -e '#!/bin/sh \n python /usr/share/emesene/Controller.py'>> emesene-start
	dobin emesene-start
	newicon "${S}"/themes/default/icon96.png ${PN}.png
	make_desktop_entry emesene-start "EmeSeNe" ${PN}.png
}
