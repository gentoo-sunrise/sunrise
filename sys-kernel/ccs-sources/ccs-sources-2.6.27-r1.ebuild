# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

ETYPE="sources"
K_WANT_GENPATCHES="base extras"
K_GENPATCHES_VER="12"

inherit eutils kernel-2
detect_version
detect_arch

CCS_TGP="ccs-patch-1.6.8-20090528"
CCS_TGP_SRC="mirror://sourceforge.jp/tomoyo/30297/${CCS_TGP}.tar.gz"

DESCRIPTION="TOMOYO Linux sources for the ${KV_MAJOR}.${KV_MINOR} kernel tree"
HOMEPAGE="http://tomoyo.sourceforge.jp/index.html.en"
SRC_URI="${KERNEL_URI} ${GENPATCHES_URI} ${ARCH_URI} ${CCS_TGP_SRC}"
KEYWORDS="~amd64 ~x86"
DEPEND=""
RDEPEND="sys-apps/ccs-tools"

K_EXTRAEINFO="Before booting with TOMOYO enabled kernel, you need to
run this command to initialize TOMOYO policies:
# /usr/lib/ccs/init_policy.sh"

src_unpack() {
	kernel-2_src_unpack

	cd "${WORKDIR}"
	unpack "${CCS_TGP}.tar.gz"
	cp -dpR fs include "${S}" || die

	if [ -f "${FILESDIR}/${PF}.patch" ]; then
		cd "${WORKDIR}/patches/"
		epatch "${FILESDIR}/${PF}.patch"
	fi

	cd "${S}"
	epatch "${WORKDIR}/patches/ccs-patch-${PV}.diff"
}
