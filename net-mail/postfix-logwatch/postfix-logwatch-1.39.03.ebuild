# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

DESCRIPTION="A log analyzer for postfix"
HOMEPAGE="http://logreporters.sourceforge.net/"
SRC_URI="mirror://sourceforge/logreporters/${P}.tgz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="logwatch"

DEPEND="dev-lang/perl"
RDEPEND="${DEPEND}"

src_compile() {
	# The default make target just outputs instructions. We don't want
	# the user to see these, so we avoid emake.
	:
}

src_install() {
	# There are two different "versions" of the package in the
	# tarball: a standalone executable and a logwatch filter. The
	# standalone is always installed. However, the logwatch filter is
	# only installed with USE="logwatch".
	dodoc Bugs Changes README ${PN}.conf-topn \
		|| die "failed to install documentation"

	doman ${PN}.1 || die "failed to install man page"
	dohtml ${PN}.1.html || die "failed to install html documentation"
	dobin ${PN} || die "failed to install executable"
	insinto /etc
	doins ${PN}.conf || die "failed to install config file"

	if use logwatch; then
		# Remove the taint mode (-T) switch from the header of the
		# standalone executable, and save the result as our logwatch
		# filter.
		sed 's~^#!/usr/bin/perl -T$~#!/usr/bin/perl~' ${PN} > postfix \
			|| die "failed to remove the perl taint switch"

		insinto /etc/logwatch/scripts/services
		doins postfix || die "failed to install the 'postfix' logwatch filter"

		insinto /etc/logwatch/conf/services
		newins ${PN}.conf postfix.conf \
			   || die "failed to install the logwatch 'postfix.conf' file"
	fi
}
