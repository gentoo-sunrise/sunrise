# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit eutils

MAJOR_VERSION=${PV%\.[0-9]}

SBOX_GROUP="sbox"
RESTRICT="strip"

DESCRIPTION="Scratchbox is a cross-compilation toolkit designed to make embedded Linux application development easier."
HOMEPAGE="http://www.scratchbox.org/"
SRC_URI="http://scratchbox.org/download/files/sbox-releases/${MAJOR_VERSION}/tarball/scratchbox-core-${PV}.tar.gz
	 http://scratchbox.org/download/files/sbox-releases/${MAJOR_VERSION}/tarball/scratchbox-libs-${PV}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86"
IUSE=""

DEPEND=""
RDEPEND=""

TARGET_DIR="/opt/scratchbox"

S=${WORKDIR}/scratchbox

pkg_setup() {
	einfo "Creating group sbox"
	enewgroup "${SBOX_GROUP}"
}

src_install() {
	cd "${S}"
	dodir ${TARGET_DIR}
	# doins doesn't work with symlinks, getting "file not found" with doins
	cp -pRP ./* "${D}/${TARGET_DIR}"
	dosym opt/scratchbox scratchbox

	# scratchbox service loader
	newinitd "${FILESDIR}/scratchbox.rc" scratchbox || die "newinitd failed"

}

pkg_postinst() {
	einfo
	einfo "You need to run /opt/scratchbox/run_me_first.sh to complete the install."
	einfo
	einfo "Do not forget to create a scratchbox user:"
	einfo "/opt/scratchbox/sbin/sbox_adduser <user>"
	einfo
	einfo "For further documentation about how to setup"
	einfo "scratchbox for your development needs have a look at"
	einfo "http://scratchbox.org/documentation/user/scratchbox-${MAJOR_VERSION}/"
	einfo
	einfo "Also note that when you reboot you should run:"
	einfo "/etc/init.d/scratchbox start"
	einfo "before trying to run scratchbox."
	einfo "You can also add it to the default runlevel:"
	einfo "rc-update add scratchbox default"
	einfo
	einfo "Type /opt/scratchbox/login to start scratchbox."
	einfo

	ewarn
	ewarn "Remember, in order to run scratchbox, you have to"
	ewarn "be in the '${SBOX_GROUP}' group."
	ewarn

	ewarn
	ewarn "For scratchbox to work, you have to set the following files to suid root (chmod u+s FILE):"
	ewarn " - /opt/scratchbox/sbin/chroot-uid"
	ewarn " - /opt/scratchbox/compilers/host-gcc/usr/libexec/pt_chown"
	ewarn "Please note that this could be a security risk and should not be done when security is a concern"
	ewarn
}

pkg_postrm() {
	einfo
	einfo "To remove all traces of scratchbox you will need to remove the file"
	einfo "/etc/init.d/scratchbox. Don't forget to delete the sbox group."
	einfo
}

