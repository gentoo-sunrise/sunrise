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

USE_RUBY="ree18 ruby18 ruby19"
RUBY_OPTIONAL="yes"

LIBOPTIONS="-m755"

inherit distutils eutils java-pkg-opt-2 perl-module php-ext-source-r2 ruby-ng

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
	ruby? (
		ruby_targets_ree18? ( dev-lang/ruby-enterprise:1.8 )
		ruby_targets_ruby18? ( dev-lang/ruby:1.8 )
		ruby_targets_ruby19? ( dev-lang/ruby:1.9 )
	)
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

_php-replace_config_with_selected_config() {
	php_init_slot_env ${1}
	cd "${S}" || die "cannot change to source directory"
	# Replace the reference to php-config with the current slotted one
	sed -i -e "s|${2}|${PHPCONFIG}|g" project/build/php.mk || die "sed php-config change failed"
}

_ruby-get_use_implementations() {
	local i implementation
	for implementation in ${USE_RUBY}; do
		use ruby_targets_${implementation} && i+=" ${implementation}"
	done
	echo $i
}

_ruby-move_swig_build_to_impl_dir() {
	mkdir -p "${1}"/${P} || die "Could not create directory for ruby implementation"
	mv build/swig/ruby/* "${1}"/${P} || die "Could not move ruby implementation build"
}

pkg_setup() {
	use java && java-pkg-opt-2_pkg_setup
	use perl && perl-module_pkg_setup
	if use python; then
		python_set_active_version 2
		python_pkg_setup
	fi
	use ruby && ruby-ng_pkg_setup
}

src_unpack() {
	use php && php-ext-source-r2_src_unpack
	default
}

src_prepare() {
	#Upstream patch to allow perl to be built in the compile stage
	epatch "${FILESDIR}"/perl.mk.patch
	#Patch to fix java errors and allow compilation
	epatch "${FILESDIR}"/java.mk.patch
	#Patch to stop python from building the extension again during install
	epatch "${FILESDIR}"/python.mk.patch
	use php && php-ext-source-r2_src_prepare
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

	if use doc; then
		myconf="${myconf} --enable-maintainer-documentation"
	fi

	if use threads; then
		if use perl || use php || use python || use ruby; then
			ewarn "Enabling threads for perl, php, python or ruby causes segmentation faults."
			ewarn "Disabling threads"
			myconf="${myconf} --disable-thread-safe"
		else
			myconf="${myconf} --enable-thread-safe"
		fi
	fi

	if use ruby; then
		MYRUBYIMPLS=($(_ruby-get_use_implementations))
		MYRUBYFIRSTIMPL=${MYRUBYIMPLS[0]}
		#Set RUBY value in config to the first ruby implementation to build
		RUBY=$(ruby_implementation_command ${MYRUBYFIRSTIMPL})
		MYRUBYIMPLS=(${MYRUBYIMPLS[@]:1})
		myconf="${myconf} RUBY=${RUBY}"
	else
		myconf="${myconf} --disable-ruby"
	fi

	econf \
		--enable-shared_dependencies \
		--enable-depends \
		--enable-default-search-path="/usr /opt ${myphpprefix}" \
		--disable-examples \
		--disable-dotnet \
		$(use_enable debug) \
		$(use_enable sql-compiler) \
		${myconf}
}

src_compile() {
	if use php; then
		local slot myphpconfig="php-config"
		# Shift off the first slot so it doesn't get built again
		local myphpslots=($(php_get_slots)) myphpfirstslot="${myphpslots[@]:0:1}" myphpslots=(${myphpslots[@]:1})
		_php-replace_config_with_selected_config ${myphpfirstslot} ${myphpconfig}
		myphpconfig="${PHPCONFIG}"
	fi
	emake || die "emake failed"
	if use php; then
		# Move the current slotted build of php to another dir so other slots can be built
		_php-move_swig_build_to_modules_dir "${WORKDIR}/${myphpfirstslot}"
		# Build the remaining slots
		for slot in ${myphpslots[@]}; do
			_php-replace_config_with_selected_config ${slot} ${myphpconfig}
			myphpconfig="${PHPCONFIG}"
			# Build the current slot
			emake build/swig/php5/${PN}.so || die "Unable to make php${slot} extension"
			_php-move_swig_build_to_modules_dir ${PHP_EXT_S}
		done
	fi
	if use ruby; then
		# Move the current implementation build of ruby to another dir so other implementations can be built
		_ruby-move_swig_build_to_impl_dir "${WORKDIR}/${MYRUBYFIRSTIMPL}"
		unset MYFIRSTRUBYIMPL
		unset RUBY
		local impl
		MYRUBYIMPL="\${RUBY}"
		# Build the remaining implementations
		for impl in ${MYRUBYIMPLS[@]}; do
			cd "${S}" || die "cannot change to source directory"
			# Replace the reference to ${RUBY} with the current implementation
			sed -i -e "s|${MYRUBYIMPL}|$(ruby_implementation_command ${impl})|g" project/build/ruby.mk || die "sed ruby implementation change failed"
			MYRUBYIMPL="$(ruby_implementation_command ${impl})"
			# Build the current implementation
			emake build/swig/ruby/${PN}_native.bundle || die "Unable to make ${impl} extension"
			_ruby-move_swig_build_to_impl_dir "${WORKDIR}/${impl}"
		done
		unset MYRUBYIMPLS
	fi
}

each_ruby_install() {
	exeinto "$(ruby_rbconfig_value archdir)"
	doexe "${S}"/librets_native.so || die
	doruby "${S}"/librets.rb || die
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

	use ruby && ruby-ng_src_install

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
