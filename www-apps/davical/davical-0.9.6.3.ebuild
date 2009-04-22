# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="2"

inherit webapp depend.php

DESCRIPTION="A CalDAV and iCal server"
HOMEPAGE="http://davical.org/"
SRC_URI="http://debian.mcmillan.net.nz/packages/${PN}/${P/-/_}.tar.gz"

LICENSE="GPL-2"
KEYWORDS="~amd64 ~x86"
IUSE="doc vhosts"

DEPEND="doc? ( dev-php/PEAR-PhpDocumentor )"
RDEPEND="www-servers/apache
	dev-lang/php[pcre,postgres,xml]
	app-admin/pwgen
	>=dev-php/awl-0.36
	dev-perl/yaml
	dev-perl/DBI
	dev-perl/DBD-Pg"

need_php5
need_httpd

src_compile() {
	if use doc ; then
		ebegin "Generating documentation"
		phpdoc -c "docs/api/phpdoc.ini"
		eend $? || die "Documentation failed to build"
	fi
	emake inc/always.php || die "emake failed"
	scripts/po/rebuild-translations.sh
}

src_install() {
	webapp_src_preinst

	local docs="INSTALL README debian/README.Debian \
		testing/README.regression_tests \
		TODO debian/changelog"
	dodoc-php ${docs} || die "dodoc failed"

	einfo "Installing main files"
	local dirs="htdocs inc locale"
	insinto "${MY_HTDOCSDIR}"
	doins -r ${dirs} || die "doins failed"

	einfo "Installing sql files"
	insinto "${MY_SQLSCRIPTSDIR}"
	doins -r dba/* || die "doins failed"

	if use doc ; then
		einfo "Installing documentation"
		dohtml -r "docs/api/" || die "dohtml failed"
		dohtml -r "docs/website/" || die "dohtml failed"
	fi

	insinto /etc/${PN}
	newins "${FILESDIR}/rscds.conf" calendar.example.com-conf.php \
		|| die "newins failed"

	webapp_postinst_txt en "${FILESDIR}/postinstall-en-${PV}.txt"
	webapp_src_install

	fperms +x "${MY_SQLSCRIPTSDIR}/create-database.sh"
	fperms +x "${MY_SQLSCRIPTSDIR}/update-davical-database"
	fperms +x "${MY_SQLSCRIPTSDIR}/update-rscds-database"

}
