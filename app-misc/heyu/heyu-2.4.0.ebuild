# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit eutils toolchain-funcs

DESCRIPTION="Utility to control and program CM11A, CM17A and CM12U X10 interfaces."
HOMEPAGE="http://heyu.tanj.com"
SRC_URI="http://heyu.tanj.com/download/${P}.tgz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86"
IUSE="kernel_Darwin kernel_FreeBSD kernel_linux cm17a dmx210 ext0 ore rfxm rfxs"

src_compile() {
	mv x10config.sample x10.conf.sample
	./Configure							\
		$(if use kernel_FreeBSD; then echo "freebsd"; fi)	\
		$(if use kernel_Darwin; then echo "darwin"; fi)		\
		$(if use kernel_linux; then echo "linux"; fi)		\
		$(if ! use cm17a; then echo "-nocm17a"; fi)		\
		$(if ! use dmx210; then echo "-nodmx"; fi)		\
		$(if ! use ext0; then echo "-noext0"; fi)		\
		$(if ! use ore; then echo "-noore"; fi)			\
		$(if ! use rfxm; then echo "-norfxm"; fi)		\
		$(if ! use rfxs; then echo "-norfxs"; fi)		\
		|| die "configure failed"
	sed -i "s/CC\s*=.*/CC = $(tc-getCC)/" "${S}"/Makefile
	sed -i "s/CFLAGS\s*=.*/CFLAGS = ${CFLAGS} \$(DFLAGS)/" "${S}"/Makefile
	emake || die "make failed"
}

src_install() {
	dobin heyu || die "installing binary failed"
	doman heyu.1 x10config.5 x10scripts.5 x10sched.5
	newinitd "${FILESDIR}"/${PVR}/heyu.init heyu
	diropts -o nobody -g nogroup -m 0777
	dodir /var/tmp/heyu
	diropts -o root -g root -m 0744
	dodir /etc/heyu
	keepdir /etc/heyu
	insinto /etc/heyu
	insopts -o root -g root -m 0644
	doins x10.conf.sample || die "installing config sample failed"
	doins x10.sched.sample || die "installing schedule sample failed"
}

pkg_postinst() {
	elog
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
	elog
	epause 5
}
