# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=3

PYTHON_DEPEND="2"

inherit multilib python bash-completion

DESCRIPTION="Framework which enables integration with the Security Content Automation Protocol (SCAP)"
HOMEPAGE="http://www.open-scap.org/"
SRC_URI="http://www.open-scap.org/download/${P}.tar.gz"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="bash-completion doc nss perl python"

RDEPEND="!nss? ( dev-libs/libgcrypt )
	nss? ( dev-libs/nss )
	dev-libs/libpcre
	dev-libs/libxml2
	net-misc/curl"
DEPEND="${RDEPEND}
	perl? ( dev-lang/swig )
	python? ( dev-lang/swig )"

pkg_setup() {
	python_set_active_version 2
	python_pkg_setup
}

src_configure() {
	local myconf
	if use python || use perl ; then
		myconf+=" --enable-bindings"
	else
		myconf+=" --disable-bindings"
	fi
	if use nss ; then
		myconf+=" --with-crypto=nss3"
	else
		myconf+=" --with-crypto=gcrypt"
	fi
	econf ${myconf}
}

src_install() {
	emake install DESTDIR="${D}" || die
	#--enable-bindings enable all bindings, clean unwanted bindings
	if use python && ! use perl ; then
		rm -rf "${D}"/usr/$(get_libdir)/perl5 || die
	fi
	if ! use python && use perl ; then
		rm -rf "${D}"/$(python_get_sitedir) || die
	fi
	if use doc ; then
		dohtml -r docs/html/* || die
		dodoc docs/examples/* || die
	fi
	if ! use bash-completion ; then
		rm -rf "${D}"/etc/bash_completion.d || die
	fi
}
