# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=2
WANT_AUTOMAKE="1.11"
EGIT_BOOTSTRAP="eautoreconf"

inherit autotools base git

EGIT_REPO_URI="git://${PN}.git.sourceforge.net/gitroot/${PN}/${PN}"

DESCRIPTION="A Remote Desktop Protocol Client, forked from rdesktop"
HOMEPAGE="http://www.freerdp.com/"
SRC_URI=""

LICENSE="GPL-2"
SLOT="0"
KEYWORDS=""
IUSE="alsa cups debug gnutls iconv ipv6 largefile libsamplerate nss polarssl \
ssl X"

DEPEND="
	x11-libs/libX11
	ssl? ( >=dev-libs/openssl-0.9.8a )
	nss? ( dev-libs/nss )
	gnutls? ( >=net-libs/gnutls-2.10.1 )
	polarssl? ( >=net-libs/polarssl-0.14.0 )
	alsa? ( media-libs/alsa-lib )
	libsamplerate? ( media-libs/libsamplerate )
	cups? ( net-print/cups )
	iconv? ( virtual/libiconv )"
RDEPEND="${DEPEND}"

DOCS=( AUTHORS ChangeLog NEWS README )

pkg_setup() {
	MY_CRYPTOBACKEND="simple"
	if use polarssl; then
		MY_CRYPTOBACKEND="polarssl"
	fi
	if use nss; then
		if [[ "${MY_CRYPTOBACKEND}" != "simple" ]]; then
			ewarn "You have enabled ${MY_CRYPTOBACKEND} and nss."
			ewarn "Only one will be selected"
		fi
		MY_CRYPTOBACKEND="nss"
	fi
	if use gnutls; then
		if [[ "${MY_CRYPTOBACKEND}" != "simple" ]]; then
			ewarn "You have enabled ${MY_CRYPTOBACKEND} and gnutls."
			ewarn "Only one will be selected"
		fi
		MY_CRYPTOBACKEND="gnutls"
	fi
	if use ssl; then
		if [[ "${MY_CRYPTOBACKEND}" != "simple" ]]; then
			ewarn "You have enabled ${MY_CRYPTOBACKEND} and openssl."
			ewarn "Only one will be selected"
		fi
		MY_CRYPTOBACKEND="openssl"
	fi

	einfo "The selected crypto-backend is: ${MY_CRYPTOBACKEND}"

	if ! use ssl; then
		ewarn "You do not have OpenSSL as the crypto-backend,"
		ewarn "TLS-connections will not be available."
		ewarn "TLS-connectios currently need OpenSSL as crypto-backend."
	fi
}

src_configure() {
	# chipcard and directfb are configurable according to ./configure
	# but they are currently not usable...
	econf \
		--with-crypto="${MY_CRYPTOBACKEND}" \
		$(use_enable ssl tls) \
		$(use_with debug) \
		$(use_with debug debug-channel) \
		$(use_with debug debug-kbd) \
		$(use_with debug debug-rdp5) \
		$(use_with debug debug-serial) \
		$(use_with debug debug-sound) \
		$(use_with alsa sound alsa) \
		$(use_with cups printer cups) \
		$(use_enable iconv) \
		$(use_enable ipv6) \
		$(use_enable largefile) \
		$(use_with libsamplerate) \
		$(use_with X x)
}
