# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit eutils

DESCRIPTION="a video/audio/data interactive streaming server"
HOMEPAGE="http://www.fastpath.it/products/palantir/index.php"
SRC_URI="http://www.fastpath.it/products/${PN}/pub/${P}.tgz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86"
IUSE=""

DEPEND="media-libs/jpeg"
RDEPEND="${DEPEND}"

S="${S}/server"

PALANTIR_USER="palantir"
PALANTIR_PIPE_PATH="/var/run/palantir/telmu_pipe"

src_unpack() {
	unpack ${A}
	epatch "${FILESDIR}/${PV}-makefile.patch"
	sed -i -e "s#/usr/local/share/palantir/telmu_pipe#${PALANTIR_PIPE_PATH}#" "${S}/tools/set_sensor"
}

pkg_setup() {
	enewuser ${PALANTIR_USER}
}

src_compile() {
	export NAMED_PIPE="${PALANTIR_PIPE_PATH}"
	emake || die "emake failed"
}

src_install() {
	dobin palantir
	newbin tools/sysfeed palantir_sysfeed
	newbin tools/set_sensor palantir_set_sensor

	insinto /usr/share/${PN}
	doins -r pict

	insinto /etc/palantir
	doins "${FILESDIR}/palantir.conf.sample"

	dodir /var/log
	touch "${D}/var/log/palantir.log"

	dodir /var/run/palantir
	mkfifo "${D}${NAMED_PIPE}"
	fperms 0600 "${NAMED_PIPE}"
	fowners ${PALANTIR_USER} "${NAMED_PIPE}" /var/log/palantir.log

	newinitd "${FILESDIR}/palantir.init" palantir

	dodoc doc/* README TODO
	doman man/palantir.1 man/palantir.conf.5
	dohtml man/html/*
}
