# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="3"

PHP_EXT_OPTIONAL_USE="php"
PHP_EXT_NAME="librets"
PHP_EXT_SKIP_PHPIZE="yes"
USE_PHP="php5-2 php5-3"

PYTHON_DEPEND="python? 2"
PYTHON_MODNAME="librets.py"

LIBOPTIONS="-m755"

inherit distutils eutils java-pkg-opt-2 perl-module php-ext-source-r2

DESCRIPTION="A library that implements the RETS 1.7, RETS 1.5 and 1.0 standards"
HOMEPAGE="http://www.crt.realtors.org/projects/rets/librets/"
SRC_URI="http://www.crt.realtors.org/projects/rets/${PN}/files/${P}.tar.gz"

LICENSE="BSD-NAR"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="debug doc java perl php python ruby sql-compiler threads"

for i in java perl php python ruby; do
	SWIG_DEPEND+=" ${i}? ( dev-lang/swig )"
	SWIG_RDEPEND+=" ${i}? (
		dev-libs/libgcrypt
		dev-libs/libgpg-error
		dev-libs/libtasn1
		net-dns/libidn
		net-libs/gnutls
	)"
done

# Assuming this the proper way to depend on ruby interpreter when ruby is optional
RDEPEND="
	dev-libs/boost
	dev-libs/expat
	dev-util/boost-build
	java? ( >=virtual/jdk-1.6.0 )
	net-misc/curl
	ruby? ( dev-lang/ruby:1.8 )
	sql-compiler? ( dev-java/antlr:0[script] )
	sys-libs/zlib
	${SWIG_RDEPEND}"

DEPEND="${RDEPEND} ${SWIG_DEPEND}"

unset SWIG_DEPEND
unset SWIG_RDEPEND
unset i

_php-move_swig_build_to_modules_dir() {
	mkdir "${1}"/modules || die "Could not create directory for php slot"
	mv build/swig/php5/* "${1}"/modules || die "Could not move php slot build"
}

pkg_setup() {
	use java && java-pkg-opt-2_pkg_setup
	use perl && perl-module_pkg_setup
	if use python; then
		python_set_active_version 2
		python_pkg_setup
	fi
}

src_prepare() {
	use php && php-ext-source-r2_src_prepare
	#Patch upstream patch to allow perl to be built in the compile stage
	use perl && epatch "${FILESDIR}"/perl.mk.patch
	#Patch to fix java errors and allow compilation
	use java && epatch "${FILESDIR}"/java.mk.patch
	#Patch to stop python from building the extension again during install
	use python && epatch "${FILESDIR}"/python.mk.patch
}

src_configure() {
	local myconf
	local myphpprefix

	use java || myconf="--disable-java"
	use perl || myconf="${myconf} --disable-perl"
	if use php; then
		# Enable php extension when it finds the current selected slot
		myphpprefix="${PHPPREFIX}/include"
	else
		myconf="${myconf} --disable-php"
	fi
	use python || myconf="${myconf} --disable-python"
	use ruby || myconf="${myconf} --disable-ruby"

	if use doc; then
		myconf="${myconf} --enable-maintainer-documentation"
	fi

	econf \
		--enable-shared_dependencies \
		--enable-depends \
		--enable-default-search-path="/usr /opt ${myphpprefix}" \
		--disable-examples \
		$(use_enable debug) \
		$(use_enable sql-compiler) \
		$(use_enable threads thread-safe) \
		${myconf} || die
}

src_compile() {
	emake || die "emake failed"
	if use php; then
		local slot myphpconfig="php-config" myphpselectedslot="php${PHP_CURRENTSLOT}"
		#Move the current slotted build of php to another dir so other slots can be built
		_php-move_swig_build_to_modules_dir "${WORKDIR}/${myphpselectedslot}"
		for slot in $(php_get_slots); do
			# Don't build the selected slot since the build system already built it
			[[ "${slot}" != "${myphpselectedslot}" ]] || continue;
			php_init_slot_env ${slot}
			cd "${S}" || die "cannot change to source directory"
			# Replace the reference to php-config with the current slotted one
			sed -i -e "s|${myphpconfig}|${PHPCONFIG}|g" project/build/php.mk || die "sed php-config change failed"
			myphpconfig="${PHPCONFIG}"
			# Build the current slotted
			emake build/swig/php5/${PN}.so || die "Unable to make php${slot} extension"
			_php-move_swig_build_to_modules_dir ${PHP_EXT_S}
		done
	fi
}

src_install() {
	dolib.a build/${PN}/lib/${PN}.a || die

	insinto /usr/include
	doins -r project/${PN}/include/${PN} || die

	dobin "${PN}-config" || die

	if use php; then
		php-ext-source-r2_src_install
		insinto /usr/share/php
		doins "${WORKDIR}"/php"${PHP_CURRENTSLOT}"/modules/${PN}.php || die
	fi

	if use perl; then
		#Install manually since the package install has sandbox violations
		insinto ${SITE_ARCH}
		insopts "-m755"
		doins -r "${S}"/build/swig/perl/blib/arch/auto || die
		insopts "-m644"
		doins "${S}"/build/swig/perl/${PN}.pm || die
	fi

	if use java; then
		java-pkg_dojar "${S}"/build/swig/java/${PN}.jar || die
		java-pkg_doso "${S}"/build/swig/java/${PN}.so  || die
	fi

	if use ruby; then
		insinto /usr/lib64/ruby/site_ruby/1.8/x86_64-linux
		doexe "${S}"/build/swig/ruby/librets_native.so || die
		insinto /usr/lib64/ruby/site_ruby/1.8
		doins "${S}"/build/swig/ruby/librets.rb || die
	fi

	if use python; then
		cd "${S}"/build/swig/python || die
		distutils_src_install
	fi
}

pkg_preinst() {
	use perl && perl-module_pkg_preinst
}

pkg_postinst() {
	use python && distutils_pkg_postinst
	use perl && perl-module_pkg_postinst
}

pkg_prerm() {
	use perl && perl-module_pkg_prerm
}

pkg_postrm() {
	use python && distutils_pkg_postrm
	use perl && perl-module_pkg_postrm
}
