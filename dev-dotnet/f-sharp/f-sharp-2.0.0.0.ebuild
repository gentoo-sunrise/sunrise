# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=2

inherit eutils mono

DESCRIPTION="The F# programming language and tools"
HOMEPAGE="http://fsharp.net/"
SRC_URI="http://download.microsoft.com/download/B/8/6/B869DF5B-B2C7-4125-8A1E-23CA77235048/fsharp.zip -> ${P}.zip"

LICENSE="MSR-SSLA"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND=">=dev-lang/mono-2.6"
DEPEND="app-arch/unzip
		${RDEPEND}"

S=${WORKDIR}/FSharp-${PV}

create_exe_wrappers() {
	ebegin "creating compiler wrappers"

	for exe in fsi fsc; do
		make_wrapper ${exe} "mono /usr/$(get_libdir)/${PN}/${exe}.exe" \
			|| die "couldn't create wrapper for ${exe}.exe"
	done

	eend $?
}

src_install() {
	insinto "/usr/$(get_libdir)/${PN}"
	doins bin/* || die "installing libraries failed"

	local libname=bin/FSharp.Core.dll

	# Sign $libname with the Mono key, per the instructions
	# in install-mono.sh.
	sn -q -R "${S}/${libname}" "${FILESDIR}/mono.snk" \
		|| die "couldn't sign the ${libname} assembly"

	# After signing, this should work.
	egacinstall "${libname}" \
		|| die "couldn't install ${libname} in the global assembly cache"

	create_exe_wrappers
}
