# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit eutils

DESCRIPTION="VPN daemon using Secure Anycast Tunneling"
HOMEPAGE="http://anytun.org/"
SRC_URI="http://anytun.org/~equinox/${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="examples gcrypt"

RDEPEND=">=dev-libs/boost-1.35
	<dev-libs/boost-1.40
	gcrypt? ( dev-libs/libgcrypt )
	!gcrypt? ( dev-libs/openssl )"
DEPEND="${RDEPEND}
	<app-text/asciidoc-8.5.0" # asciidoc a2x >= 8.5.0 requires an -L switch not	present in lower versions

S="${WORKDIR}/${P}/src"

src_compile() {
	local myconf=""
	use gcrypt || myconf="--use-ssl-crypto"
	# anytun's configure right now only takes 1! option (no --prefix etc), so econf would be too
	# much for your little script and the build would fail
	#econf ${myconf} || die "configure failed"
	./configure ${myconf} || die "configure failed"

	emake || die "make failed"

	einfo "Building manpages"
	emake manpage || die "failed building manpages"
}

src_install() {
	dosbin anytun || die "failed to copy/install an executable"
	dobin anytun-config anytun-controld anytun-showtables anytun-nosync || die "failed to copy/install an executable"
	newinitd "${FILESDIR}/${PN}-0.3.1.init" anytun || die "failed to copy/install initrd script"
	keepdir /var/run/anytun || die "failed to mkdir"
	keepdir /var/run/anytun-controld || die "failed to mkdir"

	cd man/
	doman anyrtpproxy.8 anytun-config.8 anytun-controld.8 anytun-showtables.8 anytun.8 || die "failed to install manpages"

	cd "../../"
	insinto /usr/share/${P}/wireshark-lua/
	doins wireshark-lua/* || die "failed to install wireshark-lua contrib script"

	dodoc AUTHORS ChangeLog README || die "failed to install docs"

	if use examples; then
		insinto /usr/share/doc/${PF}/etc-anytun-examples/
		doins -r etc/anytun/* || die "failed to install examples"
	fi
}

pkg_config() {
	[ -e "${ROOT}"/etc/anytun ] && die "${ROOT}/etc/anytun/ already present, rm -R it first "
	if [ ! -d "${ROOT}"/usr/share/doc/${PF}/etc-anytun-examples/ ]; then
		die "can't copy example configs since examples were not installed (reemerge with USE=\"examples\")"
	fi
	mkdir -p "${ROOT}"/etc/anytun/ || die "couldn't mkdir ${ROOT}/etc/anytun/"
	cp -r "${ROOT}"/usr/share/doc/${PF}/etc-anytun-examples/* "${ROOT}"/etc/anytun/ || die "failed to copy examples"
}

pkg_postinst() {
	enewgroup anytun
	enewuser anytun -1 -1 /var/run/anytun anytun
	einfo "Note that each VPN gets its own directory under /etc/anytun/"
	einfo " (see examples provided with the package)"
	einfo "You can either add tunnels to /etc/anytun/autostart and"
	einfo "start them using /etc/init.d/anytun"
	einfo "Or you can forget the autostart file and create"
	einfo "gentoo-style anytun.{VPN} initrd scripts for each VPN"
	einfo "# ln -s /etc/init.d/anytun /etc/init.d/anytun.client1"
	einfo
	einfo "You can disect anytun traffic using wireshark by plugging the script"
	einfo " /usr/share/${P}/wireshark-lua/satp.lua into wireshark"
}
