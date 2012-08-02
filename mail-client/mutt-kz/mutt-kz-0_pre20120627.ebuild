# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=4

inherit eutils autotools vcs-snapshot

DESCRIPTION="A fork of mutt, the small but very powerful text-based mail client"
HOMEPAGE="https://github.com/karelzak/mutt-kz/wiki/"
GIT_REPO_URI="http://github.com/karelzak/${PN}"
GIT_COMMIT="12a7ab46c9155d674cf6f249e831983647f4b47c"
SRC_URI="${GIT_REPO_URI}/tarball/${GIT_COMMIT} -> ${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"

# TODO: implement "prefix" flag like in original mutt. Must test it first.
# TODO: test mbox flag
IUSE="berkdb crypt debug doc gdbm gnutls gpg idn imap notmuch mbox nls pop
qdbm sasl smime smtp ssl tokyocabinet"

# dependencies used several times
RDEPEND_PROTOCOL="
	gnutls? ( >=net-libs/gnutls-1.0.17 )
	!gnutls? ( ssl? ( >=dev-libs/openssl-0.9.6 ) )
	sasl? ( >=dev-libs/cyrus-sasl-2 )"
RDEPEND="
	app-misc/mime-types
	!mail-client/mutt
	>=sys-libs/ncurses-5.2
	gpg? ( >=app-crypt/gpgme-0.9.0 )
	idn? ( net-dns/libidn )
	imap? ( ${RDEPEND_PROTOCOL} )
	pop? ( ${RDEPEND_PROTOCOL} )
	smime? ( >=dev-libs/openssl-0.9.6 )
	smtp? ( ${RDEPEND_PROTOCOL} )
	tokyocabinet? ( dev-db/tokyocabinet )
	!tokyocabinet? (
		qdbm? ( dev-db/qdbm )
		!qdbm? (
			gdbm? ( sys-libs/gdbm )
			!gdbm? ( berkdb? ( >=sys-libs/db-4 ) )
		)
	)"
# unsure if mailbase only belongs to DEPEND
# unsure on mutt flag for net-mail/notmuch
# unsure on crypt dependency too
RDEPEND="${RDEPEND}
	net-mail/mailbase
	notmuch? (
		net-mail/notmuch[mutt]
		crypt? ( net-mail/notmuch[crypt] )
	)"
DEPEND="${RDEPEND}
	doc? (
		app-text/docbook-xsl-stylesheets
		dev-libs/libxml2
		dev-libs/libxslt
		|| ( www-client/w3m www-client/elinks www-client/lynx )
	)"

MY_PN="mutt"

src_prepare() {
	# patch for a QA severe warning
	# add Gentoo's progress bar, used in the sample .muttrc
	epatch "${FILESDIR}/${P}"-severe-warnings.patch \
		"${FILESDIR}/${P}"-progress-bar.patch

	# patch version string for bug reports
	sed -i -e 's/"Mutt %s (%s)"/"Mutt-KZ %s (%s, Gentoo '"${PVR}"')"/' \
		muttlib.c || die "failed patching Gentoo version"

	# allow user patches
	epatch_user

	# many patches touch the buildsystem, we always need this
	AT_M4DIR="m4" eautoreconf

	# the configure script contains some "cleverness" whether or not to setgid
	# the dotlock program, resulting in bugs like #278332
	sed -i -e 's/@DOTLOCK_GROUP@//' \
		Makefile.in || die "sed failed"

	# don't just build documentation (lengthy process, with big dependencies)
	if use !doc ; then
		sed -i -e '/SUBDIRS =/s/doc//' Makefile.in || die "sed failed"
	fi
}

src_configure() {
	local myconf="
		$(use_enable crypt pgp) \
		$(use_enable debug) \
		$(use_enable gpg gpgme) \
		$(use_enable imap) \
		$(use_enable nls) \
		$(use_enable notmuch) \
		$(use_enable pop) \
		$(use_enable smime) \
		$(use_enable smtp) \
		$(use_with idn) \
		$(use_with !notmuch mixmaster) \
		--enable-external-dotlock \
		--enable-nfs-fix \
		--sysconfdir="${EPREFIX}"/etc/${MY_PN} \
		--with-curses \
		--with-docdir="${EPREFIX}"/usr/share/doc/${PF} \
		--with-regex \
		--with-exec-shell="${EPREFIX}"/bin/sh"

	case $CHOST in
		*-solaris*)
			# Solaris has no flock in the standard headers
			myconf+=" --enable-fcntl --disable-flock"
		;;
		*)
			myconf+=" --disable-fcntl --enable-flock"
		;;
	esac

	# mutt prioritizes gdbm over bdb, so we will too.
	# hcache feature requires at least one database is in USE.
	if use tokyocabinet; then
		myconf+=" --enable-hcache \
			--with-tokyocabinet --without-qdbm --without-gdbm --without-bdb"
	elif use qdbm; then
		myconf+=" --enable-hcache \
			--without-tokyocabinet --with-qdbm --without-gdbm --without-bdb"
	elif use gdbm ; then
		myconf+=" --enable-hcache \
			--without-tokyocabinet --without-qdbm --with-gdbm --without-bdb"
	elif use berkdb; then
		myconf+=" --enable-hcache \
			--without-tokyocabinet --without-qdbm --without-gdbm --with-bdb"
	else
		myconf+=" --disable-hcache \
			--without-tokyocabinet --without-qdbm --without-gdbm --without-bdb"
	fi

	# there's no need for gnutls, ssl or sasl without socket support
	if use pop || use imap || use smtp ; then
		if use gnutls; then
			myconf+=" --with-gnutls"
		elif use ssl; then
			myconf+=" --with-ssl"
		fi
		# not sure if this should be mutually exclusive with the other two
		myconf+=" $(use_with sasl)"
	else
		myconf+=" --without-gnutls --without-ssl --without-sasl"
	fi

	if use mbox; then
		myconf+=" --with-mailpath=${EPREFIX}/var/spool/mail"
	else
		myconf+=" --with-homespool=Maildir"
	fi

	econf ${myconf}
}

src_install() {
	emake DESTDIR="${D}" install

	insinto /etc/"${MY_PN}"
	if use mbox; then
		newins "${FILESDIR}"/Muttrc.mbox Muttrc
	else
		doins "${FILESDIR}"/Muttrc
	fi

	# A newer file is provided by app-misc/mime-types. So we link it.
	rm "${ED}"/etc/${MY_PN}/mime.types || die "Failed to delete file."
	dosym /etc/mime.types /etc/${MY_PN}/mime.types

	# A man-page is always handy, so fake one
	if use !doc; then
		emake -C doc muttrc.man
		# make the fake slightly better, bug #413405
		sed -e 's#@docdir@/manual.txt#http://www.mutt.org/doc/devel/manual.html#' \
			-e 's#in @docdir@,#at http://www.mutt.org/,#' \
			-e "s#@sysconfdir@#${EPREFIX}/etc/${MY_PN}#" \
			-e "s#@bindir@#${EPREFIX}/usr/bin#" \
			doc/mutt.man > mutt.1 || die "sed failed"
		newman doc/muttbug.man flea.1
		newman doc/muttrc.man muttrc.5
		doman mutt.1
	else
		# nuke manpages that should be provided by an MTA, bug #177605
		rm "${ED}"/usr/share/man/man5/{mbox,mmdf}.5 \
			|| die "failed to remove files, please file a bug"
	fi

	dodoc BEWARE ChangeLog NEWS OPS* PATCHES README* TODO
}

pkg_postinst() {
	echo
	elog "If you are new to mutt you may want to take a look at"
	elog "the Gentoo QuickStart Guide to Mutt E-Mail:"
	elog "   http://www.gentoo.org/doc/en/guide-to-mutt.xml"
	echo

	if use notmuch ; then
		# TODO: document a config that works out of the box with notmuch, please help ;)
		elog "Note that you can use notmuch specific mutt config file, see -F <config> in"
		elog "\"man mutt\" and also \"man muttrc\". It's also recomended to run \"notmuch setup\""
		elog "and \"notmuch new\"."
		echo
	fi
}

pkg_info() {
	einfo "`"${MY_PN}" -v`"
}
