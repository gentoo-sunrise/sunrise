# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit eutils

DESCRIPTION="VPN daemon using Secure Anycast Tunneling"
HOMEPAGE="http://anytun.org/"
SRC_URI="http://anytun.org/download/${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="examples gcrypt"

RDEPEND=">=dev-libs/boost-1.35
	gcrypt? ( dev-libs/libgcrypt )
	!gcrypt? ( dev-libs/openssl )"
DEPEND="${RDEPEND}
	app-text/asciidoc"

S=${S}/src

src_compile() {
	local myconf
	use gcrypt || myconf="--use-ssl-crypto"
	use examples\
		&& myconf="${myconf} --examplesdir=/usr/share/doc/${PF}/examples/etc" \
		|| myconf="${myconf} --no-examples"
	econf --ebuild-compat ${myconf}

	einfo "Building executables"
	emake || die "make failed"

	einfo "Building manpages"
	emake manpage || die "failed building manpages"
}

src_install() {
	emake DESTDIR="${D}" install || die "make install failed"
	rm -Rf "${D}"/etc/init.d
	#as long as README just contains path to examples, only install it with examples
	use examples || rm -f "${D}"/etc/${PN}/README
	keepdir /var/run/anytun || die "failed to mkdir"
	keepdir /var/run/anytun-controld || die "failed to mkdir"

	newinitd "${FILESDIR}/${PN}-0.3.1.init" ${PN} || die "failed to copy/install initrd script"

	cd ../
	dodoc AUTHORS ChangeLog README || die "failed to install docs"

	insinto /usr/share/${P}/wireshark-lua/
	doins wireshark-lua/satp.lua || die "failed to install wireshark-lua contrib script"
}

pkg_config() {
	[ ! -d "${ROOT}"/usr/share/doc/${PF}/examples/etc/${PN} ] && \
		die "can't copy example configs since examples were not installed (reemerge with USE='examples')"
	for example in autostart server client1 client2 client3 p2p-a p2p-b; do
		[ -e "${ROOT}"/etc/${PN}/${example} ] && die "${ROOT}/etc/${PN}/${example} already present, rm -R it first"
	done
	cp -rv "${ROOT}"/usr/share/doc/${PF}/examples/etc/${PN} "${ROOT}"/etc/ || die "failed to copy examples"
}

pkg_postinst() {
	enewgroup anytun
	enewuser anytun -1 -1 /var/run/anytun anytun
	elog "Please refer to the README file regarding the syntax of the /etc/${PN}/"
	elog "configuration files or see examples provided with the package"
	elog "You can use gentoo-style ${PN}.{VPN} initrd scripts to start "
	elog "VPNs separately. Just symlink to the initscript, e.g.:"
	elog "# ln -s /etc/init.d/${PN} /etc/init.d/${PN}.client1"
	elog
	elog "You can disect anytun traffic using wireshark by plugging the script"
	elog " /usr/share/${P}/wireshark-lua/satp.lua into wireshark"
}
