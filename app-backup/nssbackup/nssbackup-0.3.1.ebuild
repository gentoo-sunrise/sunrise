# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

SUPPORT_PYTHON_ABIS="1"
PYTHON_DEPEND="2:2.5"

inherit distutils python versionator

MY_PV=$(get_version_component_range 1-2)

DESCRIPTION="Fork of the sbackup project with better user interaction"
HOMEPAGE="https://launchpad.net/nssbackup"
SRC_URI="http://launchpad.net/${PN}/${MY_PV}/${MY_PV}/+download/${PN}_${PV}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DOCS="HACKING"

DEPEND="dev-python/setuptools"
RDEPEND="dev-python/gnome-python
	dev-python/notify-python
	dev-python/pexpect
	dev-python/pygtk
	net-fs/curlftpfs
	sys-devel/gettext
	sys-fs/fuse
	sys-fs/sshfs-fuse"

RESTRICT_PYTHON_ABIS="3.*"

src_compile(){
	emake DISTDIR=/usr PREFIX=/usr || die
	distutils_src_compile
}

src_install(){
	local script

	distutils_src_install
	cd scripts || die
	for script in *.py; do
		newbin ${script} ${script/.py/} || die
	done
}
