# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

inherit eutils bash-completion-r1 multilib-build

DESCRIPTION="Reference compiler for the D programming language"
HOMEPAGE="http://dlang.org/"
SRC_URI="http://downloads.dlang.org.s3.amazonaws.com/releases/2013/${PN}.${PV}.zip"

# DMD supports amd64/x86 exclusively
KEYWORDS="-* ~amd64 ~x86"
SLOT="2"
IUSE="multilib doc examples tools"

# License doesn't allow redistribution
LICENSE="DMD"
RESTRICT="mirror"

DEPEND="app-arch/unzip
	sys-apps/findutils
	virtual/awk"
RDEPEND="!dev-lang/dmd-bin"

S="${WORKDIR}/dmd2"

src_prepare() {
	# Remove precompiled binaries and non-essential files.
	rm -r README.TXT windows osx linux/lib{32,64} linux/bin{32,64}/{README.TXT,dmd,dmd.conf} \
		|| die "Failed to remove included binaries."

	# convert line-endings of file-types that start as cr-lf and are patched or installed later on
	find . -name "*.txt" -o -name "*.html" -o -name "*.d" -o -name "*.di" -o -name "*.ddoc" -type f -exec edos2unix {} \; \
		|| die "Failed to convert DOS line-endings to Unix."

	# patch: copy VERSION file into dmd directory
	cp src/VERSION src/dmd/VERSION \
		|| die "Failed to copy VERSION file into dmd directory."
}

abi_to_model() {
	if [[ "${ABI}" == "amd64" ]] || [[ "${ABI}" == "amd64_fbsd" ]]; then
		echo 64
	else
		echo 32
	fi
}

dmd_foreach_abi() {
	for ABI in $(multilib_get_enabled_abis); do
		local MODEL=$(abi_to_model)
		einfo "Executing ${1} in ${MODEL}-bit ..."
		"${@}"
	done
}

src_compile() {
	# A native build of dmd is used to compile the runtimes for both x86 and amd64
	# We cannot use multilib-minimal yet, as we have to be sure dmd for amd64 
	# always gets build first.
	einfo 'Building dmd ...'
	emake -C src/dmd -f posix.mak TARGET_CPU=X86 RELEASE=1

	compile_libraries() {
		einfo 'Building druntime ...'
		emake -C src/druntime -f posix.mak MODEL=${MODEL} DMD=../dmd/dmd

		einfo 'Building Phobos 2 ...'
		emake -C src/phobos -f posix.mak MODEL=${MODEL} DMD=../dmd/dmd
	}

	dmd_foreach_abi compile_libraries
}

src_test() {
	test_hello_world() {
		src/dmd/dmd -m${MODEL} -Isrc/phobos -Isrc/druntime/import -L-Lsrc/phobos/generated/linux/release/${MODEL} samples/d/hello.d || die "Failed to build hello.d (${MODEL}-bit)"
		./hello ${MODEL}-bit || die "Failed to run test sample (${MODEL}-bit)"
		rm hello.o hello
	}

	dmd_foreach_abi test_hello_world
}

src_install() {
	# Prepeare and install config file.
	cat > src/dmd/dmd.conf << EOF
[Environment]
DFLAGS=-I/usr/include/phobos2 -I/usr/include/druntime -L--export-dynamic
EOF
	insinto /etc
	doins src/dmd/dmd.conf
	dobashcomp "${FILESDIR}/${PN}.bashcomp"

	# Compiler
	dobin src/dmd/dmd

	# Man pages, docs and samples
	doman man/man1/{dmd.1,dmd.conf.5}
	use doc && dohtml -r html/*

	if use tools; then
		doman man/man1/{dumpobj,obj2asm,rdmd}.1

		# Bundled pre-compiled tools
		dobin linux/bin$(abi_to_model)/{ddemangle,dman,dumpobj,obj2asm,rdmd}
	fi

	if use examples; then
		docompress -x /usr/share/doc/${PF}/samples/
		insinto /usr/share/doc/${PF}/samples/
		doins -r samples/d/*
	fi

	# druntime & Phobos 2
	install_libraries() {
		local MODEL=$(abi_to_model)
		dolib.a src/phobos/generated/linux/release/${MODEL}/libphobos2.a
		newlib.so src/phobos/generated/linux/release/${MODEL}/libphobos2.so.0.64 libphobos2.so.0.64.0
		dosym libphobos2.so.0.64.0 /usr/$(get_libdir)/libphobos2.so.0.64
		dosym libphobos2.so.0.64.0 /usr/$(get_libdir)/libphobos2.so
	}
	multilib_foreach_abi install_libraries

	# Imports
	insinto /usr/include/druntime/
	doins -r src/druntime/import/*

	rm -r src/phobos/{*.mak,generated,etc/c/zlib} || die "Could not remove non-import files from Phobos."
	insinto /usr/include/phobos2
	doins -r src/phobos/*
}

pkg_postinst() {
	if use doc || use examples; then
		elog "The bundled docs and/or samples may be found in"
		elog "/usr/share/doc/${PF}"
	fi
}
