# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

MY_P="${P/gtk-engines-rezlooks/rezlooks}"

DESCRIPTION="Simple GTK+ theme engine based on Clearlooks."
HOMEPAGE="http://www.gnome-look.org/content/show.php?content=39179"
SRC_URI="http://www.gnome-look.org/content/files/39179-${MY_P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND=">=x11-libs/gtk+-2.6"
RDEPEND="${DEPEND}"

S=${WORKDIR}/${MY_P}

src_install() {
	emake DESTDIR="${D}" install || die "emake install failed"
}
