# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="4"
inherit eutils user

DESCRIPTION="IRC bot to share files via DCC"
HOMEPAGE="http://iroffer.dinoex.de/projects/iroffer"
SRC_URI="http://iroffer.dinoex.net/${P}.tar.gz
	http://iroffer.dinoex.net/HISTORY/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64"

# Generate IUSE
DINOEX_DEFAULT_MODULES="+admin +blowfish +chroot +http +memsave +ssl +telnet"
DINOEX_OPTIONAL_MODULES="curl debug geoip gnutls ruby static upnp"
DINOEX_LANGUAGES="de en fr it"

IUSE="${DINOEX_DEFAULT_MODULES} ${DINOEX_OPTIONAL_MODULES} daemon"
for lang in ${DINOEX_LANGUAGES}
do
	IUSE="${IUSE} linguas_${lang}"
done

REQUIRED_USE="
	admin? ( http )
"
# Handle in src_configure: gnutls? ( !ssl )

DEPEND="
	chroot? ( dev-libs/nss )
	curl? ( net-misc/curl )
	geoip? ( dev-libs/geoip )
	gnutls? ( net-libs/gnutls )
	ruby? ( dev-lang/ruby )
	ssl? ( dev-libs/openssl )
"

RDEPEND="
	${DEPEND}
	!net-irc/iroffer
"

pkg_setup(){
	# Create user if USE="+daemon"
	if use daemon ; then
		enewgroup ${PN}
		enewuser ${PN} -1 -1 -1 ${PN}
	fi
}

src_prepare(){
	# Patch for Makefile:
	# add an option on "install" (otherwise it will install some files outside of sandbox) [ FIXME: Will be replace on next version to avoid the problem ]
	# remove forced "-o2" option when "debug" is not select [ FIXME: Will be replace on next version to avoid the problem ]
	# remove a chroot test (always fail due to sandbox I presume) [ FIXME: Refused by upstream because it is system specific ]
	# add an option to avoid automagic with chroot (-no-chroot, enabled by default) [ FIXME: Will be upstream on next version ]
	epatch "${FILESDIR}/${P}-Makefile.patch"

	# Although the launch is ok, exit status is 69 in background mode [ FIXME: Will be upstream on next version ]
	epatch "${FILESDIR}/${P}-exit-status-background.patch"

	# Update defaults configuration files (usefull for "+daemon")
	epatch "${FILESDIR}/${PN}-config.patch"
}

src_configure(){
	local my_conf opts

	# Remove unselected default modules
	for opts in ${DINOEX_DEFAULT_MODULES}
	do
		opts=${opts:1} # Remove "+"

		if ! use $opts ; then
			if [[ $opts != "ssl" ]] ; then
				my_conf="${my_conf} -no-$opts"
			else
				my_conf="${my_conf} -no-openssl"
			fi
		fi
	done

	# Add selected optional modules
	for opts in ${DINOEX_OPTIONAL_MODULES}
	do
		if use $opts ; then
			case $opts in
				"gnutls")
					# Conflicting USE ssl and gnutls, priority to gnutls
					my_conf="${my_conf} -no-openssl -tls";;
				"static")
					my_conf="${my_conf} -no-libs";;
				*)
					my_conf="${my_conf} -$opts";;
			esac
		fi
	done

	# Iroffer uses a unusual configuration file. Need PREFIX (install in /usr/local, forbidden in portage)
	./Configure PREFIX="/usr" ${my_conf} || die "Error during ./Configure"
}

src_compile(){
	# Iroffer need the language as first argument of Makefile
	# Compile each available languages or just English
	strip-linguas "${DINOEX_LANGUAGES}"

	emake ${LINGUAS:-en}
}

src_install(){
	local lang

	for lang in ${LINGUAS:-en}
	do
		emake DESTDIR="${D}" install-${lang}

		# i18n docs
		dodoc help-admin-${lang}.txt
		case $lang in
			"de")
				dodoc beispiel.config LIESMICH.modDinoex;;
			"fr")
				dodoc exemple.config;;
			*)
				dodoc sample.config;;
		esac
	done

	# Common docs
	dodoc README README.modDinoex dynip.sh iroffer.cron
	newdoc "${FILESDIR}/${PN}-HOWTO" HOWTO
	doman iroffer.1

	# Specific stuff for "+daemon"
	if use daemon ; then
		insinto /etc/${PN}
		insopts -m0660 -o root -g ${PN}

		for lang in ${LINGUAS:-en}
		do
			case $lang in
				"de")
					doins beispiel.config;;
				"fr")
					doins exemple.config;;
				*)
					doins sample.config;;
			esac
		done

		insinto /etc/logrotate.d
		insopts -m0644 -o root -g root
		newins "${FILESDIR}/${PN}.logrotate" ${PN}

		newinitd "${FILESDIR}/${PN}.init" ${PN}
		newconfd "${FILESDIR}/${PN}.conf" ${PN}
	fi
}

pkg_postinst(){
	elog "Quick start: \"HOWTO\" in \"/usr/share/doc/${PF}\""

	if use daemon ; then
		elog
		ewarn "If you upgrade ${PN}, you can restart all ${PN}'s daemons with:"
		ewarn "	find /etc/init.d/ -name ${PN}.* -execdir {} restart \;"
		ewarn "This command will disconnect all users!"
	fi
}
