# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit eutils

DESCRIPTION="tiny VPN daemon using Secure Anycast Tunneling"
HOMEPAGE="http://anytun.org/"
SRC_URI="http://anytun.org/download/${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="examples gcrypt"

RDEPEND="gcrypt? ( dev-libs/libgcrypt )
		!gcrypt? ( dev-libs/openssl )"
DEPEND="${RDEPEND}
	<app-text/asciidoc-8.5.0" # asciidoc a2x >= 8.5.0 requires an -L switch not	present in lower versions

S=${S}/src

src_compile() {
	local myconf=""
	use gcrypt || myconf="--use-ssl-crypto"
	#uanytun doesn't use autoconf and fails with options like --build --infodir	--host ...
	./configure --prefix=/usr --mandir=/usr/share/man --sysconfdir=/etc ${myconf} || die "configure failed"

	emake || die "make failed"

	einfo "Building manpages"
	emake manpage || die "failed building manpages"
}

src_install() {
	#make target install-bin is buggy
	dosbin uanytun || die "failed to copy/install an executable"
	newinitd "${FILESDIR}/${P}.init" uanytun || die "failed to copy/install initrd script"

	emake install-man DESTDIR="${D}" || die "failed to install manpages"

	cd ../
	dodoc AUTHORS ChangeLog README || die "failed to install docs"

	if use examples; then
		insinto /usr/share/doc/${PF}/examples/etc/
		doins -r etc/uanytun || die "failed to install examples"
	fi
}

pkg_config() {
	[ -e "${ROOT}"/etc/uanytun ] && die "${ROOT}/etc/uanytun/ already present, rm -R it first"
	[ ! -d "${ROOT}"/usr/share/doc/${PF}/examples/etc/uanytun/ ] && \
		die "can't copy example configs since examples were not installed (reemerge with USE=\"examples\")"
	cp -vr "${ROOT}"/usr/share/doc/${PF}/examples/etc/uanytun "${ROOT}"/etc/ || die "failed to copy examples"
}

pkg_postinst() {
	enewgroup uanytun
	enewuser uanytun -1 -1 /var/run/ uanytun
	einfo "Note that each VPN gets its own directory under /etc/uanytun/"
	einfo " (see examples provided with the package)"
	einfo "Use the following example to create gentoo-style"
	einfo " uanytun.{VPN} initrd scripts for each VPN"
	einfo "# ln -s /etc/init.d/uanytun /etc/init.d/uanytun.client1"
}
