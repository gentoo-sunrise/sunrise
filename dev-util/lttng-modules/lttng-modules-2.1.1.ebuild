# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

inherit linux-mod

DESCRIPTION="LTTng Kernel Tracer Modules"
HOMEPAGE="http://lttng.org"
SRC_URI="http://lttng.org/files/${PN}/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

MODULE_NAMES="
	lttng-ring-buffer-client-discard(misc:)
	lttng-ring-buffer-client-overwrite(misc:)
	lttng-ring-buffer-metadata-client(misc:)
	lttng-ring-buffer-client-mmap-discard(misc:)
	lttng-ring-buffer-client-mmap-overwrite(misc:)
	lttng-ring-buffer-metadata-mmap-client(misc:)
	lttng-tracer(misc:)
	lttng-statedump(misc:)
	probes/lttng-probe-statedump(misc:)
	probes/lttng-types(misc:)
	probes/lttng-probe-timer(misc:)
	probes/lttng-probe-sched(misc:)
	probes/lttng-probe-signal(misc:)
	probes/lttng-probe-lttng(misc:)
	probes/lttng-probe-irq(misc:)
	probes/lttng-kretprobes(misc:)
	probes/lttng-probe-block(misc:)
	probes/lttng-kprobes(misc:)
	lib/lttng-lib-ring-buffer(misc:)
"

BUILD_TARGETS="default"

CONFIG_CHECK="MODULES KALLSYMS HIGH_RES_TIMERS TRACEPOINTS
	~HAVE_SYSCALL_TRACEPOINTS ~PERF_EVENTS ~EVENT_TRACING ~KPROBES KRETPROBES"

pkg_pretend() {
	if kernel_is lt 2 6 27; then
		eerror "${PN} require Linux kernel >= 2.6.27"
		die "Please update your kernel!"
	fi
}

src_install() {
	linux-mod_src_install
	dodoc ChangeLog README TODO
}
