# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

ETYPE="sources"
K_WANT_GENPATCHES="base extras"
K_GENPATCHES_VER="6"
K_GLENDIXPATCH_VER="6"

inherit kernel-2
detect_version
detect_arch

DESCRIPTION="Glendix kernel sources (kernel series ${KV_MAJOR}.${KV_MINOR})"
HOMEPAGE="http://www.glendix.org/"

GPV="${KV_MAJOR}.${KV_MINOR}.${KV_PATCH}.${K_GLENDIXPATCH_VER}"
GLENDIXPATCH_URI="http://glendix.org/code/glendix_${GPV}.patch"
SRC_URI="${KERNEL_URI} ${GLENDIXPATCH_URI} ${GENPATCHES_URI} ${ARCH_URI}"

UNIPATCH_LIST="${DISTDIR}/glendix_${GPV}.patch"

KEYWORDS="~amd64 ~x86"
IUSE=""

pkg_postinst() {
	kernel-2_pkg_postinst

	einfo "For more info on this patchset, and how to report problems, see:"
	einfo "${HOMEPAGE}"
}
