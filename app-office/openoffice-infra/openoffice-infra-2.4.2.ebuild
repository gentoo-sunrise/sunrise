# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

WANT_AUTOCONF="2.5"
WANT_AUTOMAKE="1.9"
EAPI="1"

inherit autotools check-reqs db-use eutils fdo-mime flag-o-matic java-pkg-opt-2 kde-functions mono multilib


IUSE="binfilter cups dbus debug eds firefox gnome gstreamer gtk java kde ldap mono odk oodict opengl pam seamonkey xulrunner"

PATCHLEVEL="OOH680"
MILESTONE="18"
OOOTAG=${PATCHLEVEL}_m${MILESTONE}
OOOBUILDTAG=ooh680-m${MILESTONE}


SRC="OOo_${PV}_src"
S="${WORKDIR}/infra-ooo-files_${PV}"
WORKSRC="${WORKDIR}/${OOOTAG}"

DESCRIPTION="OpenOffice-Infra, office suite with enhanced Russian support from Infra-Resource"

SRC_URI="mirror://openoffice/stable/${PV}/${SRC}_core.tar.bz2
	mirror://openoffice/stable/${PV}/${SRC}_system.tar.bz2
	mirror://openoffice/stable/${PV}/${SRC}_binfilter.tar.bz2
	odk? ( mirror://openoffice/stable/${PV}/${SRC}_sdk.tar.bz2
		java? ( http://tools.openoffice.org/unowinreg_prebuild/680/unowinreg.dll ) )
	http://download.go-oo.org/SRC680/extras-2.tar.bz2
	http://download.go-oo.org/SRC680/biblio.tar.bz2
	http://download.go-oo.org/SRC680/lp_solve_5.5.0.10_source.tar.gz
	http://download.go-oo.org/SRC680/oox.2008-02-29.tar.bz2
	http://download.go-oo.org/SRC680/writerfilter.2008-02-29.tar.bz2
	http://download.i-rs.ru/pub/openoffice/${PV}/ru/infra-ooo-files_2.4.2.tar.gz
	http://tools.openoffice.org/unowinreg_prebuild/680/unowinreg.dll"

LANGS1="de fr ru uk"
LANGS="${LANGS1} en en_US"

# proprt linguas handling
for X in ${LANGS} ; do
	IUSE="${IUSE} linguas_${X}"
done

for Y in ${LANGS1} ; do
	SRC_URI="${SRC_URI} linguas_${Y}? ( mirror://openoffice/stable/${PV}/${SRC}_l10n.tar.bz2 )"
done

# detect ARCH variable
if [[ "${ARCH}" == "amd64" ]] ; then
	ARCH_VAR="x"
else
	ARCH_VAR="i"
fi

HOMEPAGE="http://www.i-rs.ru/ http://www.go-oo.org/"

LICENSE="LGPL-2"
SLOT="0"
KEYWORDS="~x86 ~amd64"

COMMON_DEPEND="!app-office/openoffice-bin
	x11-libs/libXaw
	x11-libs/libXinerama
	>=dev-lang/perl-5.0
	dbus? ( >=dev-libs/dbus-glib-0.71 )
	gnome? ( >=x11-libs/gtk+-2.10
		>=gnome-base/gnome-vfs-2.6
		>=gnome-base/gconf-2.0
		>=x11-libs/cairo-1.0.2 )
	gtk? ( >=x11-libs/gtk+-2.10
		>=x11-libs/cairo-1.0.2 )
	eds? ( >=gnome-extra/evolution-data-server-1.2 )
	gstreamer? ( >=media-libs/gstreamer-0.10
			>=media-libs/gst-plugins-base-0.10 )
	kde? ( =kde-base/kdelibs-3* )
	java? ( >=dev-java/bsh-2.0_beta4
	>=dev-java/xalan-2.7
	>=dev-java/xalan-serializer-2.7
	>=dev-java/xerces-2.7
	=dev-java/xml-commons-external-1.3*
	>=dev-db/hsqldb-1.8.0.9
	=dev-java/rhino-1.5* )
	mono? ( >=dev-lang/mono-1.2.3.1 )
	opengl? ( virtual/opengl
		virtual/glu )
	xulrunner? ( >=net-libs/xulrunner-1.8
		>=dev-libs/nspr-4.6.6
		>=dev-libs/nss-3.11-r1 )
	!xulrunner? ( firefox? ( >=dev-libs/nspr-4.6.6
		>=dev-libs/nss-3.11-r1 ) )
	!xulrunner? ( !firefox? ( seamonkey? ( =www-client/seamonkey-1*
		>=dev-libs/nspr-4.6.6
		>=dev-libs/nss-3.11-r1 ) ) )
	>=net-misc/neon-0.24.7
	>=dev-libs/openssl-0.9.8g
	>=x11-libs/startup-notification-0.5
	>=media-libs/freetype-2.1.10-r2
	>=media-libs/fontconfig-2.3.0
	cups? ( net-print/cups )
	media-libs/jpeg
	media-libs/libpng
	app-arch/zip
	app-arch/unzip
	>=app-text/hunspell-1.1.4-r1
	>=app-admin/eselect-oodict-20060706
	dev-libs/expat
	>=dev-libs/icu-3.8
	>=sys-libs/db-4.3
	>=app-text/libwpd-0.8.8
	>=media-libs/libsvg-0.1.4
	>=media-libs/vigra-1.4
	linguas_ja? ( >=media-fonts/kochi-substitute-20030809-r3 )
	linguas_zh_CN? ( >=media-fonts/arphicfonts-0.1-r2 )
	linguas_zh_TW? ( >=media-fonts/arphicfonts-0.1-r2 )"

RDEPEND="java? ( >=virtual/jre-1.4 )
	!xulrunner? ( firefox? ( || ( =www-client/mozilla-firefox-2*
		=www-client/mozilla-firefox-bin-2* ) ) )
	${COMMON_DEPEND}"

DEPEND="${COMMON_DEPEND}
	x11-libs/libXrender
	x11-proto/printproto
	x11-proto/xextproto
	x11-proto/xproto
	x11-proto/xineramaproto
	>=sys-apps/findutils-4.1.20-r1
	dev-perl/Archive-Zip
	virtual/perl-Compress-Zlib
	>=virtual/perl-Compress-Raw-Zlib-2.002
	virtual/perl-IO-Compress-Base
	dev-util/pkgconfig
	dev-util/intltool
	>=dev-libs/boost-1.33.1
	sys-devel/flex
	sys-devel/bison
	dev-libs/libxslt
	>=dev-libs/libxml2-2.0
	!xulrunner? ( firefox? ( =www-client/mozilla-firefox-2* ) )
	>=dev-util/gperf-3
	>=net-misc/curl-7.12
	sys-libs/zlib
	sys-apps/coreutils
	media-gfx/imagemagick
	pam? ( sys-libs/pam )
	!dev-util/dmake
	>=dev-lang/python-2.3.4
	java? ( || ( =virtual/jdk-1.6* =virtual/jdk-1.5* =virtual/jdk-1.4* )
		dev-java/ant-core )
	ldap? ( net-nds/openldap )
	virtual/postgresql-base"

PROVIDE="virtual/ooo"
RESTRICT="strip" # the openoffice.org from infra-resource is already stripped

pkg_setup() {

	ewarn
	ewarn " It is important to note that OpenOffice-Infra is a very fragile  "
	ewarn " build when it comes to CFLAGS.  A number of flags have already "
	ewarn " been filtered out.  If you experience difficulty merging this  "
	ewarn " package and use agressive CFLAGS, lower the CFLAGS and try to  "
	ewarn " merge again. Also note that building OOo takes a lot of time and "
	ewarn " hardware ressources: 4-6 GB free diskspace and 256 MB RAM are "
	ewarn " the minimum requirements. If you have less, use openoffice-infra-bin "
	ewarn " instead. "
	ewarn

	# Check if we have enough RAM and free diskspace to build this beast
	CHECKREQS_MEMORY="512"
	use debug && CHECKREQS_DISK_BUILD="8192" || CHECKREQS_DISK_BUILD="5120"
	check_reqs

	strip-linguas ${LANGS}

	if [[ -z "${LINGUAS}" ]]; then
		export LINGUAS_OOO="en-US"
		ewarn
		ewarn " To get a localized build, set the according "
		ewarn " LINGUAS variable(s). LINGUAS=ru for example. "
		ewarn
	else
		export LINGUAS_OOO=`echo ${LINGUAS} | \
			sed -e 's/\ben\b/en_US/g' -e 's/_/-/g'`
	fi

	if [[ "${#LINGUAS_OOO}" ==  "2" ]]; then
		export BASELNG="${LINGUAS_OOO}"
	else
		export BASELNG="en-US"
	fi

	if use !java; then
		ewarn " You are building with java-support disabled, this results in some "
		ewarn " of the OpenOffice.org functionality (i.e. help) being disabled. "
		ewarn " If something you need does not work for you, rebuild with "
		ewarn " java in your USE-flags. "
		ewarn
	fi

	if is-flagq -ffast-math ; then
		eerror " You are using -ffast-math, which is known to cause problems. "
		eerror " Please remove it from your CFLAGS, using this globally causes "
		eerror " all sorts of problems. "
		eerror " After that you will also have to - at least - rebuild python otherwise "
		eerror " the openoffice build will break. "
		die
	fi

	if use pam; then
		if ! built_with_use sys-apps/shadow pam; then
			eerror " shadow needs to be built with pam-support. "
			eerror " rebuild it accordingly or remove the pam use-flag "
			die
		fi
	fi

	if use xulrunner; then
		if pkg-config --exists xulrunner-xpcom; then
			XULR="xulrunner"
		elif pkg-config --exists libxul; then
			XULR="libxul"
		else
			die "USE flag [xulrunner] set but not found!"
		fi
	fi

	# Check python
	if ! built_with_use dev-lang/python threads
	then
	    eerror "Python needs to be built with threads."
	    die
	fi

	java-pkg-opt-2_pkg_setup

	# sys-libs/db version used
	local db_ver="$(db_findver '>=sys-libs/db-4.3')"

}

src_unpack() {

	unpack infra-ooo-files_${PV}.tar.gz
	unpack ${SRC}_system.tar.bz2
	unpack ${SRC}_core.tar.bz2
	unpack ${SRC}_binfilter.tar.bz2
	unpack ${SRC}_l10n.tar.bz2

	# Some fixes for our patchset
	cd "${S}"
	epatch "${FILESDIR}/${PV}/gentoo-scripts.diff"
	# Missing includes for amd64 gcc43
	cp -f "${FILESDIR}/${PV}/build-gcc43-missingincludes.diff" "${WORKDIR}"/infra-ooo-files_${PV}/patches/src680/
	# Patch for using Gentoo specific goo team patches and GentooInfra distro target
	epatch "${FILESDIR}/${PV}/gentoo-gentooinfra.diff"

	mkdir -p "${WORKSRC}"/solver/680/unxlng${ARCH_VAR}6.pro/pck/
	cp -f "${WORKDIR}"/infra-ooo-files_${PV}/files/extra_templates_*.zip "${WORKSRC}"/solver/680/unxlng${ARCH_VAR}6.pro/pck/

	cd "${WORKSRC}"; rm -rf "extras/source/autotext/lang/ru/*" ; tar xjf "${WORKDIR}/infra-ooo-files_${PV}/files/extras_ru.tar.bz2"
	cd "${WORKSRC}"; tar xjf "${WORKDIR}/infra-ooo-files_${PV}/files/oox.2008-02-29.tar.bz2"

	"${WORKDIR}"/infra-ooo-files_${PV}/bin/enable-dict ru_RU "${WORKDIR}"/infra-ooo-files_${PV}/files/dict_ru_RU.tar.bz2  ${WORKSRC}
	"${WORKDIR}"/infra-ooo-files_${PV}/bin/enable-dict de_DE "${WORKDIR}"/infra-ooo-files_${PV}/files/dict_de_DE.tar.bz2  ${WORKSRC}
	"${WORKDIR}"/infra-ooo-files_${PV}/bin/enable-dict uk_UA "${WORKDIR}"/infra-ooo-files_${PV}/files/dict_uk_UA.tar.bz2  ${WORKSRC}
	"${WORKDIR}"/infra-ooo-files_${PV}/bin/enable-dict fr_FR "${WORKDIR}"/infra-ooo-files_${PV}/files/dict_fr_FR.tar.bz2  ${WORKSRC}
	mkdir -p "${WORKSRC}"/mdbtools/download/
	mkdir -p "${WORKSRC}"/libwps/download/
	mkdir -p "${WORKSRC}"/libwpg/download/
	mkdir -p "${WORKSRC}"/libwpd/download/
	mkdir -p "${WORKSRC}"/libsvg/download/
	mkdir -p "${WORKSRC}"/default_images/sw/res/
	mkdir -p "${WORKSRC}"/ooo_custom_images/nologo/introabout/
	mkdir -p "${WORKSRC}"/default_images/introabout/
	cp -f "${WORKDIR}"/infra-ooo-files_${PV}/files/mdbtools*.tar.gz "${WORKSRC}"/mdbtools/download/
	cp -f "${WORKDIR}"/infra-ooo-files_${PV}/files/libwps*.tar.gz   "${WORKSRC}"/libwps/download/
	cp -f "${WORKDIR}"/infra-ooo-files_${PV}/files/libwpg*.tar.gz   "${WORKSRC}"/libwpg/download/
	cp -f "${WORKDIR}"/infra-ooo-files_${PV}/files/libwpd*.tar.gz   "${WORKSRC}"/libwpd/download/
	cp -f "${WORKDIR}"/infra-ooo-files_${PV}/files/libsvg*.tar.gz   "${WORKSRC}"/libsvg/download/
	cp -f "${WORKDIR}"/infra-ooo-files_${PV}/files/infra-logo.png   "${WORKSRC}"/default_images/sw/res/
	cp -f "${WORKDIR}"/infra-ooo-files_${PV}/files/go-oo-team.png   "${WORKSRC}"/default_images/sw/res/
	cp -f "${WORKDIR}"/infra-ooo-files_${PV}/res/infra/intro.bmp    "${WORKSRC}"/ooo_custom_images/nologo/introabout/
	cp -f "${WORKDIR}"/infra-ooo-files_${PV}/res/infra/about.bmp    "${WORKSRC}"/default_images/introabout/

	local patchconf
	patchconf="--tag=${OOOBUILDTAG} --distro=GentooInfra --distro=Localize"
	if use binfilter; then
	    patchconf="${patchconf} --distro=Binfilter"
	fi
	"${WORKDIR}"/infra-ooo-files_${PV}/bin/apply.pl  "${WORKDIR}"/infra-ooo-files_${PV}/patches/src680 ${WORKSRC} ${patchconf}
	"${WORKDIR}"/infra-ooo-files_${PV}/bin/transform --apply "${WORKDIR}"/infra-ooo-files_${PV} ${WORKSRC}

	cp -f "${DISTDIR}"/unowinreg.dll "${WORKSRC}"/external/unowinreg/

	# workaround for x86/~x86 hunspell
	export HUNSPELL_LIBS=$(echo "$(pkg-config hunspell --libs)" | sed 's|/|\\/|g')

	# missing macolor1/macolor2 properties patch 
	epatch "${FILESDIR}/${PV}/gentoo-macolor.diff"
	# completion_matches -> rl_completion_matches
	epatch "${FILESDIR}/${PV}/gentoo-completion_matches.diff"
	# enable/disable-gstreamer, disable scanning for rpm/dpkg and etc
	epatch "${FILESDIR}/${PV}/gentoo-configure.diff"
	# disable mkdepend warning
	epatch "${FILESDIR}/${PV}/gentoo-mkdepend.diff"
	# fix buildroot issue for rpm >=4.4.7
	epatch "${FILESDIR}/gentoo-epm-3.7.patch.diff"
	# fix handling of system libs for postgresql-base
	epatch "${FILESDIR}/gentoo-system_pgsql.diff"
	# fix sandbox
	epatch "${FILESDIR}/${PV}/gentoo-fixsandbox.diff"
	# fix python 2.3.4 build
	epatch "${FILESDIR}/${PV}/gentoo-python-2.3.4.diff"

	# Use flag checks
	if use java; then
		CONFIGURE_ARGS="${CONFIGURE_ARGS} --with-ant-home=${ANT_HOME}"
		CONFIGURE_ARGS="${CONFIGURE_ARGS} --with-jdk-home=$(java-config --jdk-home 2>/dev/null)"
		CONFIGURE_ARGS="${CONFIGURE_ARGS} --with-java-target-version=$(java-pkg_get-target)"
		CONFIGURE_ARGS="${CONFIGURE_ARGS} --with-system-beanshell"
		CONFIGURE_ARGS="${CONFIGURE_ARGS} --with-system-xalan"
		CONFIGURE_ARGS="${CONFIGURE_ARGS} --with-system-xerces"
		CONFIGURE_ARGS="${CONFIGURE_ARGS} --with-system-xml-apis"
		CONFIGURE_ARGS="${CONFIGURE_ARGS} --with-system-hsqldb"
		CONFIGURE_ARGS="${CONFIGURE_ARGS} --with-beanshell-jar=$(java-pkg_getjar bsh bsh.jar)"
		CONFIGURE_ARGS="${CONFIGURE_ARGS} --with-serializer-jar=$(java-pkg_getjar xalan-serializer serializer.jar)"
		CONFIGURE_ARGS="${CONFIGURE_ARGS} --with-xalan-jar=$(java-pkg_getjar xalan xalan.jar)"
		CONFIGURE_ARGS="${CONFIGURE_ARGS} --with-xerces-jar=$(java-pkg_getjar xerces-2 xercesImpl.jar)"
		CONFIGURE_ARGS="${CONFIGURE_ARGS} --with-xml-apis-jar=$(java-pkg_getjar xml-commons-external-1.3 xml-apis.jar)"
		CONFIGURE_ARGS="${CONFIGURE_ARGS} --with-hsqldb-jar=$(java-pkg_getjar hsqldb hsqldb.jar)"
	fi

	if use firefox || use seamonkey || use xulrunner; then
		CONFIGURE_ARGS="${CONFIGURE_ARGS} --enable-mozilla"
		local browser
		use seamonkey && browser="seamonkey"
		use firefox && browser="firefox"
		use xulrunner && browser="${XULR}"
		CONFIGURE_ARGS="${CONFIGURE_ARGS} --with-system-mozilla=${browser}"
	else
		CONFIGURE_ARGS="${CONFIGURE_ARGS} --disable-mozilla"
		CONFIGURE_ARGS="${CONFIGURE_ARGS} --without-system-mozilla"
	fi

	CONFIGURE_ARGS="${CONFIGURE_ARGS} `use_enable binfilter`"
	CONFIGURE_ARGS="${CONFIGURE_ARGS} `use_enable cups`"
	CONFIGURE_ARGS="${CONFIGURE_ARGS} `use_enable dbus`"
	CONFIGURE_ARGS="${CONFIGURE_ARGS} `use_enable eds evolution2`"
	CONFIGURE_ARGS="${CONFIGURE_ARGS} `use_enable gnome gnome-vfs`"
	CONFIGURE_ARGS="${CONFIGURE_ARGS} `use_enable gnome lockdown`"
	CONFIGURE_ARGS="${CONFIGURE_ARGS} `use_enable gnome systray`"
	CONFIGURE_ARGS="${CONFIGURE_ARGS} `use_enable gstreamer`"
	CONFIGURE_ARGS="${CONFIGURE_ARGS} `use_enable ldap`"
	CONFIGURE_ARGS="${CONFIGURE_ARGS} `use_enable opengl`"
	CONFIGURE_ARGS="${CONFIGURE_ARGS} `use_with ldap openldap`"
	CONFIGURE_ARGS="${CONFIGURE_ARGS} --enable-neon"
	CONFIGURE_ARGS="${CONFIGURE_ARGS} --with-system-neon"
	CONFIGURE_ARGS="${CONFIGURE_ARGS} --with-system-openssl"

	CONFIGURE_ARGS="${CONFIGURE_ARGS} `use_enable debug crashdump`"

	# Original branding results in black splash screens for some, so forcing ours
	CONFIGURE_ARGS="${CONFIGURE_ARGS} --with-intro-bitmaps=\\\"${WORKSRC}/ooo_custom_images/nologo/introabout/intro.bmp\\\""

	export CONFIGURE_ARGS

	cd ${WORKSRC}/config_office
	eautoreconf

}

src_compile() {

	# Should the build use multiprocessing? Not enabled by default, as it tends to break
	export JOBS="1"
	if [[ "${WANT_MP}" == "true" ]]; then
	    export JOBS=`echo "${MAKEOPTS}" | sed -e "s/.*-j\([0-9]\+\).*/\1/"`
	fi

	# Compile problems with these ...
	filter-flags "-funroll-loops"
	filter-flags "-fprefetch-loop-arrays"
	filter-flags "-fno-default-inline"
	filter-flags "-fstack-protector"
	filter-flags "-fstack-protector-all"
	filter-flags "-ftracer"
	filter-flags "-fforce-addr"
	replace-flags "-O?" "-O2"
	# not very clever to disable warning, but ... users afraid it
	append-flags "-Wno-implicit"
	append-flags "-fno-strict-aliasing"

	# Build with NVidia cards breaks otherwise
	use opengl && append-flags "-DGL_GLEXT_PROTOTYPES"

	# Now for our optimization flags ...
	export ARCH_FLAGS="${CXXFLAGS}"
	use debug || export LINKFLAGSOPTIMIZE="${LDFLAGS}"

	# Make sure gnome-users get gtk-support
	local GTKFLAG="--disable-gtk --disable-cairo"
	( use gtk || use gnome ) && GTKFLAG="--enable-gtk --enable-cairo"

	use kde && set-kdedir 3

	# workaround for --with-system-*
	export PKG_CONFIG=pkg-config

	cd "${WORKSRC}/config_office"

	./configure \
		--srcdir="${DISTDIR}" \
		--with-lang="${LINGUAS_OOO}" \
		--with-build-version=${OOOTAG} \
		${GTKFLAG} \
		`use_enable mono` \
		`use_enable kde` \
		`use_enable pam` \
		`use_enable debug symbols` \
		`use_enable odk` \
		`use_with java` \
		--with-system-freetype \
		--with-system-libxml \
		--with-system-libwpd \
		--with-system-hunspell \
		--disable-fontooo \
		--disable-qadevooo \
		--enable-sdext \
		--with-system-boost \
		--with-system-curl \
		--with-system-db \
		--with-system-expat \
		--with-system-icu \
		--with-system-libxslt \
		--with-system-vigra \
		--without-stlport \
		--mandir=/usr/share/man \
		--libdir=/usr/$(get_libdir) \
		--with-use-shell=bash \
		--with-epm=internal \
		--with-package-format=native \
		--with-vendor="Infra-Resource" \
		${CONFIGURE_ARGS} \
		|| die "Configuration failed!"

	einfo "Building OpenOffice-Infra..."

	cd "${WORKSRC}"

	if [[ "${ARCH}" == "amd64" ]]; then
	    GENTOO_ENV_SET="${WORKSRC}/LinuxX86-64Env.Set.sh"
	else
	    GENTOO_ENV_SET="${WORKSRC}/LinuxX86Env.Set.sh"
	fi

	source "${GENTOO_ENV_SET}"

	./bootstrap

	cd transex3; build.pl -P${JOBS} --all && deliver.pl

	cd "${WORKSRC}"

	if [[ "${BASELNG}" == "ru" || "${BASELNG}" == "uk" ]]; then
	    [ -f "${WORKDIR}"/infra-ooo-files_${PV}/sdf/${BASELNG}/${BASELNG}.sdf ] && "${WORKSRC}"/transex3/scripts/localize -m -l ${BASELNG} -f "${WORKDIR}"/infra-ooo-files_${PV}/sdf/${BASELNG}/${BASELNG}.sdf
	    [ -f "${WORKDIR}"/infra-ooo-files_${PV}/sdf/${BASELNG}/${BASELNG}-vendor.sdf ] && "${WORKSRC}"/transex3/scripts/localize -m -l ${BASELNG} -f "${WORKDIR}"/infra-ooo-files_${PV}/sdf/${BASELNG}/${BASELNG}-vendor.sdf
	fi
	if [[ "${BASELNG}" == "ru" ]]; then
	    [ -f "${WORKDIR}"/infra-ooo-files_${PV}/sdf/${BASELNG}/${BASELNG}-patched.sdf ] && "${WORKSRC}"/transex3/scripts/localize -m -l ${BASELNG} -f "${WORKDIR}"/infra-ooo-files_${PV}/sdf/${BASELNG}/${BASELNG}-patched.sdf
	fi

	if [[ "${JOBS}" != "1" ]]; then
	    cd instsetoo_native ; build.pl -P${JOBS} --all || die "Build failed"
	else
	    dmake || die "Build failed"
	fi

	unset PYTHONPATH
	unset PYTHONHOME

}

src_install() {

	einfo "Preparing Installation"

	local gentoo_env_set_dst

	if [[ "${ARCH}" == "amd64" ]]; then
		gentoo_env_set_dst="linux-2.6-x86_64"
	else
		gentoo_env_set_dst="linux-2.6-intel"
	fi

	local instdir="/usr/$(get_libdir)/openoffice"
	local basecomponents="base calc draw impress math writer"
	local allcomponents

	if use cups; then
	    allcomponents="${basecomponents} extension printeradmin"
	else
	    allcomponents="${basecomponents} extension"
	fi

	dodir "${instdir}"

	cp -af "${WORKSRC}"/instsetoo_native/unxlng"${ARCH_VAR}"6.pro/OpenOffice/native/install/"${BASELNG}"/"${gentoo_env_set_dst}"/buildroot/opt/openoffice.org2.4/* \
		"${D}"${instdir}

	for i in ${LINGUAS_OOO}; do
	    cp -af "${WORKSRC}"/instsetoo_native/unxlng"${ARCH_VAR}"6.pro/OpenOffice_languagepack/native/install/"${i}"/"${gentoo_env_set_dst}"/buildroot/opt/openoffice.org2.4/* \
		"${D}"${instdir}
	done

	# oodict
	if use !oodict; then
	    rm -rf "${D}"${instdir}/share/dict/ooo/*.dic
	    rm -rf "${D}"${instdir}/share/dict/ooo/*.aff
	fi

	# Menu entries
	cd "${D}"${instdir}/share/xdg/

	for i in ${allcomponents}; do
		if [[ "${i}" == "printeradmin" ]]; then
		    sed -i -e s/openoffice.org2.4-/oo/g "${i}".desktop || die "Sed failed"
		else
		    sed -i -e s/openoffice.org2.4/ooffice/g "${i}".desktop || die "Sed failed"
		fi
		if [[ "${i}" == "draw" ]]; then
		    sed -i -e "s/Name\=OpenOffice\.org 2\.4 Draw/Name\=OpenOffice\.org 2\.4 Draw\nGenericName\=Draw\nGenericName[ru]\=Рисунки, блок-схемы и логотипы/g" \
		    "${i}".desktop || die "Sed failed"
		fi
		if [[ "${i}" == "math" ]]; then
		    sed -i -e "s/Name\=OpenOffice\.org 2\.4 Math/Name\=OpenOffice\.org 2\.4 Math\nGenericName\=Math\nGenericName[ru]\=Формулы и уравнения/g" \
		    "${i}".desktop || die "Sed failed"
		fi
		domenu "${i}".desktop
	done

	# Icons
	insinto /usr/share/icons
	doins -r "${WORKSRC}"/sysui/desktop/icons/{hicolor,locolor}
	find "${D}"/usr/share/icons -name 'CVS' | xargs rm -rf
	for color in {hicolor,locolor}; do
	    for sizes in "${D}"usr/share/icons/${color}/* ; do
		for i in ${allcomponents}; do
		    [[ -f "${sizes}"/apps/"${i}".png ]] && mv "${sizes}"/apps/"${i}".png "${sizes}"/apps/openofficeorg24-"${i}".png
		done
	    done
	done

	# Gnome icons
	if use gnome; then
	    mkdir -p "${D}"/usr/share/icons/gnome
	    for size in {16x16,32x32,48x48}; do
		if ! [[ -d "${D}"/usr/share/icons/gnome/"${size}" ]]; then
		    mkdir -p "${D}"/usr/share/icons/gnome/"${size}"
		    mkdir -p "${D}"/usr/share/icons/gnome/"${size}/apps"
		fi
		for i in ${allcomponents}; do
		    dosym /usr/share/icons/hicolor/"${size}"/apps/openofficeorg24-"${i}".png /usr/share/icons/gnome/"${size}"/apps/openofficeorg24-"${i}".png
		done
	    done
	fi

	for i in ${allcomponents}; do
	    dosym /usr/share/icons/hicolor/48x48/apps/openofficeorg24-"${i}".png /usr/share/pixmaps/openofficeorg24-"${i}".png
	done

	# Mime types
	insinto /usr/share/mime/packages
	doins "${WORKSRC}"/sysui/unxlng"${ARCH_VAR}"6.pro/misc/openoffice.org/openoffice.org.xml

	# Install wrapper script
	newbin "${FILESDIR}"/wrapper.in ooffice
	sed -i -e s/LIBDIR/$(get_libdir)/g "${D}"/usr/bin/ooffice || die "Wrapper script failed"

	# Component symlinks
	for i in ${basecomponents}; do
	    dosym "${instdir}"/program/s"${i}" /usr/bin/oo"${i}"
	done

	if use cups; then
	    dosym "${instdir}"/program/spadmin.bin /usr/bin/ooprinteradmin
	fi
	dosym "${instdir}"/program/soffice /usr/bin/soffice
	dosym "${instdir}"/program/unopkg  /usr/bin/unopkg

	# Install extensions: Sun Report Builder and Sun Presentation Minimizer
	insinto "${instdir}"/share/extension/install
	doins "${WORKSRC}"/solver/680/unxlng"${ARCH_VAR}"6.pro/bin/sun-report-builder.oxt
	doins "${WORKSRC}"/solver/680/unxlng"${ARCH_VAR}"6.pro/bin/minimizer/sun-presentation-minimizer.oxt

	# Fix the permissions for security reasons
#	chown -R root:0 "${D}"

	# Fix lib handling for internal old python 2.3
	if [[ ! -e /usr/$(get_libdir)/libpython2.3.so.1.0 ]]; then
	    dolib.so "${D}"${instdir}/program/libpython2.3.so.1.0
	fi

	# Non-java weirdness see bug #99366
	use !java && rm -f "${D}"${instdir}/program/javaldx

	# record java libraries
	use java && java-pkg_regjar "${D}"/usr/$(get_libdir)/openoffice/program/classes/*.jar

	# install java-set-classpath
	if use java; then
	    insinto /usr/$(get_libdir)/openoffice/program
	    newins "${FILESDIR}/java-set-classpath.in" java-set-classpath
	    fperms 755 /usr/$(get_libdir)/openoffice/program/java-set-classpath
	fi

}

pkg_postinst() {

	fdo-mime_desktop_database_update
	fdo-mime_mime_database_update

	use !oodict && eselect oodict update --libdir $(get_libdir)

	[[ -x /sbin/chpax ]] && [[ -e /usr/$(get_libdir)/openoffice/program/soffice.bin ]] && chpax -zm /usr/$(get_libdir)/openoffice/program/soffice.bin

	# Add available & useful jars to openoffice classpath
	use java && /usr/$(get_libdir)/openoffice/program/java-set-classpath $(java-config --classpath=jdbc-mysql 2>/dev/null) >/dev/null

	elog " To start OpenOffice-Infra, run:"
	elog
	elog " $ ooffice"
	elog
	elog " Also, for individual components, you can use any of:"
	elog
	elog " oobase, oocalc, oodraw, ooimpress, oomath or oowriter"
	elog
	elog " You can find extension in: /usr/$(get_libdir)/openoffice/share/extension/install "
	elog
	use !oodict && elog " Spell checking is now provided through our own myspell-ebuilds, "
	use !oodict && elog " if you want to use it, please install the correct myspell package "
	use !oodict && elog " according to your language needs. "
	use !oodict && elog " For example, for myspell and the russian language You should do "
	use !oodict && elog
	use !oodict && elog " emerge -av myspell-ru "
	use !oodict && elog " eselect oodict set myspell-ru"
	use !oodict && elog
	use !oodict && elog " If You do not like it re-emerge the package with "
	use !oodict && elog " USE=\"oodict\" "

}

pkg_postrm() {

	fdo-mime_desktop_database_update
	fdo-mime_mime_database_update

	use !oodict && [[ ! -e /usr/$(get_libdir)/openoffice/program/soffice.bin ]] && rm -rf /usr/$(get_libdir)/openoffice

}
