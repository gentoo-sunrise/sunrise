# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=2

inherit depend.apache eutils multilib toolchain-funcs

DESCRIPTION="Nagios Fork - Check daemon, CGIs, docs, IDOutils"
HOMEPAGE="http://www.icinga.org/"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="+apache2 api debug +idoutils lighttpd +mysql perl plugins postgres ssl +vim-syntax +web"
DEPEND="idoutils? ( dev-db/libdbi-drivers[mysql?,postgres?] )
	perl? ( dev-lang/perl )
	virtual/mailx
	web? (
		media-libs/gd[jpeg,png]
		lighttpd? ( www-servers/lighttpd dev-lang/php[cgi] )
		apache2? ( || ( dev-lang/php[apache2] dev-lang/php[cgi] ) )
	)
	!net-analyzer/nagios-core"
RDEPEND="${DEPEND}
	plugins? ( net-analyzer/nagios-plugins )"

want_apache2

pkg_setup() {
	depend.apache_pkg_setup
	enewgroup icinga
	enewuser icinga -1 -1 /var/spool/icinga icinga
	if use web ; then
		elog "This does not include cgis that are perl-dependent"
		elog "Currently traceroute.cgi is perl-dependent"
		elog "Note that the user your webserver is running as needs"
		elog "read-access to /etc/icinga."
		elog
		if use apache2 || use lighttpd ; then
			elog "There are several possible solutions to accomplish this,"
			elog "choose the one you are most comfortable with:"
			elog
			if use apache2 ; then
				elog "	usermod -G icinga apache"
				elog "or"
				elog "	chown icinga:apache /etc/icinga"
				elog
				elog "Also edit /etc/conf.d/apache2 and add \"-D ICINGA\""
			elif use lighttpd ; then
				elog "  usermod -G icinga lighttpd "
				elog "or"
				elog "  chown icinga:lighttpd /etc/icinga"
				elog "Also edit /etc/lighttpd/lighttpd.conf and add 'include \"lighttpd_icinga.conf\"'"
			fi
			elog
			elog "That will make icinga's web front end visable via"
			elog "http://localhost/icinga/"
			elog
		else
			elog "IMPORTANT: Do not forget to add the user your webserver"
			elog "is running as to the icinga group!"
		fi

	else
		ewarn "Please note that you have installed Icinga without web interface."
		ewarn "Please don't file any bugs about having no web interface when you do this."
		ewarn "Thank you!"
	fi

}

src_prepare() {
	if use api ; then
		sed -i -e 's/\(USE_ICINGAAPI=\)no/\1yes/g' Makefile.in || die "sed failed in Makefile.in"
	fi
}

src_configure() {
	local myconf
	local myconf2

	myconf="$(use_enable perl embedded-perl)
	$(use_with perl perlcache)
	$(use_enable idoutils)
	$(use_enable ssl)
	$(use_enable debug DEBUG0)
	$(use_enable debug DEBUG1)
	$(use_enable debug DEBUG2)
	$(use_enable debug DEBUG3)
	$(use_enable debug DEBUG4)
	$(use_enable debug DEBUG5)
	--disable-statuswrl
	--with-cgiurl=/icinga/cgi-bin"

	myconf2="--bindir=/usr/sbin
	--sbindir=/usr/$(get_libdir)/icinga/cgi-bin
	--datarootdir=/usr/share/icinga/htdocs
	--localstatedir=/var/icinga
	--sysconfdir=/etc/icinga"

	if use plugins ; then
		myconf2+=" --libexecdir=/usr/$(get_libdir)/nagios/plugins"
	else
		myconf2+=" --libexecdir=/usr/$(get_libdir)/icinga/plugins"
	fi

	if use !apache2 && use !lighttpd ; then
		myconf2+=" --with-command-group=icinga"
	else
		if use apache2 ; then
			myconf+=" --with-httpd-conf=/etc/apache2/conf.d"
			myconf2+=" --with-command-group=apache"
		elif use lighttpd ; then
			myconf2+=" --with-command-group=lighttpd"
		fi
	fi

	econf ${myconf} ${myconf2}
	if use api ; then
		cd module/icinga-api || die
		econf ${myconf2}
	fi
}

src_compile() {
	tc-export CC

	emake icinga || die "make failed"

	if use web ; then
		emake DESTDIR="${D}" cgis || die
	fi

	if use idoutils ; then
		emake DESTDIR="${D}" idoutils || die
	fi
}

src_install() {
	dodoc Changelog README UPGRADING || die

	if ! use web ; then
		sed -i -e '/cd $(SRC_\(CGI\|HTM\))/d' Makefile || die
	fi
	sed -i -e 's/^contactgroups$//g' Makefile || die

	emake DESTDIR="${D}" install{,-config,-commandmode} || die

	if use idoutils ; then
		 emake DESTDIR="${D}" install-idoutils || die
	fi
	if use api ; then
		 emake DESTDIR="${D}" install-api || die
	fi

	newinitd "${FILESDIR}"/icinga-init.d icinga || die
	newconfd "${FILESDIR}"/icinga-conf.d icinga || die
	if use idoutils ; then
		newinitd "${FILESDIR}"/ido2db-init.d ido2db || die
		newconfd "${FILESDIR}"/ido2db-conf.d ido2db || die
		insinto /usr/share/icinga/contrib/db
		doins -r module/idoutils/db/* || die
	fi
	# Apache Module
	if use web ; then
		if use apache2 ; then
			insinto "${APACHE_MODULES_CONFDIR}"
			newins "${FILESDIR}"/icinga-apache.conf 99_icinga.conf || die
		elif use lighttpd ; then
			insinto /etc/lighttpd
			newins "${FILESDIR}"/icinga-lighty.conf lighttpd_icinga.conf || die
		else
			ewarn "${CATEGORY}/${PF} only supports Apache-2.x or Lighttpd webserver"
			ewarn "out-of-the-box. Since you are not using one of them, you"
			ewarn "have to configure your webserver accordingly yourself."
		fi

	fi

	mkdir -p "${D}"/var/log/icinga || die "Failed mkdir of /var/log/icinga"

	fowners -R icinga:icinga /etc/icinga /var/icinga /var/log/icinga || die

	sed -i -e 's:^log_file=.*:log_file=/var/log/icinga/icinga.log:' "${D}"/etc/icinga/icinga.cfg || die "Failed sed of /etc/icinga/icinga.cfg"

	fowners -R root:root /usr/$(get_libdir)/icinga || die
	cd "${D}" || die
	find usr/$(get_libdir)/icinga -type d -exec fperms 755 {} +
	find usr/$(get_libdir)/icinga/cgi-bin -type f -exec fperms 755 {} +

	keepdir /etc/icinga
	keepdir /var/icinga
	keepdir /var/icinga/archives
	keepdir /var/icinga/rw
	keepdir /var/icinga/spool/checkresults
	keepdir /var/log

	if use apache2 ; then
		webserver=apache
	elif use lighttpd ; then
		webserver=lighttpd
	else
		webserver=icinga
	fi
	fowners -R icinga:${webserver} /var/icinga/rw || die "Failed chown of /var/icinga/rw"

	fperms 6755 /var/icinga/rw || die "Failed Chmod of ${D}/var/icinga/rw"
	fperms 0750 /etc/icinga || die "Failed chmod of ${D}/etc/icinga"
}

pkg_postinst() {
	elog "If you want icinga to start at boot time"
	elog "remember to execute:"
	elog "  rc-update add icinga default"
	elog
	elog "If your kernel has /proc protection, icinga"
	elog "will not be happy as it relies on accessing the proc"
	elog "filesystem. You can fix this by adding icinga into"
	elog "the group wheel, but this is not recomended."
}
