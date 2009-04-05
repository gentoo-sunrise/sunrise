# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="2"

inherit mozextension multilib

MY_PN="weave"
MY_P=${MY_PN}-${PV}

DESCRIPTION="Mozilla Labs prototype for online services"
HOMEPAGE="http://labs.mozilla.com/projects/weave/"
SRC_URI="http://hg.mozilla.org/labs/${MY_PN}/index.cgi/archive/${PV}.tar.gz
	-> ${P}.tar.gz"

LICENSE="|| ( MPL-1.1 GPL-2 LGPL-2.1 )"
SLOT="0"
KEYWORDS="" # needs to be keyworded
IUSE=""

# mozilla-firefox-3.1_beta is not in the tree atm
RDEPEND=">=www-client/mozilla-firefox-bin-3.1_beta
	net-libs/xulrunner:1.9
	>=dev-libs/nss-3.12
	>=dev-libs/nspr-4.7.1"
DEPEND="${RDEPEND}"

S=${WORKDIR}/${MY_P}

# NOTES:
# there are tests but they don't break the build if not working
# thunderbird and fennec are in install.rdf

src_prepare() {
	# we want to use system nss and nspr
	sed -i -e 's@-I\$(sdkdir)\(/include/ns\(s\|pr\)\)@-I/usr\1@' \
		src/Makefile || die "patching Makefile failed"
	sed -i -e 's@^\(libdirs\s*:=\s*.*\)$@\1 /usr/lib/nspr /usr/lib/nss@' \
		src/Makefile || die "patching Makefile failed"

	# remove useless platforms
	rm -fr platform/* || die "rm -rf never dies"

	# ppc arch is not recognized on Linux
	# upstream has been contacted w/patch, see bug 486797 in upstream bugtracker
	sed -i -e "s/Power Macintosh/ppc/" src/Makefile \
		|| die "patching src/Makefile failed"
}

src_compile() {
	export XULRUNNER_BIN=/usr/bin/xulrunner-1.9
	export WEAVE_BUILDID=${PV}
	export MOZSDKDIR=/usr/$(get_libdir)/xulrunner-1.9

	emake release_build=1 xpi || "emake failed"
}

src_install() {
	local MOZILLA_FIVE_HOME

	# recommanded usage is to launch firefox with xpi as a parameter
	# so, we unzip the file and intsall it with mozextension tools
	unzip -qo "${MY_P}-rel.xpi" -d "${MY_P}"

	if has_version '>=www-client/mozilla-firefox-3.1_beta'; then
		MOZILLA_FIVE_HOME="/usr/$(get_libdir)/mozilla-firefox"
		xpi_install "${S}/${MY_P}"
	fi
	if has_version '>=www-client/mozilla-firefox-bin-3.1_beta'; then
		MOZILLA_FIVE_HOME="/opt/firefox"
		xpi_install "${S}/${MY_P}"
	fi
}

pkg_postinst() {
	einfo "To use Weave, you have to get an account at https://services.mozilla.com/"
	einfo "Otherwise, you can setup your own server, see:"
	einfo "https://wiki.mozilla.org/Labs/Weave/0.3/Setup/Server"
}
