# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="5"

PYTHON_COMPAT=( python2_6 python2_7 )
inherit eutils gnome2 python-single-r1

DESCRIPTION="A graphical tool for changing the Bashs behaviour"
HOMEPAGE="http://www.nanolx.org/"
SRC_URI="http://download.tuxfamily.org/bashstyleng/${P}.tar.bz2"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="acpi dmi doc pci pdf usb"

DEPEND="${PYTHON_DEPS}
	app-shells/bash
	dev-libs/newt
	dev-python/gconf-python:2
	dev-python/pygtk[${PYTHON_USEDEP}]
	sys-devel/gettext
	x11-libs/vte[python]
	x11-misc/xdg-utils
	acpi? ( sys-power/acpi )
	dmi? ( sys-apps/dmidecode )
	pci? ( sys-apps/pciutils )
	pdf? ( app-text/ghostscript-gpl )
	usb? ( sys-apps/usbutils )"
RDEPEND="${DEPEND}"

DOCS="AUTHORS ChangeLog README TODO"

src_prepare() {
	gnome2_src_prepare

	# remove hardcoded python
	sed -i \
		-e "s#^python#${EPYTHON}#" \
		data/bashstyle.in || die "fixing python impl failed!"

	# use xdg-open
	sed -i \
		-e 's/x-www-browser/xdg-open/' \
		ui/bs-ng.py || die "fixing help button failed!"
}

src_configure() {
	gnome2_src_configure

	# fix schema install destination
	sed -i \
		-e 's#GCONFDIR=.*$#GCONFDIR="/etc/gconf/schemas"#' \
		./.configure/results || die "fixing schema install dest failed!"
}

src_install() {
	if use doc; then
		dohtml documentation/*
	fi

	gnome2_src_install DISABLE_POSTINSTALL=1

	python_fix_shebang "${D}"/usr/bin/text2morse \
		"${D}"/usr/share/bashstyle-ng/ui/{bs-ng,undobuffer}.py
}
