# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=4

PYTHON_DEPEND="python? *"
SUPPORT_PYTHON_ABIS="1"
GENTOO_DEPEND_ON_PERL="no"

inherit autotools eutils perl-module python versionator

DESCRIPTION="Library to support AppArmor userspace utilities"
HOMEPAGE="http://apparmor.net/"
SRC_URI="http://launchpad.net/apparmor/$(get_version_component_range 1-2)/${PV}/+download/apparmor-${PV}.tar.gz"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="~amd64"
IUSE="doc perl python"

RDEPEND="perl? ( dev-lang/perl )"

DEPEND="${RDEPEND}
	sys-devel/autoconf-archive
	sys-devel/bison
	sys-devel/flex
	doc? ( dev-lang/perl )
	perl? ( dev-lang/swig )
	python? ( dev-lang/swig )"

S=${WORKDIR}/apparmor-${PV}/libraries/${PN}

src_prepare() {
	epatch "${FILESDIR}"/libapparmor-2.6.1-python3.patch
	rm -rf m4 || die "failed to remove bundled macros"

	#fixes libtool version mismatch error
	eautoreconf
}

src_configure() {
	econf \
		$(use_with perl) \
		$(use_with python)
}

src_compile() {
	emake -C src

	use doc && emake -C doc
	use perl && emake -C swig/perl

	if use python; then
		python_copy_sources swig/python
		compile_bindings() {
			emake PYTHON="$(PYTHON)" PYTHON_INCLUDEDIR="$(python_get_includedir)" PYTHON_LIBDIR="$(python_get_libdir)"
		}
		python_execute_function -s --source-dir swig/python compile_bindings
	fi
}

src_install() {
	emake -C src DESTDIR="${D}" install
	use doc && emake -C doc DESTDIR="${D}" install

	if use perl; then
		emake -C swig/perl DESTDIR="${D}" install
		perlinfo
		insinto "${VENDOR_ARCH}"
		doins swig/perl/LibAppArmor.pm
	fi

	if use python; then
		install_bindings() {
			emake -C swig/python DESTDIR="${D}" install
		}
		python_execute_function -q install_bindings
	fi
}
