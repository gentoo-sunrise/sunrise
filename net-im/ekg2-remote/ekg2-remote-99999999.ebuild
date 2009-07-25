# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="2"
ESVN_REPO_URI="http://toxygen.net/svn/ekg2/trunk"

inherit multilib subversion

DESCRIPTION="Remote UI client for EKG2 instant messenger"
HOMEPAGE="http://www.ekg2.org"
SRC_URI=""

LICENSE="GPL-2"
SLOT="0"
KEYWORDS=""
IUSE="gnutls gpm gtk ncurses readline spell ssl static unicode"

RDEPEND="
	gtk?	( >=x11-libs/gtk+-2.4 )
	readline? ( sys-libs/readline )
	gnutls?	( >=net-libs/gnutls-1.0.17 )
	!gnutls? ( ssl? ( >=dev-libs/openssl-0.9.6m ) )

	ncurses? ( sys-libs/ncurses[unicode?]
		gpm? ( >=sys-libs/gpm-1.20.1 )
		spell? ( >=app-text/aspell-0.50.5 ) )"

DEPEND=">=dev-util/scons-0.97
	${RDEPEND}"

pkg_setup() {
	# ekg2-remote supports less frontends than ekg2 due to stripped down API

	if ! use gtk && ! use ncurses && ! use readline; then
		ewarn 'ekg2-remote is being compiled without any frontend, you should consider'
		ewarn 'enabling either ncurses, readline or gtk USEflag.'
	fi
}

use_plug() {
	use $1 && echo -n ,${2:-$1}
}

# Build comma-separated plugin list based on USE

build_plugin_list() {
	echo '@none' \
	$(use_plug gtk) \
	$(use_plug ncurses) \
	$(use_plug readline) \
		| tr -d '[[:space:]]'
}

# create DEPS list for plugin
# + means dep forced (fail if unavailable)
# - means dep disabled (don't even check for it)
# use:opt maps USEflag to specified opt

make_deps() {
	local flag fopt out

	echo -n " $1_DEPS="
	shift

	# loop over different opts
	while [ -n "$1" ]; do
		# parse use:opt, if no :opt specified fopt=flag
		flag=${1%:*}
		fopt=${1#*:}

		use ${flag} && out=+ || out=-
		echo -n ${out}${fopt}

		shift
		[ -n "$1" ] && echo -n ,
	done
}

# REMOTE_SSL option

make_rssl() {
	if use gnutls; then
		echo -n gnutls
	elif use openssl; then
		echo -n openssl
	else
		echo -n none
	fi
}

use_var() {
	echo -n $1= | tr a-z A-Z
	use $1 && echo -n 1 || echo -n 0
}

src_configure() {
	# HARDDEPS -> build should fail if some dep is unsatisfied
	# DISTNOTES -> are displayed with /version, helpful for upstream bug reports

	scons PLUGINS=$(build_plugin_list) REMOTE=only REMOTE_SSL=$(make_rssl) \
		$(use ncurses && make_deps NCURSES gpm spell:aspell) \
		HARDDEPS=1 $(use_var unicode) $(use_var static) \
		PREFIX=/usr LIBDIR="\$EPREFIX/$(get_libdir)" \
		PLUGINDIR='$LIBDIR/ekg2-remote/plugins' DOCDIR="\$DATAROOTDIR/doc/${PF}" \
		DISTNOTES="emdzientoo ebuild ${PVR}, USE=${USE}" \
		${MAKEOPTS} conf || die "scons conf failed"
}

src_compile() {
	# SKIPCONF -> no need to reconfigure

	scons SKIPCONF=1 ${MAKEOPTS} || die "scons failed"
}

src_install() {
	scons DESTDIR="${D}" ${MAKEOPTS} install || die "scons install failed"
}

pkg_postinst() {
	elog "EKG2 is still considered very experimental. Please do report all issues"
	elog "to mailing list ekg2-users@lists.ziew.org (you can write in English)."
	elog "Please do not file bugs to Gentoo Bugzilla."
	elog
	elog "Before reporting a bug, please check if it's reproducible and get"
	elog "complete backtrace of it. Even if you can't reproduce it, you may let us"
	elog "know that something like that happened."
	elog
	elog "How to get backtraces:"
	elog "	http://www.gentoo.org/proj/en/qa/backtraces.xml"
	elog
	elog "Thank you and have fun."
}
