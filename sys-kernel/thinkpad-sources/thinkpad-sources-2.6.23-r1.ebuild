# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: sys-kernel/thinkpad-sources/thinkpad-sources-2.6.23-r1.ebuild 2007 11 08

ETYPE="sources"
K_WANT_GENPATCHES="base extras"
K_GENPATCHES_VER="2"
K_SECURITY_UNSUPPORTED="1"

inherit kernel-2
detect_version
detect_arch

DESCRIPTION="Software Suspend 2 + Gentoo patchset sources + SCO Flowcontrol + Latest THINKPAD-Acpi"
HOMEPAGE="http://dev.gentoo.org/~dsd/genpatches http://www.tuxonice.net http://bluetooth-alsa.sourceforge.net/ http://ibm-acpi.sourceforge.net/"

IUSE="sco_flowcontrol"

HRT_VERSION="3"
HRT_TARGET="2.6.23"
HRT_SRC="patch-${HRT_TARGET}-hrt${HRT_VERSION}"
HRT_URI="http://www.kernel.org/pub/linux/kernel/people/tglx/hrtimers/2.6.23/${HRT_SRC}.patch.bz2"

TUXONICE_VERSION="3.0-rc2"
TUXONICE_TARGET="2.6.23.1"
TUXONICE_SRC="tuxonice-${TUXONICE_VERSION}-for-${TUXONICE_TARGET}"
TUXONICE_URI="http://www.tuxonice.net/downloads/all/${TUXONICE_SRC}.patch.bz2"

SCO_FLOWCONTROL_VERSION="4.3"
SCO_FLOWCONTROL_SRC="sco-flowcontrol-v${SCO_FLOWCONTROL_VERSION}"
SCO_FLOWCONTROL_URI="http://bluetooth-alsa.cvs.sourceforge.net/*checkout*/bluetooth-alsa/plugz/patches/${SCO_FLOWCONTROL_SRC}.diff"

THINKPAD_ACPI_VERSION="0.18-20071013"
THINKPAD_ACPI_TARGET="2.6.23.1"
THINKPAD_ACPI_SRC="thinkpad-acpi-${THINKPAD_ACPI_VERSION}_v${THINKPAD_ACPI_TARGET}.patch.gz"
THINKPAD_ACPI_URI="mirror://sourceforge/ibm-acpi/${THINKPAD_ACPI_SRC}"



#IEEE80211_VERSION="1.2.17"
#IEEE80211_TARGET="2.6.20"
#IEEE80211_SRC="05-ieee80211-${IEEE80211_VERSION}-for-${IEEE80211_TARGET}.patch"
#IEEE80211_URI="http://whoopie.gmxhome.de/linux/patches/2.6.20/${IEEE80211_SRC}"

UNIPATCH_LIST=""

if use sco_flowcontrol; then
                UNIPATCH_LIST="${UNIPATCH_LIST} ${DISTDIR}/${SCO_FLOWCONTROL_SRC}.diff"
fi
UNIPATCH_LIST="${UNIPATCH_LIST}
	${FILESDIR}/2.6.23/disk-protect-for-2.6.23.patch
	${DISTDIR}/${THINKPAD_ACPI_SRC}
	${DISTDIR}/${IEEE80211_SRC}
	${FILESDIR}/2.6.23/input-unknown_keycodes-for-2.6.23.patch
	${FILESDIR}/2.6.23/linux-phc-0.3.1-for-2.6.23.patch
	${DISTDIR}/${TUXONICE_SRC}.patch.bz2
	${FILESDIR}/2.6.23/combined-2.6.23-cph.patch
	${DISTDIR}/${HRT_SRC}.patch.bz2"


UNIPATCH_STRICTORDER="yes"
SRC_URI="${KERNEL_URI} ${GENPATCHES_URI} ${ARCH_URI} ${TUXONICE_URI} ${THINKPAD_ACPI_URI} sco_flowcontrol? ( ${SCO_FLOWCONTROL_URI} ) ${IEEE80211_URI} ${HRT_URI}"

KEYWORDS="~amd64 ~x86"

RDEPEND="${RDEPEND}
		>=sys-apps/tuxonice-userui-0.7.2
		>=sys-power/hibernate-script-1.97"

#K_EXTRAEINFO="If there are issues with this kernel, please direct any
#queries to the linux-thinkpad mailing list:"

pkg_postinst() {
	kernel-2_pkg_postinst
	einfo "For more info on this patchset, and how to report problems, see:"
	einfo "${HOMEPAGE}"
	einfo "In files dir is an example config suitable for T60"
	einfo "and hopefully all pci-express driven Thinkpads"
	einfo "but at all you should try for all Thinkpads"
	einfo "to NOT alter the given storage device controller configuration"
}
