# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

DESCRIPTION="A GTK+-based LDAP client"
HOMEPAGE="http://www.gq-project.org/"
SRC_URI="mirror://sourceforge/gqclient/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="kerberos"

RDEPEND=">=x11-libs/gtk+-2.6
	net-nds/openldap
	kerberos? ( virtual/krb5 )
	dev-libs/openssl
	dev-libs/libxml2
	>=dev-libs/glib-2.6
	x11-libs/pango
	dev-libs/cyrus-sasl
	gnome-base/gnome-keyring
	gnome-base/libglade
	dev-libs/libgcrypt"
DEPEND="${RDEPEND}
	dev-util/pkgconfig
	dev-util/intltool"

src_compile() {
	local myconf="--enable-browser-dnd --enable-cache --disable-update-mimedb"

	econf ${myconf} $(use_with kerberos kerberos-prefix /usr) \
		|| die "econf failed"
	emake || die "emake failed"
}

src_install() {
	rm -f "${D}"/usr/share/locale/locale.alias
	emake DESTDIR="${D}" install || die "emake install failed"
	dodoc AUTHORS ChangeLog NEWS README* TODO
}
