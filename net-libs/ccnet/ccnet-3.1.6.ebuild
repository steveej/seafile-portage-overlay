# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# Created by Martin Kupec

EAPI=5

PYTHON_COMPAT=( python{2_6,2_7} )
PYTHON_REQ_USE="sqlite(+)"

inherit autotools-utils python-single-r1

DESCRIPTION="Networking library for Seafile"
HOMEPAGE="http://www.seafile.com"
SRC_URI="https://github.com/haiwen/${PN}/archive/v${PV}.tar.gz -> ${PN}-${PV}.tar.gz"

SLOT="0"
LICENSE="GPL-2"
KEYWORDS="~x86 ~amd64"
IUSE="+client +server ldap demo"

RDEPEND="=net-libs/libsearpc-${PV}
	>=dev-libs/glib-2.16
	>=dev-lang/vala-0.8
	>=dev-db/libzdb-2.10
	virtual/pkgconfig
	${PYTHON_DEPS}
	>=dev-libs/libevent-2
	ldap? ( net-nds/openldap )"
DEPEND="${RDEPEND}"

REQUIRED_USE="${PYTHON_REQUIRED_USE}"

AUTOTOOLS_IN_SOURCE_BUILD=1
AUTOTOOLS_AUTORECONF=1

PATCHES=(
	"${FILESDIR}"/libccnet.pc.patch
	"${FILESDIR}"/0001-Add-autoconfiguration-for-libjansson.patch
)

src_configure() {
	local myeconfargs=(
		$(use_enable server)
		$(use_enable client)
		$(use_enable ldap)
		$(use_enable demo compile-demo)
	)
	autotools-utils_src_configure
}

src_compile() {
	# dev-lang/vala does not provide a valac symlink
	mkdir ${S}/tmpbin
	ln -s $(echo $(whereis valac-) | grep -oE "[^[[:space:]]*$") ${S}/tmpbin/valac
	export PATH="${S}/tmpbin/:$PATH"

	autotools-utils_src_compile
}
