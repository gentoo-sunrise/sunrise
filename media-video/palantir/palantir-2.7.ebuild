# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=2
inherit eutils toolchain-funcs

DESCRIPTION="A video/audio/data interactive streaming server"
HOMEPAGE="http://www.fastpath.it/products/palantir/index.php"
SRC_URI="http://www.fastpath.it/products/${PN}/pub/${P}.tgz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86"
IUSE=""

RDEPEND="media-libs/jpeg
	media-sound/gsm"
DEPEND="${RDEPEND}"

S=${S}/server

pkg_setup() {
	PALANTIR_USER="palantir"
	PALANTIR_PIPE_PATH="/var/run/palantir/telmu_pipe"

	enewuser ${PALANTIR_USER}
}

src_prepare() {
	# this one isn't mangled by Makefile
	sed -i -e "s#/usr/local/share/palantir/telmu_pipe#${PALANTIR_PIPE_PATH}#" \
		tools/set_sensor || die
	# install the config file in correct location
	sed -i -e 's:$(SYS_DIR)/palantir.conf:$(CONFIG_FILE).sample:' Makefile || die
	# tools/ like LDFLAGS too
	sed -i -e 's:-o:$(LDFLAGS) -o:' tools/Makefile || die
	# set the paths in sample configfile
	sed -i \
		-e "s:^# \(NamedPipe \).*:\1${PALANTIR_PIPE_PATH}:" \
		-e "s:^# \(LogFile .*\):\1.log:" \
		${PN}.conf.sample || die
	# use system-wide libgsm headers
	sed -i -e 's:\(#include \)"libgsm/inc/gsm.h":\1<gsm/gsm.h>:' audio.h || die
}

src_compile() {
	# libgsm=-lgsm to avoid bundling it
	emake CC="$(tc-getCC)" CFLAGS="${CFLAGS}" \
		libgsm=-lgsm \
		BASE_DIR=/usr \
		CONFIG_FILE=/etc/${PN}/${PN}.conf \
		NAMED_PIPE=${PALANTIR_PIPE_PATH} \
		|| die
}

src_install() {
	# we're mangling a lot here, so we need to create the dirs ourselves
	dodir ${PALANTIR_PIPE_PATH%/*} /etc/${PN} /var/log || die
	# XXX: make keeps relinking palantir
	emake install CC="$(tc-getCC)" CFLAGS="${CFLAGS}" \
		libgsm=-lgsm \
		BASE_DIR="${D}"usr \
		CONFIG_FILE="${D}"etc/${PN}/${PN}.conf \
		NAMED_PIPE="${D}"${PALANTIR_PIPE_PATH#/} \
		LOG_FILE="${D}"var/log/${PN}.log \
		OWNER=${PALANTIR_USER} \
		|| die

	newbin tools/set_sensor palantir_set_sensor || die
	dodoc doc/* README TODO || die
	newinitd "${FILESDIR}"/${PN}.init ${PN} || die
}
