# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="2"

inherit autotools

MY_PN="Vuurmuur"
MY_PV=${PV/_beta/beta}
MY_P="${MY_PN}-${MY_PV}"

DESCRIPTION="Frontend for iptables featuring easy to use command line utils, rule- and logdaemons"
HOMEPAGE="http://www.vuurmuur.org"
SRC_URI="ftp://ftp.vuurmuur.org/releases/${MY_PV}/${MY_P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86"
IUSE="logrotate"

RDEPEND="=net-libs/libvuurmuur-${PV}
	>=sys-libs/ncurses-5
	logrotate? ( app-admin/logrotate )"

S="${WORKDIR}/${MY_P}"

src_unpack() {
	unpack ${A}
	cd "${S}"
	for component in vuurmuur vuurmuur_conf; do
		unpack "./${component}-${MY_PV}.tar.gz"
	done
}

src_prepare() {
	for component in vuurmuur vuurmuur_conf; do
		cd "${S}/${component}-${MY_PV}"
		eautoreconf
	done
}

src_configure() {
	cd "${S}/vuurmuur-${MY_PV}"
	econf \
		--with-libvuurmuur-includes=/usr/include \
		--with-libvuurmuur-libraries=/usr/lib
	
	cd "${S}/vuurmuur_conf-${MY_PV}"
	econf \
		--with-libvuurmuur-includes=/usr/include \
		--with-libvuurmuur-libraries=/usr/lib \
		--with-localedir=/usr/share/locale \
		--with-widec=yes
}

src_compile() {
	for component in vuurmuur vuurmuur_conf; do
		cd "${S}/${component}-${MY_PV}"
		emake || die "compiling ${component} failed"
	done
}

src_install() {
	cd "${S}/vuurmuur-${MY_PV}"
	emake DESTDIR="${D}" install || die "installing vuurmuur failed"

	newinitd "${FILESDIR}"/vuurmuur.init vuurmuur || die "installing init failed"
	newconfd "${FILESDIR}"/vuurmuur.conf vuurmuur || die "installing conf failed"
	
	insopts -m0600
	insinto /etc/vuurmuur
	newins config/config.conf.sample config.conf || die "installing config.conf failed"
	insopts -m0644

	if use logrotate; then
		insinto /etc/logrotate.d
		newins scripts/vuurmuur-logrotate vuurmuur || die "installing logrotate config failed"
	fi

	cd "${S}/vuurmuur_conf-${MY_PV}"
	emake DESTDIR="${D}" install || die "installing vuurmuur_conf failed"
	
	# needed until the wizard scripts are copied by make
	insopts -m0755
	insinto /usr/share/scripts
	doins scripts/*.sh || die "installing vuurmuur scripts failed"
}

pkg_postinst() {
	elog "Please read the manual on www.vuurmuur.org now - you have"
	elog "been warned!"
	elog
	elog "If this is a new install, make sure you define some rules"
	elog "BEFORE you start the daemon in order not to lock yourself"
	elog "out. The necessary steps are:"
	elog "1) vuurmuur_conf"
	elog "2) /etc/init.d/vuurmuur start"	
	elog "3) rc-update add vuurmuur default"
}
