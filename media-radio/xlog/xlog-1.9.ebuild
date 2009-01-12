# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit autotools eutils fdo-mime

DESCRIPTION="An amateur radio logging program"
HOMEPAGE="http://www.qsl.net/pg4i/linux/xlog.html"
SRC_URI="http://www.qsl.net/pg4i/download/${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~ppc ~x86"
IUSE=""

RDEPEND="media-libs/hamlib
	=dev-libs/glib-2*
	>=x11-libs/gtk+-2.12"
DEPEND="${RDEPEND}
	sys-devel/gettext
	dev-util/pkgconfig"

src_unpack() {
	unpack ${A}
	cd "${S}"
	# Let portage handle updating mime/desktop databases,
	# fix for wrong placed file,
	# fix for respecting DESTDIR and
	# and finally fix to respect docdir=...
	epatch "${FILESDIR}/${P}-desktop-update.patch" \
		"${FILESDIR}/${P}-key.patch" \
		"${FILESDIR}/${P}-destdir.patch" \
		"${FILESDIR}/${P}-docdir.patch"
	mkdir -p "${S}"/m4	# make autoconf happy...
	eautoreconf
}

src_compile() {
	# mime-update causes file collisions if enabled
	econf --disable-mime-update --disable-desktop-update \
		--docdir=/usr/share/doc/${PF}
	emake || die "emake failed"
}

src_install() {
	emake DESTDIR="${D}" install || die "emake install failed"
	dodoc AUTHORS data/doc/THANKS NEWS README || die "dodoc failed"
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
