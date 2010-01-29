# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="2"

inherit eutils java-pkg-2 java-ant-2 multilib

MY_P=${P/-/_}

DESCRIPTION="An integration of Eclipse and Vim"
HOMEPAGE="http://eclim.org/"
SRC_URI="mirror://sourceforge/eclim/${MY_P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="cdt +java php ruby"

COMMON_DEPEND="dev-util/eclipse-sdk:3.5"
DEPEND="${COMMON_DEPEND}
	>=virtual/jdk-1.5"
RDEPEND="${COMMON_DEPEND}
	|| ( app-editors/vim app-editors/gvim )
	>=virtual/jre-1.5"

S=${WORKDIR}/${MY_P}
eclipse_home="${ROOT}/usr/$(get_libdir)/eclipse-3.5"

pkg_setup() {
	ewarn "Eclim can only use Eclipse plugins that are installed system-wide."
	ewarn "Please make sure necessary plugins are installed in ${eclipse_home}."

	if use java ; then
		mypkg_plugins="jdt,ant,maven"
	fi
	if use cdt ; then
		mypkg_plugins="${mypkg_plugins},cdt"
		ewarn "You have enabled the 'cdt' USE flag."
		ewarn "The cdt plugin requires that you have the Eclipse CDT installed."
	fi
	if use php ; then
		mypkg_plugins="${mypkg_plugins},wst,dltk,pdt"
		ewarn "You have enabled the 'php' USE flag."
		ewarn "The php plugin requires that you have the Eclipse PDT installed."
	fi
	if use ruby ; then
		mypkg_plugins="${mypkg_plugins},dltk,dltkruby"
		ewarn "You have enabled the 'ruby' USE flag."
		ewarn "The ruby plugin requires that you have the Eclipse DLTK Ruby installed."
	fi

	# Remove leading comma
	mypkg_plugins=${mypkg_plugins#,}

	EANT_BUILD_TARGET="build"
	EANT_EXTRA_ARGS="-Declipse.home=${eclipse_home} \
		-Dplugins=${mypkg_plugins}"
	EANT_EXTRA_ARGS_INSTALL="-Declipse.home=${D}${eclipse_home} \
		-Dplugins=${mypkg_plugins} \
		-Dvim.files=${D}/usr/share/vim/vimfiles"
}

src_prepare() {
	# Fix a bug caused by incorrect version detection
	sed -i "s/execute('git', 'describe')/'${PV}'/" \
		"${S}"/src/ant/build.gant || die "sed failed"

	# Fix up the installation process
	epatch "${FILESDIR}"/${P}_fix_build_gant.patch
}

src_install() {
	eant ${EANT_EXTRA_ARGS_INSTALL} deploy

	# Fix path to eclim script
	sed -i "s:${D}::" "${D}"/usr/share/vim/vimfiles/eclim/plugin/eclim.vim \
		|| die "sed failed"

	dosym "${eclipse_home}"/plugins/org.${MY_P}/bin/eclimd \
		/usr/bin/eclimd || die "symlink failed"
	dosym "${eclipse_home}"/plugins/org.${MY_P}/bin/eclim \
		"${eclipse_home}"/eclim || die "symlink failed"
}
