# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit mercurial webapp

DESCRIPTION="tagging wiki"
HOMEPAGE="http://tools.suckless.org/view/taggi"
SRC_URI=""
EHG_REPO_URI=http://suckless.org/cgi-bin/hgwebdir.cgi/${PN}

LICENSE="MIT"
KEYWORDS="~x86"
IUSE=""

DEPEND=""
RDEPEND="sys-apps/gawk
	sys-apps/coreutils
	sys-apps/grep
	dev-lang/perl
	sys-apps/sed
	app-shells/bash"

S=${WORKDIR}/${PN}

src_unpack() {
	mercurial_src_unpack
	cd "${S}"

	sed -i \
		-e "s%\(DATADIR=\).*%\1/var/www/localhost/taggi%" \
		-e "s%\(URLDECODE=\).*%\1/usr/bin/urldecode.awk%" \
		-e "s%\(URLENCODE=\).*%\1/usr/bin/urlencode.awk%" \
		-e "s%\(WIKIFMT=\).*%\1/usr/bin/markdown.pl%" \
		-e "s%\(HASHCMD=\).*%\1taggi-sha1.sh%" \
		taggi.conf || die "sed taggi.conf failed"

	for i in edit.sh save.sh view.sh; do
		sed -i \
			-e "s%\(SCRIPTHOST\)/\(edit\|save\|view\).sh%\1/cgi-bin/\2.sh%g" \
			${i} || die  "sed ${i} failed"
	done

	# fix vhost menu
	sed -i \
		-e "s%\(http://\$t.\$SCRIPTHOST\)%\1/cgi-bin/view.sh%" \
		view.sh || die "sed view failed"
}

src_install() {
	webapp_src_preinst

	dobin markdown.pl urldecode.awk urlencode.awk
	dobin "${FILESDIR}"/taggi-sha1.sh

	exeinto "${MY_CGIBINDIR}"
	doexe edit.sh save.sh view.sh

	insinto "${MY_CGIBINDIR}"
	doins taggi.conf
	webapp_configfile "${MY_CGIBINDIR}"/taggi.conf

	keepdir "${MY_HOSTROOTDIR}"/taggi/www
	webapp_serverowned -R "${MY_HOSTROOTDIR}"/taggi

	dodoc README

	webapp_src_install
}

pkg_postinst() {
	webapp_pkg_postinst

	einfo "Edit taggi.conf in cgi-bin dir to configure ${PN}"
	einfo "And open the URL http://<your-host>/cgi-bin/view.sh"
}
