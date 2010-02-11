# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

WANT_AUTOMAKE="1.9"
EAPI="2"

inherit autotools check-reqs db-use eutils fdo-mime flag-o-matic java-pkg-opt-2 mono multilib toolchain-funcs

IUSE="binfilter cups dbus debug eds gnome gstreamer gtk ldap mono nsplugin odk +infradicts opengl pam +postgres"

PATCHLEVEL="OOO310"
MILESTONE="11"
OOOTAG=${PATCHLEVEL}_m${MILESTONE}
OOOBUILDTAG=ooo310-m${MILESTONE}

SRC=OOo_${PV}_src
S=${WORKDIR}/infra-ooo-files_${PV}
WORKSRC=${WORKDIR}/${OOOTAG}
BASIS=basis3.1
DESCRIPTION="OpenOffice-Infra, office suite with enhanced Russian support from Infra-Resource"

SRC_URI="binfilter? ( mirror://openoffice/stable/${PV}/${SRC}_binfilter.tar.bz2 )
	mirror://openoffice/stable/${PV}/${SRC}_core.tar.bz2
	mirror://openoffice/stable/${PV}/${SRC}_l10n.tar.bz2
	mirror://openoffice/stable/${PV}/${SRC}_extensions.tar.bz2
	mirror://openoffice/stable/${PV}/${SRC}_system.tar.bz2
	odk? ( java? ( http://tools.openoffice.org/unowinreg_prebuild/680/unowinreg.dll ) )
	http://download.i-rs.ru/pub/openoffice/${PV}/ru/infra-ooo-files_${PV}.tar.gz"

LANGS1="ru tr uk"
LANGS="${LANGS1} en en_US"

# proper linguas handling
for X in ${LANGS} ; do
	IUSE="${IUSE} linguas_${X}"
done

HOMEPAGE="http://www.i-rs.ru/ http://www.go-oo.org/"

LICENSE="LGPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"

COMMON_DEPEND="!app-office/openoffice-infra-bin
	!app-office/openoffice
	!app-office/openoffice-bin
	x11-libs/libXaw
	x11-libs/libXinerama
	x11-libs/libXrandr
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
	java? ( >=dev-java/bsh-2.0_beta4
		>=dev-db/hsqldb-1.8.0.9 )
	mono? ( || ( >dev-lang/mono-2.4-r1 <dev-lang/mono-2.4 ) )
	nsplugin? ( || ( net-libs/xulrunner:1.8 net-libs/xulrunner:1.9 =www-client/seamonkey-1* )
		>=dev-libs/nspr-4.6.6
		>=dev-libs/nss-3.11-r1 )
	opengl? ( virtual/opengl
		virtual/glu )
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
	dev-libs/expat
	>=dev-libs/icu-3.8
	>=sys-libs/db-4.3
	>=app-text/libwpd-0.8.8
	>=media-libs/vigra-1.4
	>=app-text/poppler-0.12.3-r3"

RDEPEND="java? ( >=virtual/jre-1.5 )
	${COMMON_DEPEND}"

DEPEND="${COMMON_DEPEND}
	x11-libs/libXrender
	x11-libs/libXtst
	x11-proto/printproto
	x11-proto/xextproto
	x11-proto/xproto
	x11-proto/xineramaproto
	>=sys-apps/findutils-4.1.20-r1
	dev-perl/Archive-Zip
	virtual/perl-IO-Compress
	dev-util/pkgconfig
	dev-util/intltool
	>=dev-libs/boost-1.33.1
	sys-devel/flex
	sys-devel/bison
	dev-libs/libxslt
	>=dev-libs/libxml2-2.0
	>=dev-util/gperf-3
	>=net-misc/curl-7.12
	sys-libs/zlib
	sys-apps/coreutils
	pam? ( sys-libs/pam
		sys-apps/shadow[pam] )
	!dev-util/dmake
	>=dev-lang/python-2.3.4[threads]
	java? ( || ( =virtual/jdk-1.6* =virtual/jdk-1.5* )
		>=dev-java/ant-core-1.7 )
	ldap? ( net-nds/openldap )
	postgres? ( virtual/postgresql-base )"

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
	ewarn
	ewarn " Also if you experience a build break, please make sure to retry "
	ewarn " with MAKEOPTS="-j1" before filing a bug. "
	ewarn

	# Check if we have enough RAM and free diskspace to build this beast
	CHECKREQS_MEMORY="512"
	use debug && CHECKREQS_DISK_BUILD="8192" || CHECKREQS_DISK_BUILD="6144"
	check_reqs

	strip-linguas ${LANGS}

	if [[ -z "${LINGUAS}" ]]; then
		export LINGUAS_OOO="en-US"
		ewarn
		ewarn " To get a localized build, set the according "
		ewarn " LINGUAS variable(s). LINGUAS=ru for example. "
		ewarn
	else
		export LINGUAS_OOO=$(echo ${LINGUAS} | sed -e 's/\ben\b/en_US/g;s/_/-/g')
	fi

	# dicts
	if use infradicts; then
		export DICTS_OOO="en ru uk"
	else
		for i in ${LINGUAS_OOO}; do
			if [[ "${i}" != "tr" ]]; then
				if [[ "${i}" == "en-US" ]]; then
					DICTS_OOO="${DICTS_OOO} en"
				else
					DICTS_OOO="${DICTS_OOO} ${i}"
				fi
			fi
		done
		export DICTS_OOO
	fi

	if use !java; then
		ewarn
		ewarn " You are building with java-support disabled, this results in some "
		ewarn " of the OpenOffice-Infra functionality (i.e. help) being disabled. "
		ewarn " If something you need does not work for you, rebuild with "
		ewarn " java in your USE-flags. "
		ewarn
	fi

	if use !gtk && use !gnome; then
		ewarn
		ewarn " If you want the OpenOffice-Infra systray quickstarter to work "
		ewarn " activate the 'gtk' and 'gnome' use flags. "
		ewarn
	fi

	if is-flagq -ffast-math ; then
		eerror
		eerror " You are using -ffast-math, which is known to cause problems. "
		eerror " Please remove it from your CFLAGS, using this globally causes "
		eerror " all sorts of problems. "
		eerror " After that you will also have to - at least - rebuild python otherwise "
		eerror " the openoffice-infra build will break. "
		die
	fi

	if use nsplugin; then
		if pkg-config --exists libxul; then
			BRWS="libxul"
		elif pkg-config --exists xulrunner-xpcom; then
			BRWS="xulrunner"
		elif pkg-config --exists seamonkey-xpcom; then
			BRWS="seamonkey"
		else
			die "USE flag [nsplugin] set but no installed xulrunner or seamonkey found!"
		fi
	fi

	java-pkg-opt-2_pkg_setup

	# sys-libs/db version used
	local db_ver=$(db_findver '>=sys-libs/db-4.3')
}

src_unpack() {
	unpack infra-ooo-files_${PV}.tar.gz
	use binfilter && unpack ${SRC}_binfilter.tar.bz2
	unpack ${SRC}_core.tar.bz2
	unpack ${SRC}_l10n.tar.bz2
	unpack ${SRC}_extensions.tar.bz2
	unpack ${SRC}_system.tar.bz2
}

src_prepare() {
	if use odk && use java; then
		cp -f "${DISTDIR}"/unowinreg.dll "${WORKSRC}"/external/unowinreg/ || die "cp of unowinreg.dll failed"
	fi

	# Some fixes for our patchset
	cd "${S}"
	epatch "${FILESDIR}/${PV}/gentoo-infra-builder.diff"
	epatch "${FILESDIR}/${PV}/gentoo-layout-simple-dialogs-svx.diff"
	# fix vba parallel build
	epatch "${FILESDIR}/gentoo-vba-parallel-build.diff"
	# Patch for using Gentoo specific goo team patches and InfraGentoo/InfraGentooPG distro targets
	epatch "${FILESDIR}/${PV}/gentoo-infra-gentoo.diff"

	# Patches from go-oo mainstream
	cp -f "${FILESDIR}/buildfix-gcc44.diff" "${S}/patches/hotfixes" || die "cp of hotfix patch failed"

	cd "${WORKSRC}"; tar xjf "${WORKDIR}/infra-ooo-files_${PV}/files/extras-templates.tar.bz2" || die "untar failed"

	for i in ${LINGUAS_OOO}; do
		if [[ "${i}" == "ru" || "${i}" == "tr" ]]; then
			cd "${WORKSRC}"; rm -rf "extras/source/autotext/lang/${i}/*" ; tar xjf "${WORKDIR}/infra-ooo-files_${PV}/files/extras_${i}.tar.bz2" \
			|| die "untar failed"
		fi
	done
	local longlang
	for i in ${DICTS_OOO}; do
		if [[ "${i}" == "ru" || "${i}" == "uk" ]]; then
			if [[ "${i}" == "ru" ]]; then
			    longlang="ru_RU"
			else
			    longlang="uk_UA"
			fi
			"${WORKDIR}"/infra-ooo-files_${PV}/bin/enable-dict "${longlang}" "${WORKDIR}/infra-ooo-files_${PV}/files/dict_${longlang}.tar.bz2" "${WORKSRC}" \
			|| die "enable-dict failed"
		fi
	done

	# Infra branding
	mkdir -p "${WORKSRC}"/{libwps,libwpg,libsvg}/download/ || die "mkdir failed"
	cp -f "${WORKDIR}"/infra-ooo-files_${PV}/files/libwps*.tar.gz   "${WORKSRC}"/libwps/download/ || die "cp of libwps failed"
	cp -f "${WORKDIR}"/infra-ooo-files_${PV}/files/libwpg*.tar.gz   "${WORKSRC}"/libwpg/download/ || die "cp of libwpg failed"
	cp -f "${WORKDIR}"/infra-ooo-files_${PV}/files/libsvg*.tar.gz   "${WORKSRC}"/libsvg/download/ || die "cp of libsvg failed"
	cp -f "${WORKDIR}"/infra-ooo-files_${PV}/files/infra-logo-team.png   "${WORKSRC}"/default_images/sw/res/ || die "cp of *.png failed"
	cp -f "${WORKDIR}"/infra-ooo-files_${PV}/files/go-oo-team.png   "${WORKSRC}"/default_images/sw/res/ || die "cp of *.png failed"
	cp -f "${WORKDIR}"/infra-ooo-files_${PV}/res/infra/intro.bmp    "${WORKSRC}"/ooo_custom_images/nologo/introabout/ || die "cp of *.png failed"
	cp -f "${WORKDIR}"/infra-ooo-files_${PV}/res/infra/about.bmp    "${WORKSRC}"/default_images/introabout/ || die "cp of *.png failed"
	cp -f "${WORKDIR}"/infra-ooo-files_${PV}/res/infra/backing*.png    "${WORKSRC}"/default_images/framework/res/ || die "cp of *.png failed"

	local patchconf
	patchconf="--tag=${OOOBUILDTAG} --distro=Localize"
	local distrodicts
	if use postgres; then
		patchconf="${patchconf} --distro=InfraGentooPG"
	else
		patchconf="${patchconf} --distro=InfraGentoo"
	fi
	use binfilter && patchconf="${patchconf} --distro=Binfilter"
	# add basic support of zemberek/tr
	local dicts="${DICTS_OOO} tr"
	for i in ${dicts}; do
		if [[ "${i}" != "en" ]]; then
			distrodicts="${distrodicts} --distro=InfraDict${i}"
		fi
	done
	[[ -n "${distrodicts}" ]] && patchconf="${patchconf} ${distrodicts}"
	"${WORKDIR}"/infra-ooo-files_${PV}/bin/apply.pl "${WORKDIR}"/infra-ooo-files_${PV}/patches/dev300 "${WORKSRC}" ${patchconf} || die "apply failed"
	"${WORKDIR}"/infra-ooo-files_${PV}/bin/transform --apply "${WORKDIR}"/infra-ooo-files_${PV} "${WORKSRC}" || die "transform failed"

	if use postgres; then
		# fix using of pg lib
		epatch "${FILESDIR}/${PV}/gentoo-configure-pg.diff"
		# fix handling of system libs for postgresql-base
		epatch "${FILESDIR}/gentoo-system_pgsql.diff"
	fi
	# enable/disable-gstreamer, disable scanning for rpm/dpkg and etc
	epatch "${FILESDIR}/${PV}/gentoo-configure.diff"
	# fix mkdepend
	epatch "${FILESDIR}/gentoo-mkdepend.diff"
	# disable rpm
	epatch "${FILESDIR}/gentoo-epm-3.7.patch.diff"
	# don't strip libs
	use debug && epatch "${FILESDIR}/gentoo-dont_strip_libs.diff"
	# fix jfreereport cr issue
	sed -i -e 's/\x0D$//' "${WORKSRC}"/jfreereport/patches/*.patch || die "sed failed"

	cd "${WORKSRC}"

	eautoreconf
}

src_configure() {
	# Use flag checks
	if use java; then
		CONFIGURE_ARGS="${CONFIGURE_ARGS} --with-ant-home=${ANT_HOME}"
		CONFIGURE_ARGS="${CONFIGURE_ARGS} --with-jdk-home=$(java-config --jdk-home 2>/dev/null)"
		CONFIGURE_ARGS="${CONFIGURE_ARGS} --with-java-target-version=$(java-pkg_get-target)"
		CONFIGURE_ARGS="${CONFIGURE_ARGS} --with-jvm-path=/usr/$(get_libdir)/"
		CONFIGURE_ARGS="${CONFIGURE_ARGS} --with-system-beanshell"
		CONFIGURE_ARGS="${CONFIGURE_ARGS} --with-system-hsqldb"
		CONFIGURE_ARGS="${CONFIGURE_ARGS} --with-beanshell-jar=$(java-pkg_getjar bsh bsh.jar)"
		CONFIGURE_ARGS="${CONFIGURE_ARGS} --with-hsqldb-jar=$(java-pkg_getjar hsqldb hsqldb.jar)"
	fi

	if use nsplugin ; then
		CONFIGURE_ARGS="${CONFIGURE_ARGS} --enable-mozilla"
		CONFIGURE_ARGS="${CONFIGURE_ARGS} --with-system-mozilla=${BRWS}"
	else
		CONFIGURE_ARGS="${CONFIGURE_ARGS} --disable-mozilla"
		CONFIGURE_ARGS="${CONFIGURE_ARGS} --without-system-mozilla"
	fi

	# Handle new dicts system
	CONFIGURE_ARGS="${CONFIGURE_ARGS} --with-myspell-dicts"
	local tempdicts=ENUS
	for i in ${DICTS_OOO}; do
		if [[ "${i}" != "en" ]]; then
			tempdicts="${tempdicts},$(ls ${WORKSRC}/dictionaries/ | grep ${i} | sed -e 's/_//g;s/\///g' | tr '[a-z]' '[A-Z]')"
		fi
	done
	CONFIGURE_ARGS="${CONFIGURE_ARGS} --with-dict=${tempdicts}"

	CONFIGURE_ARGS="${CONFIGURE_ARGS} $(use_enable binfilter)"
	CONFIGURE_ARGS="${CONFIGURE_ARGS} $(use_enable cups)"
	CONFIGURE_ARGS="${CONFIGURE_ARGS} $(use_enable dbus)"
	CONFIGURE_ARGS="${CONFIGURE_ARGS} $(use_enable eds evolution2)"
	CONFIGURE_ARGS="${CONFIGURE_ARGS} $(use_enable gnome gconf)"
	CONFIGURE_ARGS="${CONFIGURE_ARGS} $(use_enable gnome gnome-vfs)"
	CONFIGURE_ARGS="${CONFIGURE_ARGS} $(use_enable gnome lockdown)"
	CONFIGURE_ARGS="${CONFIGURE_ARGS} $(use_enable gstreamer)"
	CONFIGURE_ARGS="${CONFIGURE_ARGS} $(use_enable gtk systray)"
	CONFIGURE_ARGS="${CONFIGURE_ARGS} $(use_enable ldap)"
	CONFIGURE_ARGS="${CONFIGURE_ARGS} $(use_enable opengl)"
	CONFIGURE_ARGS="${CONFIGURE_ARGS} $(use_with ldap openldap)"
	CONFIGURE_ARGS="${CONFIGURE_ARGS} $(use_enable debug crashdump)"
	CONFIGURE_ARGS="${CONFIGURE_ARGS} $(use_enable debug strip-solver)"

	# Extension stuff
	CONFIGURE_ARGS="${CONFIGURE_ARGS} --with-extension-integration"
	CONFIGURE_ARGS="${CONFIGURE_ARGS} --enable-minimizer"
	CONFIGURE_ARGS="${CONFIGURE_ARGS} --enable-pdfimport"
	CONFIGURE_ARGS="${CONFIGURE_ARGS} --enable-presenter-console"
	CONFIGURE_ARGS="${CONFIGURE_ARGS} --enable-wiki-publisher"
	CONFIGURE_ARGS="${CONFIGURE_ARGS} --enable-report-builder"

	# Fix kdefilepicker crash on exit
	CONFIGURE_ARGS="${CONFIGURE_ARGS} --with-alloc=system"

	# Original branding results in black splash screens for some, so forcing ours
	CONFIGURE_ARGS="${CONFIGURE_ARGS} --with-intro-bitmaps=\\\"${WORKSRC}/ooo_custom_images/nologo/introabout/intro.bmp\\\""

	# Use multiprocessing by default now, it gets tested by upstream
	export JOBS=$(echo "${MAKEOPTS}" | sed -e "s/.*-j\([0-9]\+\).*/\1/")

	# Compile problems with these ...
	filter-flags "-funroll-loops"
	filter-flags "-fprefetch-loop-arrays"
	filter-flags "-fno-default-inline"
	filter-flags "-fstack-protector"
	filter-flags "-fstack-protector-all"
	filter-flags "-ftracer"
	filter-flags "-fforce-addr"

	filter-flags "-O[s2-9]"

	# not very clever to disable warning, but ... users afraid it
	append-flags "-Wno-implicit"
	append-flags "-fno-strict-aliasing"

	if [[ $(gcc-major-version) -lt 4 ]]; then
		replace-flags "-fomit-frame-pointer" "-momit-leaf-frame-pointer"
	fi

	# Build with NVidia cards breaks otherwise
	use opengl && append-flags "-DGL_GLEXT_PROTOTYPES"

	# Now for our optimization flags ...
	export ARCH_FLAGS="${CXXFLAGS}"
	use debug || export LINKFLAGSOPTIMIZE="${LDFLAGS}"

	# Make sure gnome-users get gtk-support
	local GTKFLAG="--disable-gtk --disable-cairo --without-system-cairo"
	{ use gtk || use gnome; } && GTKFLAG="--enable-gtk --enable-cairo --with-system-cairo"

	# workaround for --with-system-*
	export PKG_CONFIG=pkg-config

	cd "${WORKSRC}"

	# distro-configs are not hooked in infra build, passing configure options as commandline arguments
	./configure \
		--srcdir="${WORKSRC}" \
		--with-lang="${LINGUAS_OOO}" \
		--with-build-version="${OOOTAG}" \
		--disable-kde \
		${GTKFLAG} \
		$(use_enable mono) \
		$(use_enable debug symbols) \
		$(use_enable odk) \
		$(use_enable pam) \
		$(use_with java) \
		--with-system-jpeg \
		--with-system-libxml \
		--with-system-libwpd \
		--with-system-hunspell \
		--disable-fontooo \
		--disable-qadevooo \
		--with-system-boost \
		--with-system-curl \
		--with-system-db \
		--with-system-expat \
		--with-system-icu \
		--with-system-libxslt \
		--with-system-vigra \
		--without-stlport \
		--with-system-zlib \
		--with-system-stdlibs \
		--enable-neon \
		--with-system-neon \
		--enable-xrender-link \
		--with-system-xrender \
		--with-system-openssl \
		--with-system-python \
		--with-vba-package-format=builtin \
		--without-gpc \
		--without-agg \
		--mandir=/usr/share/man \
		--libdir=/usr/$(get_libdir) \
		--with-use-shell=bash \
		--with-epm=internal \
		--with-linker-hash-style=both \
		--with-package-format=native \
		--with-vendor="Infra-Resource" \
		${CONFIGURE_ARGS} \
		|| die "Configuration failed!"
}

src_compile() {
	cd "${WORKSRC}"

	local gentoo_env_set
	if [[ "${ARCH}" == "amd64" ]]; then
		gentoo_env_set="${WORKSRC}/LinuxX86-64Env.Set.sh"
	else
		gentoo_env_set="${WORKSRC}/LinuxX86Env.Set.sh"
	fi

	source "${gentoo_env_set}"

	./bootstrap || die "bootstrap failed"

	cd transex3; build.pl --checkmodules ; build.pl -P${JOBS} --all --html --dontgraboutput -- -P${JOBS} && deliver.pl || die "build.pl failed"

	cd "${WORKSRC}"

	for i in ${LINGUAS_OOO}; do
		if [[ "${i}" == "ru" || "${i}" == "uk" ]]; then
			if [ -f "${WORKDIR}"/infra-ooo-files_${PV}/sdf/${i}/${i}-vendor.sdf ]; then
				"${WORKSRC}"/transex3/scripts/localize -m -l ${i} -f "${WORKDIR}"/infra-ooo-files_${PV}/sdf/${i}/${i}-vendor.sdf || die "localize failed"
			fi
		fi
		if [[ "${i}" == "ru" ]]; then
			if [ -f "${WORKDIR}"/infra-ooo-files_${PV}/sdf/${i}/${i}.sdf ]; then
				"${WORKSRC}"/transex3/scripts/localize -m -l ${i} -f "${WORKDIR}"/infra-ooo-files_${PV}/sdf/${i}/${i}.sdf || die "localize failed"
			fi
			if [ -f "${WORKDIR}"/infra-ooo-files_${PV}/sdf/${i}/${i}-patched.sdf ]; then
				"${WORKSRC}"/transex3/scripts/localize -m -l ${i} -f "${WORKDIR}"/infra-ooo-files_${PV}/sdf/${i}/${i}-patched.sdf || die "localize failed"
			fi
		fi
	done

	if [[ "${JOBS}" != "1" ]]; then
		cd instsetoo_native ;  build.pl --checkmodules ; build.pl -P${JOBS} --all --html --dontgraboutput -- -P${JOBS} || die "Build failed"
	else
		dmake || die "Build failed"
	fi
}

src_install() {
	export PYTHONPATH=""

	einfo "Preparing Installation ..."

	local instdir="/usr/$(get_libdir)/openoffice"
	local basecomponents="base calc draw impress math writer"
	local allcomponents
	local arch_var
	local gentoo_env_set_dst

	if [[ "${ARCH}" == "amd64" ]]; then
		arch_var="x"
		gentoo_env_set_dst="linux-2.6-x86_64"
	else
		arch_var="i"
		gentoo_env_set_dst="linux-2.6-intel"
	fi

	allcomponents="${basecomponents}"
	use cups && allcomponents="${allcomponents} printeradmin"
	{ use gtk || use gnome; } && allcomponents="${allcomponents} qstart"

	dodir "${instdir}"

	cp -af "${WORKSRC}"/instsetoo_native/unxlng"${arch_var}"6.pro/OpenOffice/native/install/en-US/"${gentoo_env_set_dst}"/buildroot/opt/* \
		"${D}"${instdir} || "cp of dist failed"

	for i in ${LINGUAS_OOO}; do
		if [[ "${i}" != "en-US" ]]; then
			cp -af "${WORKSRC}"/instsetoo_native/unxlng"${arch_var}"6.pro/OpenOffice_languagepack/native/install/"${i}"/"${gentoo_env_set_dst}"/buildroot/opt/* \
				"${D}"${instdir} || "cp of langpacks failed"
		fi
	done

	# Menu entries
	cd "${D}"${instdir}/share/xdg/
	for i in ${allcomponents}; do
		if [[ "${i}" == "printeradmin" ]]; then
			sed -i -e s/openoffice.org3-/oo/g "${i}".desktop || die "Sed failed"
		else
			sed -i -e s/openoffice.org3/ooffice/g "${i}".desktop || die "Sed failed"
		fi
		domenu "${i}".desktop
	done

	# Icons
	insinto /usr/share/icons
	doins -r "${WORKSRC}"/sysui/desktop/icons/{hicolor,locolor}
	ecvs_clean "${D}/usr/share/icons"
	for color in {hicolor,locolor}; do
		for sizes in "${D}"usr/share/icons/${color}/* ; do
			for i in ${allcomponents}; do
				if [[ -f "${sizes}"/apps/"${i}".png ]]; then
					mv "${sizes}"/apps/"${i}".png "${sizes}"/apps/openofficeorg3-"${i}".png || die "mv failed"
				fi
			done
		done
	done

	# Gnome icons
	if use gnome; then
		mkdir -p "${D}"/usr/share/icons/gnome
		for size in {16x16,32x32,48x48}; do
			if ! [[ -d "${D}"/usr/share/icons/gnome/"${size}" ]]; then
				mkdir -p "${D}"/usr/share/icons/gnome/"${size}" || die "mkdir failed"
				mkdir -p "${D}"/usr/share/icons/gnome/"${size}/apps"|| die "mkdir failed"
			fi
			for i in ${allcomponents}; do
				dosym /usr/share/icons/hicolor/"${size}"/apps/openofficeorg3-"${i}".png /usr/share/icons/gnome/"${size}"/apps/openofficeorg3-"${i}".png
			done
		done
	fi

	for i in ${allcomponents}; do
		dosym /usr/share/icons/hicolor/48x48/apps/openofficeorg3-"${i}".png /usr/share/pixmaps/openofficeorg3-"${i}".png
	done

	# Mime types
	insinto /usr/share/mime/packages
	doins "${WORKSRC}"/sysui/unxlng"${arch_var}"6.pro/misc/openoffice.org/openoffice.org.xml

	# Install wrapper script
	newbin "${FILESDIR}"/wrapper.in ooffice || die
	sed -i -e s/LIBDIR/$(get_libdir)/g "${D}"/usr/bin/ooffice || die "Wrapper script failed"

	# Component symlinks
	for i in ${basecomponents}; do
		dosym "${instdir}"/program/s"${i}" /usr/bin/oo"${i}"
	done

	use cups && dosym "${instdir}"/program/spadmin /usr/bin/ooprinteradmin
	dosym "${instdir}"/program/soffice /usr/bin/soffice
	dosym "${instdir}"/"${BASIS}"/program/setofficelang /usr/bin/setofficelang
	dosym "${instdir}"/program/unopkg  /usr/bin/unopkg

	# dict extensions
	rm -f "${D}"${instdir}/share/extension/install/dict-*.oxt || die "rm dict-*.oxt failed"
	insinto ${instdir}/share/extension/install
	for i in ${DICTS_OOO}; do
		doins "${WORKSRC}"/dictionaries/unxlng"${arch_var}"6.pro/bin/dict-"${i}".oxt
	done

	# manual install PostgreSQL SDBC extension
	if use postgres; then
		insinto /usr/$(get_libdir)/openoffice/share/extension/install
		doins "${WORKSRC}"/connectivity/unxlng"${arch_var}"6.pro/lib/postgresql-sdbc-0.7.6.zip
		fperms 444 /usr/$(get_libdir)/openoffice/share/extension/install/postgresql-sdbc-0.7.6.zip
	fi

	# manual install Presenter Screen (Console) extension
	cp -f "${WORKSRC}"/sdext/unxlng"${arch_var}"6.pro/bin/presenter-screen.oxt "${D}"${instdir}/share/extension/install/ \
	|| die "cp of presenter-screen failed"

	if use java; then
		# manual install Wiki Publisher, Report Builder extensions
		cp -f "${WORKSRC}"/swext/unxlng"${arch_var}"6.pro/bin/wiki-publisher.oxt "${D}"${instdir}/share/extension/install/ \
		|| die "cp of wiki-publisher failed"
		cp -f "${WORKSRC}"/reportbuilder/unxlng"${arch_var}"6.pro/bin/sun-report-builder.oxt "${D}"${instdir}/share/extension/install/ \
		|| die "cp of sun-report-builder  failed"
		# record java libraries
		java-pkg_regjar "${D}"/usr/$(get_libdir)/openoffice/"${BASIS}"/program/classes/*.jar
		java-pkg_regjar "${D}"/usr/$(get_libdir)/openoffice/ure/share/java/*.jar
		# install java-set-classpath
		insinto /usr/$(get_libdir)/openoffice/"${BASIS}"/program
		newins "${FILESDIR}/java-set-classpath.in" java-set-classpath
		fperms 755 /usr/$(get_libdir)/openoffice/"${BASIS}"/program/java-set-classpath
	else
		# Non-java weirdness see bug #99366
		rm -f "${D}"${instdir}/ure/bin/javaldx || die "rm javaldx failed"
	fi
}

pkg_postinst() {
	fdo-mime_desktop_database_update
	fdo-mime_mime_database_update

	[[ -x /sbin/chpax ]] && [[ -e /usr/$(get_libdir)/openoffice/program/soffice.bin ]] && chpax -zm /usr/$(get_libdir)/openoffice/program/soffice.bin

	# Add available & useful jars to openoffice classpath
	use java && /usr/$(get_libdir)/openoffice/"${BASIS}"/program/java-set-classpath $(java-config --classpath=jdbc-mysql 2>/dev/null) >/dev/null

	elog " To start OpenOffice-Infra, run:"
	elog " $ ooffice"
	elog
	elog " Also, for individual components, you can use any of:"
	elog " oobase, oocalc, oodraw, ooimpress, oomath or oowriter"
	elog
	if use infradicts; then
		elog " If You dont want to build extensions for all bundled dicts from Infra-Resource "
		elog " re-emerge the package with USE=\"-infradicts\" "
		elog
	fi
	elog " Spell checking is now provided through OO own dicts extensions, "
	elog " please install the correct extension from /usr/$(get_libdir)/openoffice/share/extension/install/ "
	elog " via Extension Manager according to your language needs. "
	elog
	elog " Some aditional functionality can be installed via Extension Manager: "
	elog " *) PDF Import "
	elog " *) Presentation Console "
	elog " *) Presentation Minimizer "
	if use java; then
		elog " *) Wiki Publisher "
		elog " *) Report Builder "
	fi
	elog
	elog " Please use the packages provided in "
	elog " /usr/$(get_libdir)/openoffice/share/extension/install/ "
	elog " instead of those from the SUN extension site. "
	if use postgres; then
		elog
		elog " PostgreSQL SDBC extension provided in "
		elog " /usr/$(get_libdir)/openoffice/share/extension/install/ "
	fi
	elog
}
