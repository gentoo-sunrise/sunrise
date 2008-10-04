# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit autotools eutils fdo-mime

DESCRIPTION="An amateur radio logging program"
HOMEPAGE="http://pg4i.chronos.org.uk/"
SRC_URI="http://pg4i.chronos.org.uk/download/${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~ppc ~x86"
IUSE=""

RDEPEND="media-libs/hamlib
	=dev-libs/glib-2*
	>=x11-libs/gtk+-2.12"
DEPEND="${RDEPEND}
	dev-util/pkgconfig"

src_unpack() {
	unpack ${A}
	cd "${S}"
	# Let portage handle updating mimie/desktop databases
	epatch "${FILESDIR}/${P}-desktop-update.patch"
	mkdir -p "${S}"/m4	# make autoconf happy...
	eautoreconf
}

src_compile() {
	# mime-update causes file collisions if enabled
	econf --disable-mime-update --disable-desktop-update
	emake || die "emake failed"
}

src_install() {
	emake DESTDIR="${D}" install || die "emake install failed"
	dodoc AUTHORS BUGS ChangeLog NEWS README
}

pkg_postinst() {
	fdo-mime_desktop_database_update
	fdo-mime_mime_database_update

	if has_version '<media-radio/xlog-1.8' ; then
		ewarn "You have to reconfigure xlog."
		ewarn "(You can find your old configuration in ~/.xlog/preferences.xml.)"
	fi
}

pkg_postrm() {
	fdo-mime_desktop_database_update
	fdo-mime_mime_database_update
}
