# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="5"

inherit eutils gnuconfig multilib

#revision for debian stable versions (e.g. +squeeze)
MY_PVR=""

DESCRIPTION="Debian commandline package manager"
HOMEPAGE="http://packages.qa.debian.org/apt"
SRC_URI="mirror://debian/pool/main/a/${PN}/${PN}_${PV}${MY_PVR}.tar.gz"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="apt-pkg berkdb doc examples graphviz largefile latex nls rpath ssl utils"
ILINGUAS="ar ast bg bs ca cs cy da de dz el es eu fi fr gl hu it ja km
	ko ku lt mr nb ne nl nn pl pt pt_BR ro ru sk sl sv th tl uk
	vi zh_CN zh_TW"

for lang in $ILINGUAS; do
	IUSE="${IUSE} linguas_${lang}"
done
REQUIRED_USE="berkdb? ( apt-pkg )
	graphviz? ( doc )
	latex? ( doc )
	utils? ( apt-pkg )"

COMMON_DEPEND="sys-libs/zlib
	berkdb? ( sys-libs/db )"
RDEPEND="app-arch/dpkg
	app-crypt/gnupg
	virtual/udev
	ssl? ( net-misc/curl[ssl] )
	${COMMON_DEPEND}"
DEPEND="app-text/debiandoc-sgml
	>=app-text/docbook-xml-dtd-4.5
	app-text/docbook-xsl-stylesheets
	>=app-text/po4a-0.40.1
	dev-libs/libxslt
	dev-util/intltool
	net-misc/curl[ssl]
	sys-devel/gettext
	doc? (
		app-doc/doxygen
		graphviz? ( media-gfx/graphviz )
	)
	${COMMON_DEPEND}"

S="${WORKDIR}/${P}${MY_PVR}"

src_prepare() {
	strip-linguas $ILINGUAS
	# Fix broken symlinks
	gnuconfig_update
	sed -e 's#xml/docbook/stylesheet/nwalsh#sgml/docbook/xsl-stylesheets#' \
		-i doc/manpage-style.xsl || die
}

src_configure() {
	HAVE_DOT=$(usex graphviz "YES" "NO") econf \
		$(use_enable largefile ) \
		$(use_enable nls ) \
		$(use_enable rpath )
}

src_compile() {
	# Make the compile process noisy so it's easier to debug for QA
	emake NOISY=1
}

src_install() {
	local mydpkglibdir=/usr/$(get_libdir)/dpkg/methods/${PN}
	local myetcdir=/etc/${PN}
	local mylangs=

	# Install main binaries
	dobin bin/apt-{cache,cdrom,config,get,key,mark}
	exeinto /usr/$(get_libdir)/${PN}/methods
	doexe bin/methods/*
	if ! use ssl; then
		rm "${D}"/usr/$(get_libdir)/apt/methods/https || die
	fi

	insinto ${mydpkglibdir}
	doins dselect/{desc.apt,names}
	exeinto ${mydpkglibdir}
	doexe dselect/{install,setup,update}
	dolib.so bin/libapt-pkg*
	insinto /usr/share/bug/${PN}
	newins debian/apt.bug-script script

	# Install lintian overrides
	insinto /usr/share/lintian/overrides
	newins "${FILESDIR}"/apt.lintian ${PN}

	# Install configuration examples
	if use examples; then
		insinto /usr/share/doc/${PF}
		doins -r docs/examples
	fi

	# Install API documentation
	if use doc; then
		dohtml -r build/doc/doxygen/html/*.{html,png}
		rm "${D}"/usr/share/doc/${PF}/html/files.html || die
		if use latex; then
			insinto /usr/share/doc/${PF}
			doins -r build/doc/doxygen/latex
			# Uncompress tex files since tex editors cannot use compressed files
			docompress -x /usr/share/doc/${PF}/latex
		fi
	fi

	# Install main documentation
	dodoc debian/{changelog,NEWS}
	if use ssl; then
		dodoc debian/apt-transport-https.README
	fi
	dodoc docs/{design.text,dpkg-tech.text,files.text,guide.text,method.text,offline.text}
	dohtml -r docs/{design.html,dpkg-tech.html,files.html,guide.html,method.html,offline.html}
	doman doc/{apt-config.8,apt-get.8,apt-key.8,apt-mark.8,apt-secure.8}
	doman doc/{apt-cache.8,apt-cdrom.8,apt.8,apt.conf.5,apt_preferences.5,sources.list.5}

	if ! use utils; then
		find locale -type f -iname "apt-utils.mo" -delete || die
	fi

	# Install locale related docs
	for lang in ${ILINGUAS}; do
		use linguas_${lang} || continue
		# store use languages so there's no need to check use again
		mylangs="${mylangs} ${lang}"

		insinto /usr/share/locale
		doins -r locale/${lang}

		if [ -e docs/guide.${lang}.html ]; then
			dohtml -r docs/guide.${lang}.html
		fi
		if [ -e docs/offline.${lang}.html ]; then
			dohtml -r docs/offline.${lang}.html
		fi
		if [ -e docs/guide.${lang}.text ]; then
			dohtml -r docs/guide.${lang}.text
		fi
		if [ -e docs/offline.${lang}.text ]; then
			dohtml -r docs/offline.${lang}.text
		fi
		if [ -e doc/${lang} ]; then
			doman doc/${lang}/{apt-config.${lang}.8,apt-get.${lang}.8,apt-key.${lang}.8}
			doman doc/${lang}/{apt-mark.${lang}.8,apt-secure.${lang}.8}
			doman doc/${lang}/{apt-cache.${lang}.8,apt-cdrom.${lang}.8,apt.conf.${lang}.5}
			doman doc/${lang}/{apt_preferences.${lang}.5,sources.list.${lang}.5}
		fi
	done
	unset lang

	# Install example of sources.list in main configuration area
	insinto ${myetcdir}
	doins doc/examples/sources.list

	# Install auto remove configuration
	insinto ${myetcdir}/apt.conf.d
	newins debian/apt.conf.autoremove 01autoremove

	# Create other needed configuration directories
	keepdir ${myetcdir}/preferences.d
	keepdir ${myetcdir}/sources.list.d
	keepdir ${myetcdir}/trusted.gpg.d

	# Install log rotation configuration
	insinto /etc/logrotate.d
	newins debian/apt.logrotate ${PN}

	# Install apt cront script
	insinto /etc/cron.daily
	newins debian/apt.cron.daily ${PN}

	# Create other needed directories
	keepdir /var/cache/${PN}/archives/partial
	keepdir /var/lib/${PN}/lists/partial
	keepdir /var/lib/${PN}/mirrors/partial
	keepdir /var/lib/${PN}/periodic
	keepdir /var/log/${PN}

	# Install apt pkg libraries
	if use apt-pkg; then
		doheader -r include/apt-pkg
		dolib.so bin/libapt-inst.so*

		# Install apt-ftparchive and related docs
		if use berkdb; then
			dobin bin/apt-ftparchive
			doman doc/apt-ftparchive.1
			for lang in ${mylangs}; do
				if [ -e doc/${lang} ]; then
					doman doc/${lang}/apt-ftparchive.${lang}.1
				fi
			done
			unset lang
			if use examples; then
				dodoc doc/examples/apt-ftparchive.conf
			fi
		fi

		# Install apt utility programs and docs
		if use utils; then
			dobin bin/apt-{extracttemplates,internal-solver,sortpkgs}
			doman doc/{apt-extracttemplates.1,apt-sortpkgs.1}
		        for lang in ${mylangs}; do
				if [ -e doc/${lang} ]; then
					doman doc/${lang}/{apt-extracttemplates.${lang}.1,apt-sortpkgs.${lang}.1}
				fi
			done
			unset lang
		fi
	fi
}
