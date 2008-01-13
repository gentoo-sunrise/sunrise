# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

WX_GTK_VER=2.6
inherit eutils toolchain-funcs flag-o-matic wxwidgets

MY_P=${P/a/A}

DESCRIPTION="integrated development + performance environment for chuck"
HOMEPAGE="http://audicle.cs.princeton.edu/mini/"
SRC_URI="http://audicle.cs.princeton.edu/mini/release/files/${MY_P}.tgz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86"
IUSE="oss jack unicode"

RDEPEND="jack? ( media-sound/jack-audio-connection-kit )
	!jack? ( !oss? ( >=media-libs/alsa-lib-0.9 ) )
	media-libs/libsndfile
	=x11-libs/wxGTK-2.6*"
DEPEND="${RDEPEND}
	sys-devel/bison
	sys-devel/flex"

S=${WORKDIR}/${MY_P}

pkg_setup() {
	local cnt=0
	use jack && cnt="$((${cnt} + 1))"
	use oss && cnt="$((${cnt} + 1))"
	if [[ "${cnt}" -eq 0 ]] ; then
		ewarn "ALSA audio engine will be used. If you want something else, then"
		ewarn "enable either jack or oss USE flag and recompile this package."
	elif [[ "${cnt}" -ne 1 ]] ; then
		ewarn "You have set ${P} to use multiple audio engines."
		ewarn "This is not supported - jack audio engine will be used."
	fi
}

src_compile() {
	use unicode && need-wxwidgets unicode

	local backend
	if use jack; then
		backend="jack"
	elif use oss; then
		backend="oss"
	else
		backend="alsa"
	fi
	einfo "Compiling against ${backend}"

	# when compiled with -march=athlon or -march=athlon-xp
	# miniaudicle crashes on removing a shred with a double free or corruption
	# it happens in Chuck_VM_Stack::shutdown() on the line
	#   SAFE_DELETE_ARRAY( stack );
	replace-cpu-flags athlon athlon-xp i686

	cd "${S}"/chuck/src
	emake -f "makefile.${backend}" CC=$(tc-getCC) CXX=$(tc-getCXX) || die "emake failed"

	cd "${S}"
	emake -f "makefile.${backend}" CC=$(tc-getCC) CXX=$(tc-getCXX) || die "emake failed"
}

src_install() {
	dobin wxw/miniAudicle
	dodoc BUGS README.linux VERSIONS
}
