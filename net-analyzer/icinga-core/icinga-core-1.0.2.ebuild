# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-analyzer/icinga-core/icinga-core-3.1.0.ebuild,v 1.3 2009/02/24 17:07:42 dertobi123 Exp $

EAPI="2"

inherit eutils depend.apache toolchain-funcs

SRC_URI="mirror://sourceforge/icinga/icinga-${PV}.tar.gz"
DESCRIPTION="Icinga - Check daemon, CGIs, docs, IDOutils"
HOMEPAGE="http://www.icinga.org/"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="+apache2 api debug +idoutils lighttpd perl plugins +vim-syntax +web"
DEPEND="idoutils? ( dev-db/libdbi-drivers[mysql] )
	perl? ( >=dev-lang/perl-5.6.1-r7 )
	virtual/mailx
	web? (
		>=media-libs/gd-1.8.3-r5[jpeg,png]
		lighttpd? ( www-servers/lighttpd dev-lang/php[cgi] )
		apache2? ( || ( dev-lang/php[apache2] dev-lang/php[cgi] ) )
	)
	!net-analyzer/nagios-core"
RDEPEND="${DEPEND}
	plugins? ( net-analyzer/nagios-plugins )
	vim-syntax? ( app-vim/nagios-syntax )"

want_apache2

pkg_setup() {
	enewgroup icinga
	enewuser icinga -1 /bin/bash /var/spool/icinga icinga
}

src_prepare() {
	local strip="$(echo '$(MAKE) strip-post-install')"
	sed -i -e "s:${strip}::" {cgi,base}/Makefile.in || die "sed failed in
	Makefile.in"
	if use api ; then
		sed -i -e 's/USE_ICINGAAPI=no/USE_ICINGAAPI=yes/g' Makefile.in
	fi
}

src_configure() {
	local myconf

	if use perl ; then
		myconf="${myconf} --enable-embedded-perl --with-perlcache"
	fi

	myconf="${myconf} --disable-statuswrl $(use_enable idoutils)"

	if use debug; then
		myconf="${myconf} --enable-DEBUG0"
		myconf="${myconf} --enable-DEBUG1"
		myconf="${myconf} --enable-DEBUG2"
		myconf="${myconf} --enable-DEBUG3"
		myconf="${myconf} --enable-DEBUG4"
		myconf="${myconf} --enable-DEBUG5"
	fi

	if use !apache2 && use !lighttpd ; then
		myconf="${myconf} --with-command-group=icinga"
	else
		if use apache2 ; then
			myconf="${myconf} --with-command-group=apache"
			myconf="${myconf} --with-httpd-conf=/etc/apache2/conf.d"
		elif use lighttpd ; then
			myconf="${myconf} --with-command-group=lighttpd"
		fi
	fi

	econf ${myconf} \
		--prefix=/usr \
		--bindir=/usr/sbin \
		--sbindir=/usr/$(get_libdir)/icinga/cgi-bin \
		--datarootdir=/usr/share/icinga/htdocs \
		--localstatedir=/var/icinga \
		--sysconfdir=/etc/icinga \
		--libexecdir=/usr/$(get_libdir)/icinga/plugins \
		|| die "./configure failed"
	if use api ; then
	        sed -i -e 's/USE_ICINGAAPI=no/USE_ICINGAAPI=yes/g' Makefile
	fi
	if use api ; then
		cd module/icinga-api
		econf --prefix=/usr \
			--bindir=/usr/sbin \
	        --sbindir=/usr/$(get_libdir)/icinga/cgi-bin \
			--datarootdir=/usr/share/icinga/htdocs \
			--localstatedir=/var/icinga \
	        --sysconfdir=/etc/icinga \
			--libexecdir=/usr/$(get_libdir)/icinga/plugins \
			|| die "./configure failed"
	fi
}

src_compile() {

	emake CC=$(tc-getCC) icinga || die "make failed"

	if use web ; then
		# Only compile the CGI's if "web" useflag is set.
		emake CC=$(tc-getCC) DESTDIR="${D}" cgis || die
	fi

	if use idoutils ; then
		# Only compile IDOUtils if "idoutils" useflag is set.
		emake CC=$(tc-getCC) DESTDIR="${D}" idoutils || die
	fi
}

src_install() {
	dodoc Changelog INSTALLING LEGAL README UPGRADING

	if ! use web ; then
		sed -i -e 's/cd $(SRC_CGI) && $(MAKE) $@/# line removed due missing web use flag/' \
			-e 's/cd $(SRC_HTM) && $(MAKE) $@/# line removed due missing web use flag/' \
			Makefile
	fi
	sed -i -e 's/^contactgroups$//g' Makefile

	emake DESTDIR="${D}" install
	emake DESTDIR="${D}" install-config
	emake DESTDIR="${D}" install-commandmode

	if use idoutils ; then
		 emake DESTDIR="${D}" install-idoutils
	fi
	if use api ; then
		 emake DESTDIR="${D}" install-api
	fi

	newinitd "${FILESDIR}"/icinga-init.d icinga
	newconfd "${FILESDIR}"/icinga-conf.d icinga
	if use idoutils ; then
		newinitd "${FILESDIR}"/ido2db-init.d ido2db
		newconfd "${FILESDIR}"/ido2db-conf.d ido2db
		mkdir -p "${D}"/usr/share/icinga/contrib/db
		cp -r "${S}"/module/idoutils/db/* "${D}"/usr/share/icinga/contrib/db/
	fi
	# Apache Module
	if use web ; then
		if use apache2 ; then
			insinto "${APACHE_MODULES_CONFDIR}"
			newins "${FILESDIR}"/icinga-apache.conf 99_icinga.conf
	    elif use lighttpd ; then
			insinto /etc/lighttpd
			newins "${FILESDIR}"/icinga-lighty.conf lighttpd_icinga.conf
		else
			ewarn "${CATEGORY}/${PF} only supports Apache-2.x or Lighttpd webserver"
			ewarn "out-of-the-box. Since you are not using one of them, you"
			ewarn "have to configure your webserver accordingly yourself."
		fi

	fi

	for dir in etc/icinga var/icinga ; do
		chown -R icinga:icinga "${D}/${dir}" || die "Failed chown of ${D}/${dir}"
	done

	chown -R root:root "${D}"/usr/$(get_libdir)/icinga
	find "${D}"/usr/$(get_libdir)/icinga -type d -print0 | xargs -0 chmod 755
	find "${D}"/usr/$(get_libdir)/icinga/cgi-bin -type f -print0 | xargs -0 chmod 755

	keepdir /etc/icinga
	keepdir /var/icinga
	keepdir /var/icinga/archives
	keepdir /var/icinga/rw
	keepdir /var/icinga/spool/checkresults

	if use !apache2 && use !lighttpd; then
		chown -R icinga:icinga "${D}"/var/icinga/rw || die "Failed chown of ${D}/var/icinga/rw"
	else
		if use apache2 ; then
			chown -R icinga:apache "${D}"/var/icinga/rw || die "Failed chown of ${D}/var/icinga/rw"
		elif use lighttpd ; then
			chown -R icinga:lighttpd "${D}"/var/icinga/rw || die "Failed chown of ${D}/var/icinga/rw"
		fi
	fi

	chmod ug+s "${D}"/var/icinga/rw || die "Failed Chmod of ${D}/var/icinga/rw"
	chmod 0750 "${D}"/etc/icinga || die "Failed chmod of ${D}/etc/icinga"
}

pkg_postinst() {
	elog "If you want icinga to start at boot time"
	elog "remember to execute:"
	elog "  rc-update add icinga default"
	elog

	if use web ; then
		elog "This does not include cgis that are perl-dependent"
		elog "Currently traceroute.cgi is perl-dependent"
		elog "To have ministatus.cgi requires copying of ministatus.c"
		elog "to cgi directory for compiling."

		elog "Note that the user your webserver is running at needs"
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
		elog "Please note that you have installed Icinga without web interface."
		elog "Please don't file any bugs about having no web interface when you do this."
		elog "Thank you!"
	fi

	elog
	elog "If your kernel has /proc protection, icinga"
	elog "will not be happy as it relies on accessing the proc"
	elog "filesystem. You can fix this by adding icinga into"
	elog "the group wheel, but this is not recomended."
	elog
	einfo "Fixing permissions"
	chown icinga:icinga "${ROOT}"var/icinga
}
