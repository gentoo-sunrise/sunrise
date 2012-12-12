# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="5"

PLOCALES="da de"

inherit l10n perl-module

MY_PN="libparse-debianchangelog-perl"

DESCRIPTION="Parse Debian changelogs and output them in other formats"
HOMEPAGE="http://packages.qa.debian.org/libparse-debianchangelog-perl"
SRC_URI="mirror://debian/pool/main/libp/${MY_PN}/${MY_PN}_${PV}.orig.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="test"

RDEPEND="dev-perl/Class-Accessor
	dev-perl/IO-String
	dev-perl/Locale-gettext
	dev-perl/TimeDate
	virtual/perl-File-Spec
	virtual/perl-PodParser"
DEPEND="app-text/po4a
	dev-perl/HTML-Parser
	dev-perl/HTML-Template
	dev-perl/XML-Simple
	virtual/perl-Module-Build
	test? (
		app-text/htmltidy
		dev-perl/Test-Exception
		dev-perl/Test-Pod
		dev-perl/Test-Pod-Coverage
		virtual/perl-Test-Simple
	)"

S="${WORKDIR}/${PN}-v${PV}"

SRC_TEST="do parallel"

src_prepare() {
	# Remove disabled locales
	remove_locale() {
		sed -r -i -e "s/po\/[a-z]+\.${1}\.po//" MANIFEST || die
		rm po/*.${1}.po || die
	}

	# Prevent disabled locales from being built
	l10n_for_each_disabled_locale_do remove_locale
	perl-module_src_prepare
}
