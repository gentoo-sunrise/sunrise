# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="5"

PHP_EXT_OPTIONAL_USE="php"
PHP_EXT_NAME="librets"
PHP_EXT_SKIP_PHPIZE="yes"
USE_PHP="php5-3 php5-4"

PYTHON_COMPAT=( python2_{6,7} )

USE_RUBY="ree18 ruby18 ruby19"
RUBY_OPTIONAL="yes"

inherit autotools eutils java-pkg-opt-2 mono perl-module php-ext-source-r2 python-r1 ruby-ng toolchain-funcs versionator

DESCRIPTION="A library that implements the RETS 1.8, 1.7, 1.5 and 1.0 standards"
HOMEPAGE="http://www.crt.realtors.org/projects/rets/librets/"
SRC_URI="http://www.crt.realtors.org/projects/rets/${PN}/files/${P}.tar.gz"

LICENSE="BSD-NAR"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="doc java mono perl php python ruby sql-compiler threads"
# Enabling thread safety for perl, php, python or ruby causes segmentation faults in cli scripts but not through apache
REQUIRED_USE="perl? ( !threads )
	php? ( !threads )
	python? ( !threads )
	ruby? ( !threads )"

SWIG_RDEPEND="dev-libs/libgcrypt
	dev-libs/libgpg-error
	dev-libs/libtasn1
	net-dns/libidn
	net-libs/gnutls"

RDEPEND=">=dev-libs/boost-1.46
	dev-libs/expat
	>=dev-util/boost-build-1.46
	net-misc/curl
	sql-compiler? ( dev-java/antlr:0[script] )
	sys-libs/zlib
	java? ( >=virtual/jdk-1.6.0 ${SWIG_RDEPEND} )
	mono? ( dev-lang/mono ${SWIG_RDEPEND} )
	php? ( ${SWIG_RDEPEND} )
	python? ( ${SWIG_RDEPEND} ${PYTHON_DEPS} )
	ruby? ( $(ruby_implementations_depend) ${SWIG_RDEPEND} )"

# An upstream bug prevents the php extension from building with swig >= 2.0.5
DEPEND="java? ( >=dev-lang/swig-1.3.40-r1 )
	mono? ( >=dev-lang/swig-1.3.40-r1 )
	php? ( dev-lang/php[-threads] >=dev-lang/swig-1.3.40-r1 )
	python? ( >=dev-lang/swig-1.3.40-r1 )
	ruby_targets_ruby18? ( >=dev-lang/swig-1.3.40-r1 )
	ruby_targets_ruby19? ( >=dev-lang/swig-2.0.4-r1 )
	${RDEPEND}"

# Reset to the default $S since ruby-ng overrides it
S="${WORKDIR}/${P}"

unset SWIG_RDEPEND

# Since php-ext-source-r2_src_install tries to install non-existant headers
# and a bad emake fails on EAPI 4, a copied subset must be used instead (bug 404307).
my_php-ext-source-r2_src_install() {
	local slot
	for slot in $(php_get_slots); do
		php_init_slot_env ${slot}
		# Let's put the default module away
		insinto "${EXT_DIR}"
		newins "modules/${PHP_EXT_NAME}.so" "${PHP_EXT_NAME}.so"
	done
	php-ext-source-r2_createinifiles
}

my_php-move_swig_build_to_modules_dir() {
	mkdir "${1}"/modules || die "Could not create directory for php slot"
	mv build/swig/php5/* "${1}"/modules || die "Could not move php slot build"
}

my_php-replace_config_with_selected_config() {
	php_init_slot_env ${1}
	cd "${S}" || die "cannot change to source directory"
	# Replace the reference to php-config with the current slotted one
	sed -i -e "s|${2}|${PHPCONFIG}|g" project/build/php.mk || die "sed php-config change failed"
}

my_ruby-move_swig_build_to_impl_dir() {
	mkdir -p "${1}"/${P} || die "Could not create directory for ruby implementation"
	mv build/swig/ruby/* "${1}"/${P} || die "Could not move ruby implementation build"
}

pkg_setup() {
	use java && java-pkg-opt-2_pkg_setup
	use perl && perl-module_pkg_setup
	use ruby && ruby-ng_pkg_setup
}

src_unpack() {
	use php && php-ext-source-r2_src_unpack
	default
}

src_prepare() {
	epatch "${FILESDIR}"/${P}-extconf.rb.patch
	epatch "${FILESDIR}"/${P}-java.mk.patch
	epatch "${FILESDIR}"/${P}-build.patch
	eautoreconf

	# Change the path to librets-config-inplace for python slotted build support
	if use python; then
		sed -i -e "s|../../..|${S}|" project/swig/python/setup.py || die
	fi

	use php && php-ext-source-r2_src_prepare
}

src_configure() {
	local myphpprefix

	if use php; then
		# Enable php extension when it finds the current selected slot
		myphpprefix="${PHPPREFIX}/include"
	fi

	# The build system just finds "python", which could be python3.2 if EPYTHON is unset.
	use python && python_export_best EPYTHON

	if use ruby; then
		MYRUBYIMPLS=($(ruby_get_use_implementations))
		MYRUBYFIRSTIMPL=${MYRUBYIMPLS[0]}
		# Set RUBY value in config to the first ruby implementation to build
		RUBY=$(ruby_implementation_command ${MYRUBYFIRSTIMPL})
		MYRUBYIMPLS=(${MYRUBYIMPLS[@]:1})
	fi

	# Allow cross-compiling between operating systems since ar is not portable
	tc-export AR
	econf \
		--enable-shared_dependencies \
		--enable-depends \
		--enable-default-search-path="/usr /opt ${myphpprefix}" \
		--disable-examples \
		--disable-debug \
		$(usex doc "--enable-maintainer-documentation") \
		$(usex java "" "--disable-java") \
		$(usex mono "" "--disable-dotnet") \
		$(usex perl "" "--disable-perl") \
		$(usex php "" "--disable-php") \
		$(usex python "" "--disable-python") \
		$(usex threads "--enable-thread-safe") \
		$(use_enable sql-compiler) \
		$(use_with mono "snk-file" "${FILESDIR}"/${PN}.snk) \
		$(usex ruby " RUBY=${RUBY}" "--disable-ruby")
}

src_compile() {
	if use php; then
		local slot myphpconfig="php-config"
		# Shift off the first slot so it doesn't get built again
		local myphpslots=($(php_get_slots)) myphpfirstslot="${myphpslots[@]:0:1}" myphpslots=(${myphpslots[@]:1})
		my_php-replace_config_with_selected_config ${myphpfirstslot} ${myphpconfig}
		myphpconfig="${PHPCONFIG}"
	fi
	emake
	if use php; then
		# Move the current slotted build of php to another dir so other slots can be built
		my_php-move_swig_build_to_modules_dir "${WORKDIR}/${myphpfirstslot}"
		# Build the remaining slots
		for slot in ${myphpslots[@]}; do
			my_php-replace_config_with_selected_config ${slot} ${myphpconfig}
			myphpconfig="${PHPCONFIG}"
			# Build the current slot
			emake build/swig/php5/${PN}.so
			my_php-move_swig_build_to_modules_dir "${PHP_EXT_S}"
		done
	fi

	# Build the remaining python implementations
	use python && python_foreach_impl emake

	if use ruby; then
		# Move the current implementation build of ruby to another dir so other implementations can be built
		my_ruby-move_swig_build_to_impl_dir "${WORKDIR}/${MYRUBYFIRSTIMPL}"
		unset MYFIRSTRUBYIMPL
		unset RUBY
		local impl
		MYRUBYIMPL="\${RUBY}"
		# Build the remaining implementations
		for impl in ${MYRUBYIMPLS[@]}; do
			cd "${S}" || die "cannot change to source directory"
			# Replace the reference to ${RUBY} with the current implementation
			sed -i -e "s|${MYRUBYIMPL}|$(ruby_implementation_command ${impl})|g" \
				project/build/ruby.mk || die "sed ruby implementation change failed"
			MYRUBYIMPL="$(ruby_implementation_command ${impl})"
			# Build the current implementation
			emake build/swig/ruby/${PN}_native.bundle
			my_ruby-move_swig_build_to_impl_dir "${WORKDIR}/${impl}"
		done
		unset MYRUBYIMPL
		unset MYRUBYIMPLS
		unset impl
	fi
}

each_ruby_install() {
	exeinto "$(ruby_rbconfig_value archdir)"
	doexe "${S}"/librets_native.so
	doruby "${S}"/librets.rb
}

src_install() {
	dolib.a build/${PN}/lib/${PN}.a

	insinto /usr/include
	doins -r project/${PN}/include/${PN}

	dobin "${PN}-config"

	if use php; then
		my_php-ext-source-r2_src_install
		insinto /usr/share/php
		doins "${WORKDIR}"/php"${PHP_CURRENTSLOT}"/modules/${PN}.php
	fi

	if use perl; then
		# Install manually since the package install has sandbox violations
		insinto ${SITE_ARCH}
		insopts "-m755"
		doins -r "${S}"/build/swig/perl/blib/arch/auto
		insopts "-m644"
		doins "${S}"/build/swig/perl/${PN}.pm
	fi

	if use java; then
		java-pkg_dojar "${S}"/build/swig/java/${PN}.jar
		LIBOPTIONS="-m755" java-pkg_doso "${S}"/build/swig/java/${PN}.so
	fi

	use ruby && ruby-ng_src_install

	if use mono; then
		egacinstall "${S}"/build/swig/csharp/${PN}-dotnet.dll
	fi

	if use python; then
		python_install() {
			pushd "${S}"/build/swig/python || die
			"${PYTHON}" setup.py install --root="${D}" || die
			popd
		}
		python_foreach_impl python_install
	fi
}

pkg_preinst() {
	use perl && perl-module_pkg_preinst
}

pkg_postinst() {
	use perl && perl-module_pkg_postinst
}

pkg_prerm() {
	use perl && perl-module_pkg_prerm
}

pkg_postrm() {
	use perl && perl-module_pkg_postrm
}
