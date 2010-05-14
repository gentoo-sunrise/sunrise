# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=2

SUPPORT_PYTHON_ABIS="1"
RESTRICT_PYTHON_ABIS="3.*"
PYTHON_DEPEND="python? 2:2.5"

inherit mono python autotools eutils multilib

DESCRIPTION="Ubuntu One GTK integration widgets"
HOMEPAGE="https://launchpad.net/libubuntuone"
SRC_URI="http://launchpad.net/${PN}/trunk/${PV}/+download/${P}.tar.gz"

LICENSE="LGPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="doc mono python"

RDEPEND="mono? (
		dev-dotnet/gtk-sharp:2
		dev-dotnet/gtk-sharp-gapi:2
		dev-lang/mono
	)
	dev-libs/dbus-glib
	dev-libs/glib:2
	dev-libs/libxml2
	dev-libs/openssl
	python? (
		dev-python/pygobject
		dev-python/pygtk:2
	)
	gnome-base/gconf:2
	gnome-base/gnome-keyring
	gnome-extra/evolution-data-server
	net-libs/libsoup-gnome:2.4
	net-libs/webkit-gtk"

DEPEND="doc? (
		app-text/gnome-doc-utils 
		dev-util/gtk-doc 
	)
	dev-util/intltool 
	${RDEPEND}" 

src_prepare(){
	epatch "${FILESDIR}"/libubuntuone-optional-bindings.patch
	eautoreconf
	python_copy_sources
}

src_configure(){
	do_src_configure()
	{
		econf \
		$(use_enable doc gtk-doc) \
		$(use_enable mono mono-binding) \
		$(use_enable python python-binding)
	}
	python_execute_function -s do_src_configure
}

src_compile() {
	do_src_compile() {
		emake || die "emake failed"
	}
	python_execute_function -s do_src_compile
}

src_install() {
	do_src_install() {
		emake DESTDIR="${D}" install || die "install failed"
	}
	python_execute_function -s do_src_install
	use mono && egacinstall "${D}"/usr/$(get_libdir)/mono/ubuntuone-sharp-1.0/ubuntuone-sharp.dll
}
