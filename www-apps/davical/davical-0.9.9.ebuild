# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=2

inherit depend.php webapp

DESCRIPTION="A CalDAV and iCal server"
HOMEPAGE="http://davical.org/"
SRC_URI="http://debian.mcmillan.net.nz/packages/${PN}/${P}.tar.gz"

LICENSE="GPL-2"
KEYWORDS="~amd64 ~x86"
IUSE="doc"

DEPEND="doc? ( dev-php/PEAR-PhpDocumentor )"
RDEPEND="app-admin/pwgen
	dev-lang/php[pcre,pdo,postgres,xml]
	dev-perl/DBI
	dev-perl/DBD-Pg
	dev-perl/yaml
	>=dev-php/awl-0.43
	www-servers/apache"

need_php5
need_httpd

src_compile() {
	if use doc ; then
		einfo "Generating documentation"
		phpdoc -c "docs/api/phpdoc.ini"\
			|| die "Documentation failed to build"
	fi
	emake built-po || die "emake failed"
}

src_install() {
	webapp_src_preinst

	dodoc-php INSTALL README debian/README.Debian \
		testing/README.regression_tests TODO debian/changelog \
		|| die "dodoc failed"

	einfo "Installing web files"
	insinto "${MY_HTDOCSDIR}"
	doins -r htdocs/* htdocs/.htaccess || die "doins failed"

	einfo "Installing main files and i18n"
	insinto "${MY_HOSTROOTDIR}"
	doins -r inc locale || die "doins failed"
	rm -f "${D}/${MY_HOSTROOTDIR}/inc/always.php.in"

	einfo "Installing sql files"
	insinto "${MY_SQLSCRIPTSDIR}"
	doins -r dba/* || die "doins failed"

	if use doc ; then
		einfo "Installing documentation"
		dohtml -r docs/api/ docs/website/ || die "dohtml failed"
	fi

	insinto /etc/${PN}
	doins config/* "${FILESDIR}/vhost-example" \
		|| die "newins failed"

	webapp_postinst_txt en "${FILESDIR}/postinstall-en-${PV}.txt"
	webapp_src_install

	fperms +x "${MY_SQLSCRIPTSDIR}/create-database.sh"
	fperms +x "${MY_SQLSCRIPTSDIR}/update-davical-database"
}
