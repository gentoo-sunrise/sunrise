# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="2"

inherit multilib perl-module

MY_P="${PN}-${PV#*_pre}-scons"

DESCRIPTION="Text-based, multi-protocol instant messenger"
HOMEPAGE="http://www.ekg2.org"
SRC_URI="http://proj.mgorny.alt.pl/ekg2/${MY_P}.tar.lzma"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64"
IUSE="dbus extra gadu gif gnutls gpg gpm gsm gtk icq idn inotify irc
	jabber jogger jpeg mail minimal ncurses nls nntp oracle oss pcap
	perl python readline remote rss ruby sim sms spell
	sqlite sqlite3 srv ssl static unicode web xosd zlib"

# -- non-obvious plugin mappings --
# extra	    -> autoresponder, polchat, rivchat, rot13, xmsg
# !minimal  -> ioctld, logs, rc
# any sound -> pcm
# web	    -> httprc_xajax

RDEPEND="
	dbus? ( sys-apps/dbus )
	gpg? ( app-crypt/gpgme )
	gsm? ( media-sound/gsm )
	gtk? ( x11-libs/gtk+:2 )
	idn? ( net-dns/libidn )
	nls? ( virtual/libintl )
	oracle?	( dev-db/oracle-instantclient-basic )
	pcap? ( net-libs/libpcap )
	perl? ( dev-lang/perl )
	python?	( dev-lang/python )
	readline? ( sys-libs/readline )
	rss? ( dev-libs/expat )
	ruby? ( dev-lang/ruby )
	sim? ( dev-libs/openssl )
	xosd? ( x11-libs/xosd )
	gadu? ( net-libs/libgadu
		gif? ( media-libs/giflib )
		jpeg? ( media-libs/jpeg ) )
	jabber? ( dev-libs/expat
		gnutls? ( net-libs/gnutls )
		!gnutls? ( ssl? ( dev-libs/openssl ) )
		zlib? ( sys-libs/zlib ) )
	!minimal? (
		zlib? ( sys-libs/zlib ) )
	ncurses? ( sys-libs/ncurses[unicode?]
		gpm? ( sys-libs/gpm )
		spell? ( app-text/aspell ) )
	sqlite3? ( dev-db/sqlite:3 )
	!sqlite3? ( sqlite? ( dev-db/sqlite:0 ) )"

DEPEND="dev-util/scons
	|| ( app-arch/xz-utils app-arch/lzma-utils )
	${RDEPEND}"

S=${WORKDIR}/${MY_P}

pkg_setup() {
	if ! use gtk && ! use ncurses && ! use readline && ! use remote && ! use web; then
		ewarn 'ekg2 is being compiled without any frontend, you should consider'
		ewarn 'enabling at least one of following USEflags:'
		ewarn '  gtk, ncurses, readline, remote, web.'
	fi
}

use_plug() {
	use $1 && echo -n ,${2:-$1}
}

# Build comma-separated plugin list based on USE
# We can put the same plugin few times if it's referenced by more than one flag

build_plugin_list() {
	echo '@none' \
	$(use_plug dbus) \
	$(use_plug extra autoresponder,polchat,rivchat,rot13,xmsg) \
	$(use_plug gadu gg) \
	$(use_plug gpg) \
	$(use_plug gsm) \
	$(use_plug gtk) \
	$(use_plug icq) \
	$(use_plug irc) \
	$(use_plug jabber jabber) \
	$(use_plug jogger jogger) \
	$(use_plug mail) \
	$(use_plug !minimal ioctld,logs,rc) \
	$(use_plug ncurses) \
	$(use_plug nntp feed) \
	$(use_plug oracle logsoracle) \
	$(use_plug oss oss,pcm) \
	$(use_plug pcap sniff) \
	$(use_plug perl) \
	$(use_plug python) \
	$(use_plug readline) \
	$(use_plug remote) \
	$(use_plug rss feed) \
	$(use_plug ruby) \
	$(use_plug sim) \
	$(use_plug sms) \
	$(use_plug sqlite logsqlite) \
	$(use_plug sqlite3 logsqlite) \
	$(use_plug web httprc_xajax) \
	$(use_plug xosd) \
		| tr -d '[[:space:]]'
}

# create DEPS list for plugin
# + means dep forced (fail if unavailable, prioritize over other one-of)
# - means dep disabled (don't even check for it)
# use:opt maps USEflag to specified opt
# usea|useb|usec makes one-of opt

make_deps() {
	local spls spll flag fopt out

	echo -n " $1_DEPS="
	shift

	# loop over different opts
	while [ -n "$1" ]; do
		spls=$1
		out=
		# loop over one-of opts
		while true; do
			# get next one-of, make sure spls gets empty if last
			spll=${spls%%|*}
			spls=${spls:$(( ${#spll} + 1 ))}
			# parse use:opt, if no :opt specified fopt=flag
			flag=${spll%:*}
			fopt=${spll#*:}

			# if one of one-of opt matches, we output only it
			# else we need to output all of them disabled
			use ${flag} && out=+ || out=${out}-
			out=${out}${fopt}

			# got more one-of opts? parse them only if this didn't match
			if [ -n "${spls}" ] && ! use ${flag}; then
				out=${out},
				continue
			fi

			echo -n ${out}
			shift
			[ -n "$1" ] && echo -n ,
			break
		done
	done
}

# create all DEPS lists

build_addopts_list() {
	use extra && make_deps XMSG inotify
	use gadu && make_deps GG gif jpeg
	use jabber && make_deps JABBER zlib 'gnutls|ssl:openssl'
	use mail && make_deps MAIL inotify
	use !minimal && make_deps LOGS zlib
	use ncurses && make_deps NCURSES gpm spell:aspell
	use rss || use nntp && make_deps FEED rss:expat
	use sqlite3 || use sqlite && make_deps LOGSQLITE 'sqlite3|sqlite'
}

# SCons doesn't build perl modules, perl-module.eclass does it better

foreach_perl_module() {
	if use perl; then
		cd plugins/perl || die 'cd plugins/perl failed'
		for DIR in */; do
			cd "${DIR}" || die "cd ${DIR} (perl module) failed"
			$1
			cd ..

			# workaround perl-module.eclass
			unset SRC_PREP
		done
		cd ../..
	fi
}

use_var() {
	echo -n "${2:-$1}=" | tr 'a-z' 'A-Z'
	use $1 && echo -n '1' || echo -n '0'
}

src_configure() {
	# HARDDEPS -> build should fail if some dep is unsatisfied
	# DISTNOTES -> are displayed with /version, helpful for upstream bug reports

	scons PLUGINS=$(build_plugin_list) $(build_addopts_list) \
		HARDDEPS=1 SKIPCHECKS=1 $(use_var unicode) $(use_var nls) \
		$(use_var static) $(use_var idn) $(use_var srv RESOLV) \
		PREFIX=/usr LIBDIR="\$EPREFIX/$(get_libdir)" \
		DOCDIR="\$DATAROOTDIR/doc/${PF}" \
		DISTNOTES="emdzientoo ebuild ${PVR}, USE=${USE}" \
		${MAKEOPTS} conf || die "scons conf failed"

	foreach_perl_module perl-module_src_configure
}

src_compile() {
	# SKIPCONF -> no need to reconfigure

	scons SKIPCONF=1 ${MAKEOPTS} || die "scons failed"

	foreach_perl_module perl-module_src_compile
}

src_test() {
	foreach_perl_module perl-module_src_test
}

src_install() {
	scons DESTDIR="${D}" ${MAKEOPTS} install || die "scons install failed"

	foreach_perl_module perl-module_src_install

	use perl && fixlocalpod
	prepalldocs
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
