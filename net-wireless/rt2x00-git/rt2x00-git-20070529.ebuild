# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit linux-mod

MY_PN="rt2x00-git"

DESCRIPTION="Ralink drivers for rt2400, rt2500, rt61 and rt73 chips (experimental git branch)"
HOMEPAGE="http://rt2x00.serialmonkey.com/"
SRC_URI="http://dev.gentooexperimental.org/~jakub/distfiles/${MY_PN}-${PV}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86"
IUSE=""

RT2X00_DEVICES="rt2400pci rt2500pci rt2500usb rt61pci rt73usb"
for x in ${RT2X00_DEVICES} ; do
	IUSE="${IUSE} ${x}"
done

DEPEND="net-wireless/mac80211
	!net-wireless/rt2x00"
RDEPEND="${DEPEND}
	rt2400pci? ( net-wireless/eeprom_93cx6 )
	rt2500pci? ( net-wireless/eeprom_93cx6 )
	rt61pci? ( net-wireless/eeprom_93cx6 net-wireless/crc-itu-t )
	rt73usb? ( net-wireless/crc-itu-t )"

S="${WORKDIR}/drivers/net/wireless/mac80211/rt2x00/"

src_unpack() {
	unpack ${A}
	if use rt61pci || use rt73usb ; then
		echo "CFLAGS += -I/usr/include/mac80211 -I/usr/include/crc-itu-t" \
			"-I/usr/include/eeprom_93cx6 -D CONFIG_RT2X00_LIB_FIRMWARE" >> "${S}"/Makefile
	else
		echo "CFLAGS += -I/usr/include/mac80211 -I/usr/include/crc-itu-t" \
			"-I/usr/include/eeprom_93cx6" >> "${S}"/Makefile
	fi
}

pkg_setup() {
	# check whether any drivers are set in USE
	local selected="n"
	for i in ${RT2X00_DEVICES} ; do
		if use ${i} ; then
			selected="y"
			break
		fi
	done
	if [[ ${selected} == "n" ]] ; then
		eerror "You didn't choose any rt2x00 driver to build!"
		die "Add one or more of ${RT2X00_DEVICES} to your USE flags and try again."
	fi

	CONFIG_CHECK="WIRELESS_EXT"
	ERROR_WIRELESS_EXT="${P} requires support for Wireless LAN drivers (non-hamradio) & Wireless Extensions (CONFIG_NET_RADIO)."

	MODULE_NAMES="rt2x00lib(net/wireless/mac80211/rt2x00/)"
	BUILD_PARAMS="CONFIG_RT2X00=m CONFIG_RT2X00_LIB=m"

	for i in ${RT2X00_DEVICES} ; do
		use ${i} && MODULE_NAMES="${MODULE_NAMES} ${i}(net/wireless/mac80211/rt2x00/)"
		use ${i} && BUILD_PARAMS="${BUILD_PARAMS} CONFIG_$(echo -n ${i} | tr '[:lower:]' '[:upper:]')=m"
	done

	if use rt2400pci || use rt2500pci || use rt61pci ; then
		MODULE_NAMES="${MODULE_NAMES} rt2x00pci(net/wireless/mac80211/rt2x00/)"
		BUILD_PARAMS="${BUILD_PARAMS} CONFIG_RT2X00_LIB_PCI=m"
		CONFIG_CHECK="${CONFIG_CHECK} PCI"
	fi

	if use rt2500usb || use rt73usb ; then
		MODULE_NAMES="${MODULE_NAMES} rt2x00usb(net/wireless/mac80211/rt2x00/)"
		BUILD_PARAMS="${BUILD_PARAMS} CONFIG_RT2X00_LIB_USB=m"
		CONFIG_CHECK="${CONFIG_CHECK} USB"
	fi

	if use rt61pci || use rt73usb ; then
		BUILD_PARAMS="${BUILD_PARAMS} CONFIG_RT2X00_LIB_FIRMWARE=m"
		CONFIG_CHECK="${CONFIG_CHECK} FW_LOADER"
		ERROR_FW_LOADER="${P} requires support for Firmware module loading (CONFIG_FW_LOADER)."
	fi

	linux-mod_pkg_setup
	BUILD_TARGETS="modules"
	BUILD_PARAMS="${BUILD_PARAMS} -C ${KV_DIR} M=${S} V=1"
}
