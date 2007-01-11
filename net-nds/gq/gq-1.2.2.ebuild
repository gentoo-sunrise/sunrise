# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

DESCRIPTION="A GTK+-based LDAP client"
HOMEPAGE="http://www.gq-project.org/"
SRC_URI="mirror://sourceforge/gqclient/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"

# Feel free to make conditional once it is not automagic
# http://www.gentoo.org/proj/en/qa/automagic.xml
IUSE="kerberos" # sasl ssl

RDEPEND=">=x11-libs/gtk+-2
	>=net-nds/openldap-2
	kerberos? ( app-crypt/mit-krb5 )
	dev-libs/openssl
	dev-libs/libxml2
	>=dev-libs/glib-2
	x11-libs/pango
	dev-libs/cyrus-sasl
	>=gnome-base/gnome-keyring-0.4.4"

DEPEND="${RDEPEND}
	dev-util/pkgconfig"


src_compile() {
	local myconf="--enable-browser-dnd --enable-cache --disable-update-mimedb"
	use kerberos && myconf="${myconf} --with-kerberos-prefix=/usr"

	econf ${myconf} || die "econf failed"
	emake || die "emake failed"
}

src_install() {
	rm -f ${D}/usr/share/locale/locale.alias
	emake DESTDIR="${D}" install || die "emake failed"
	dodoc AUTHORS ChangeLog NEWS README* TODO
}
