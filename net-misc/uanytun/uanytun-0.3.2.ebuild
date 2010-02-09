# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit eutils

DESCRIPTION="Tiny VPN daemon using Secure Anycast Tunneling"
HOMEPAGE="http://anytun.org/"
SRC_URI="http://anytun.org/download/${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="examples gcrypt"

RDEPEND="gcrypt? ( dev-libs/libgcrypt )
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

	newinitd "${FILESDIR}/${PN}-0.3.1.init" ${PN} || die "failed to copy/install initrd script"

	cd ../
	dodoc AUTHORS ChangeLog README || die "failed to install docs"

	#patch any examples to use user "antun" instad of "uanytun"
	find "${D}"/usr/share/doc/${PF}/examples/etc/ -name "config" \
		-exec sed -i 's/\(username\|groupname\) uanytun$/\1 anytun/' {} \;
}

pkg_config() {
	[ ! -d "${ROOT}"/usr/share/doc/${PF}/examples/etc/${PN} ] && \
		die "can't copy example configs since examples were not installed (reemerge with USE='examples')"
	for example in autostart client1 client2 client3 p2p-a p2p-b; do
		[ -e "${ROOT}"/etc/${PN}/${example} ] && die "${ROOT}/etc/${PN}/${example} already present, rm -R it first"
	done
	cp -rv "${ROOT}"/usr/share/doc/${PF}/examples/etc/${PN} "${ROOT}"/etc/ || die "failed to copy examples"
}

pkg_postinst() {
	enewgroup anytun
	enewuser anytun -1 -1 /var/run/ anytun
	elog "Note that each VPN gets its own directory under /etc/${PN}/"
	elog "(see examples provided with the package)"
	elog "Use the following command to create gentoo-style"
	elog "uanytun.{VPN} initrd scripts for each VPN"
	elog "# ln -s /etc/init.d/${PN} /etc/init.d/${PN}.client1"
}
