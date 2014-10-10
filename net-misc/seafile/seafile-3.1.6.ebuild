# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# Created by Martin Kupec

EAPI=5

inherit autotools-utils python

DESCRIPTION="Cloud file syncing software"
HOMEPAGE="http://www.seafile.com"
SRC_URI="https://github.com/haiwen/${PN}/archive/v${PV}.tar.gz -> ${PN}-${PV}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86 ~amd64"
IUSE="+server +client +fuse"

DEPEND="
	<dev-lang/python-3[sqlite]
	>=net-libs/ccnet-${PV}
	>=net-libs/libevhtp-1.1.6
	virtual/pkgconfig
	dev-libs/jansson
	>=dev-libs/libevent-2
	fuse? ( >=sys-fs/fuse-2.7.3 )
	client? ( >=net-libs/ccnet-${PV}[client] )
	server? ( >=net-libs/ccnet-${PV}[server] )"

REQUIRED_USE="fuse? ( server )"

RDEPEND=""

AUTOTOOLS_IN_SOURCE_BUILD=1
AUTOTOOLS_AUTORECONF=1

pkg_setup() {
	python_set_active_version 2
	python_pkg_setup
}

src_configure() {
	local myeconfargs=(
		$(use_enable fuse) \
		$(use_enable client) \
		$(use_enable server) \
		--enable-console
	)
	autotools-utils_src_configure
}

src_prepare() {
	find -iname "*.py" -print0 | xargs -0 -L 1 sed -i 's,^#!/usr/bin/env python$,#!/usr/bin/env python2,'
	sed -i 's,^#!/usr/bin/env python$,#!/usr/bin/env python2,' "${S}/tools/seafile-admin"
	
	autotools-utils_src_prepare
}

src_compile() {
	# dev-lang/vala does not provide a valac symlink
	mkdir ${S}/tmpbin
	ln -s $(echo $(whereis valac-) | grep -oE "[^[[:space:]]*$") ${S}/tmpbin/valac
	export PATH="${S}/tmpbin/:$PATH"
	
	autotools-utils_src_compile
}

src_install() {
	autotools-utils_src_install

	doins -r ${S}/scripts
	dodoc ${S}/doc/cli-readme.txt 
	doman ${S}/doc/*.1
}
