# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="2"

DESCRIPTION="Provides an alternative back-end for configuration files"
HOMEPAGE="http://elektra.sourceforge.net/"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="coverage debug doc examples iconv test"

RDEPEND="dev-libs/libxml2
	sys-devel/libtool
	coverage? ( dev-util/lcov )"
DEPEND="${RDEPEND}
	app-text/docbook-xsl-stylesheets
	dev-libs/libxslt
	doc? ( app-doc/doxygen )"

src_configure() {
	# berkeleydb, daemon, fstab, gconf, python do not work
	econf \
		--disable-berkeleydb \
		$(use_enable coverage gcov) \
		--enable-cpp \
		--disable-daemon \
		$(use_enable debug) \
		--disable-fstab \
		--disable-gconf \
		$(use_with iconv) \
		--enable-ini \
		--enable-passwd \
		--disable-python \
		--disable-static \
		$(use_enable test xmltest) \
		--with-docdir=/usr/share/doc/${PF} \
		--with-develdocdir=/usr/share/doc/${PF}
}

src_install() {
	emake DESTDIR="${D}" install || die
	dodoc AUTHORS ChangeLog NEWS README TODO || die
	if ! use doc ; then
		rm -r "${D}"/usr/share/doc/${PF}/api-html || die
	fi
	if ! use examples ; then
		rm -r "${D}"/usr/share/doc/${PF}/scripts || die
	fi

	# collision with media-libs/allegro
	mv -v "${D}"/usr/share/man/man3/key.3 "${D}"/usr/share/man/man3/elektra-key.3 || die
}

pkg_postinst() {
	DTVERSION=`find /usr/share/sgml -name elektra.xsd | tail -n 1`
	kdb set system/sw/kdb/current/schemapath "${DTVERSION}"
	einfo "See manpages elektra and kdb for more information."
	einfo "man 3 key has been moved to man 3 elektra-key."
}