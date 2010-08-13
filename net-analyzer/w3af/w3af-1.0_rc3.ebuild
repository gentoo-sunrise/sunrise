# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=2

PYTHON_USE_WITH="sqlite"
PYTHON_DEPEND="2"

inherit multilib python versionator

MY_P=${PN}-"$(replace_version_separator 2 '-')"
DESCRIPTION="Web Application Attack and Audit Framework"
HOMEPAGE="http://w3af.sourceforge.net/"
SRC_URI="mirror://sourceforge/${PN}/${MY_P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="doc gtk"

RDEPEND="dev-python/beautifulsoup
	>=dev-python/fpconst-0.7.2
	dev-python/nltk
	dev-python/pyopenssl
	dev-python/pyPdf
	dev-python/pysqlite
	dev-python/soappy
	net-analyzer/scapy
	gtk? ( media-gfx/graphviz
		>dev-python/pygtk-2.0 )"

S=${WORKDIR}/${PN}

src_prepare(){
	rm -r extlib/{BeautifulSoup.py,fpconst-0.7.2,jsonpy,nltk,nltk_contrib,pygoogle,pyPdf,scapy,SOAPpy,yaml} || die
	rm readme/{GPL,INSTALL} || die
}

src_install() {
	insinto /usr/$(get_libdir)/w3af
	doins -r core extlib locales plugins profiles scripts tools w3af_gui w3af_console || die
	dosym /usr/$(get_libdir)/w3af/w3af_gui usr/bin/w3af_gui || die
	dosym /usr/$(get_libdir)/w3af/w3af_console usr/bin/w3af_console || die
	fperms +x /usr/$(get_libdir)/w3af/w3af_{gui,console} || die
	#use flag doc is here because doc is bigger than 3 Mb
	if use doc ; then
		insinto /usr/share/doc/${PF}/
		doins -r readme/* || die
	fi
}
