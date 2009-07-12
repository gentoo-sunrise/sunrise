# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="2"

inherit eutils toolchain-funcs

DESCRIPTION="Utility to control and program CM11A, CM17A and CM12U X10 interfaces"
HOMEPAGE="http://heyu.tanj.com"
SRC_URI="http://heyu.tanj.com/download/${P}.tgz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86"
IUSE="kernel_Darwin kernel_FreeBSD kernel_linux cm17a dmx210 ext0 ore rfxm rfxs"

pkg_setup() {
	enewgroup ${PN}
	enewuser ${PN} -1 -1 /var/lib/${PN} "${PN},uucp"
	ewarn "Heyu must not be running when updating to a higher version as"
	ewarn "stray lockfiles may prevent it from restarting - in which case"
	ewarn "you should refer to the cleanup section of the Heyu man page."
	epause
}

src_configure() {
	mv x10config.sample x10.conf.sample
	"${S}"/Configure \
		$(use kernel_FreeBSD && echo "freebsd")	\
		$(use kernel_Darwin && echo "darwin")	\
		$(use kernel_linux && echo "linux")	\
		$(use cm17a || echo "-nocm17a")		\
		$(use dmx210 || echo "-nodmx")		\
		$(use ext0 || echo "-noext0")		\
		$(use ore || echo "-noore")		\
		$(use rfxm || echo "-norfxm")		\
		$(use rfxs || echo "-norfxs")		\
		|| die "configure failed"
	sed -i -r -e "s/CC\s*=.*/CC = $(tc-getCC)/" \
	-e "s/CFLAGS\s*=.*/CFLAGS = ${CFLAGS} \$(DFLAGS)/" \
	-e 's%^(DFLAGS.+)-DSYSBASEDIR=\\"[^\]+\\"%\1%' \
	-e 's%^(DFLAGS\s*=\s*)%\1-DSYSBASEDIR=\\"/var/lib/heyu\\" %' \
	-e 's%^(DFLAGS.+)-DSPOOLDIR=\\"[^\]+\\"%\1%' \
	-e 's%^(DFLAGS\s*=\s*)%\1-DSPOOLDIR=\\"/var/lib/heyu\\" %' \
	-e 's%^(DFLAGS.+)-DLOCKDIR=\\"[^\]+\\"%\1%' \
	-e 's%^(DFLAGS\s*=\s*)%\1-DLOCKDIR=\\"/var/lock\\" %' "${S}"/Makefile || die "adjusting Makefile failed"
	sed -i -r 's%(LOG_DIR.*?)NONE%\1/var/log/heyu%' "${S}"/x10.conf.sample || die "changing LOG_DIR failed"
}

src_install() {
	dobin heyu || die "installing binary failed"
	doman heyu.1 x10{config,scripts,sched}.5 || die "installing man pages failed"
	newinitd "${FILESDIR}"/heyu.init heyu
	insinto /etc/heyu
	doins x10.*.sample || die "installing config samples failed"
	diropts -m 0750 -o heyu
	dodir /var/log/heyu  || die "creating log directory failed"
	dosym /etc/heyu/x10.conf /var/lib/heyu/x10.conf || die "dosym failed"
	dosym /etc/heyu/x10.sched /var/lib/heyu/x10.sched || die "dosym failed"
}

pkg_postinst() {
	elog "Don't forget to tell heyu where to find your CM11 or CM17. Therefore"
	elog "the file /etc/heyu/x10.conf must contain a line starting with 'TTY'"
	elog "followed by the corresponding device such as:"
	elog
	elog "TTY /dev/ttyS0     <-- on first serial port"
	elog "TTY /dev/ttyS1     <-- on second serial port"
	elog "TTY /dev/ttyUSB0   <-- on USB port"
	elog
	elog "To use your device on a USB port, the corresponding USB serial converter"
	elog "kernel module must be loaded. Older CM11 are usually delivered with a"
	elog "a Prolific 2303 cable (kernel module: pl2303) while newer come with a"
	elog "FTDI cable (kernel module: ftdi_sio)."
	elog
	elog "Execute the following command if you wish to start the HEYU daemon"
	elog "at boot time:"
	elog
	elog "rc-update add heyu default"
}
