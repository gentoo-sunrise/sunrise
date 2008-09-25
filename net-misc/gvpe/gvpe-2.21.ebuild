# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header$
EAPI="1"

inherit eutils linux-info

DESCRIPTION="GNU Virtual Private Ethernet"
HOMEPAGE="http://savannah.gnu.org/projects/gvpe"
SRC_URI="http://ftp.gnu.org/gnu/gvpe/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"

IUSE="nls tcp +compression dns icmp http-proxy
	cipher-aes-128 cipher-aes-192 +cipher-aes-256 cipher-blowfish
	digset-sha512 digset-sha256 digset-sha1 +digset-ripemd160 digset-md5 digset-md4-insecure"


DEPEND="dev-libs/libev
	>=dev-libs/openssl-0.9.7c
	nls? ( sys-devel/gettext )
	virtual/linux-sources"

RDEPEND=">=dev-libs/openssl-0.9.7c"

src_compile() {
	#Since gvpe does not support more than 1 cipher and more then 1 digset
	#here we do some not so clever checks to ensure that only one is selected
	local myEnc
	local encCnt=0
	use cipher-aes-256 && myEnc="aes-256" && encCnt=$((encCnt+1))
	use cipher-aes-192 && myEnc="aes-192" && encCnt=$((encCnt+1))
	use cipher-aes-128 && myEnc="aes-128" && encCnt=$((encCnt+1))
	use cipher-blowfish && myEnc="bf" && encCnt=$((encCnt+1))

	if [[ $encCnt<1 ]]; then
	    eerror "An encryption alogotithm have to be selected.\nAdd one of cipher-aes-256, cipher-aes-192, cipher-aes-128 or cipher-blowfish to your USE variable."
	    die;
	elif [[ $encCnt>1 ]]; then
	    eerror "More then one ecryption alogorithm selected.\nRemove all but one of cipher-aes-256, cipher-aes-192, cipher-aes-128 or cipher-blowfish flags from your USE variable."
	    die;
	fi

	encCnt=0
	local myDigset
	use digset-sha512 && myDigset="sha512" && encCnt=$((encCnt+1))
	use digset-sha256 && myDigset="sha256" && encCnt=$((encCnt+1))
	use digset-sha1 && myDigset="sha1" && encCnt=$((encCnt+1))
	use digset-ripemd160 && myDigset="ripemd160" && encCnt=$((encCnt+1))
	use digset-md5 && myDigset="md5" && encCnt=$((encCnt+1))
	use digset-md4-insecure && myDigset="md4" && encCnt=$((encCnt+1))
	if [[ $encCnt<1 ]]; then
	    eerror "A digset algorithm have to be selected.\nAdd one of digset-sha512, digset-sha256, digset-sha1, digset-ripemd160, digset-md5 or digset-md4-insecure to your USE variable."
	    die;
	elif [[ $encCnt>1 ]]; then
	    eerror "More then one digset alogorithm selected.\nRemove all but one of digset-sha512, digset-sha256, digset-sha1, digset-ripemd160, digset-md5 or digset-md4-insecure flags from your USE variable."
	    die;
	fi



	#add proper support for --disable in the configure scrip
	epatch "${FILESDIR}/configure.${P}.patch"

	#the hmac and rand flags are hardcoded this is not so good because
	#it leaves the system more predictable. But I don't think that adding
	#24 more use flags is a good idea too.
	econf $(use_enable nls) \
		$(use_enable compression) \
		$(use_enable dns) \
		$(use_enable icmp) \
		$(use_enable http-proxy) \
		$(use_enable tcp) \
	    --enable-hmac-length=16 --enable-rand-length=8 --enable-cipher=$myEnc \
	    --enable-digest=$myDigset
	emake || die
}

src_install() {
	emake DESTDIR="${D}" install || die
	dodir /etc/gvpe
	dodoc AUTHORS NEWS README TODO || die
	newinitd "${FILESDIR}/gvpe.rc" gvpe || die
	newconfd "${FILESDIR}/gvpe.confd" gvpe || die
	insinto /etc/gvpe
	doins "${FILESDIR}/gvpe.conf.example" || die
	exeinto /etc/gvpe
	doexe "${FILESDIR}/if-up" || die
}

pkg_postinst() {
	linux_chkconfig_present TUN || ewarn "This package requires the tun/tap kernel device."
	einfo "Edit /etc/conf.d/gvpe and /etc/gvpe/gvpe.conf"
	ewarn "All nodes in your VPN have to use the same combination of digset and cipher!"
}
