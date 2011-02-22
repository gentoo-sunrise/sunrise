# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="3"
inherit eutils flag-o-matic multilib versionator

DESCRIPTION="A re-implementation of the Ruby VM designed for speed"
HOMEPAGE="http://rubini.us"
SRC_URI="https://github.com/evanphx/${PN}/tarball/release-${PV} -> ${P}.tar.gz"

LICENSE="BSD"
KEYWORDS="~x86"
SLOT="0"
IUSE=""

RDEPEND="sys-libs/readline:5
	dev-ruby/rubygems
	>=sys-devel/llvm-2.8
	sys-libs/zlib"
DEPEND="${RDEPEND}
	sys-devel/bison
	dev-lang/ruby:1.8
	dev-ruby/rake"

src_configure() {
	unset RUBYOPT
	#Rubinius uses a non-autoconf ./configure script which balks at econf
	./configure --skip-prebuilt \
	--prefix /usr/$(get_libdir) \
	--mandir /usr/share/man \
	|| die "Configure failed"
}

src_compile() {
	unset RUBYOPT
	append-cppflags "-D__STDC_LIMIT_MACROS -D__STDC_CONSTANT_MACROS"
	rake build || die "Rake failed"
}

src_install() {
	local minor_version=$(get_version_component_range 1-2)
	local librbx="usr/$(get_libdir)/rubinius"

	sed -i -e "s#/${librbx}#${D}${librbx}#" config.rb || die "Can't fix config.rb"

	rake compiler:load install:build || die "rake install:build failed"
	rake install:files || die "rake install:files failed"

	dosym /${librbx}/${minor_version}/bin/rbx /usr/bin/rbx || die "Couldn't make rbx symlink"

	insinto /${librbx}/${minor_version}/site
	doins "${FILESDIR}/auto_gem.rb" || die "Couldn't install rbx autogem.rb"
}
