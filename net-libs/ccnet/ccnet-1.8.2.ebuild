# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# Created by Martin Kupec

EAPI=4

inherit eutils autotools python

DESCRIPTION="Networking library for Seafile"
HOMEPAGE="http://www.seafile.com"
SRC_URI="http://seafile.googlecode.com/files/seafile-${PV}.tar.gz"

SLOT="0"
LICENSE="GPL-2"
KEYWORDS="~x86"
IUSE="client server python cluster ldap"

DEPEND="=net-libs/libsearpc-${PV}
	>=dev-libs/glib-2.0
	>=dev-lang/vala-0.8
	dev-db/libzdb
	dev-util/pkgconfig"

RDEPEND=""

S=${WORKDIR}/seafile-${PV}/${PN}

src_configure() {
	econf 	$(use_enable server) \
		$(use_enable client) \
		$(use_enable python) \
		$(use_enable cluster) \
		$(use_enable ldap) \
		--enable-console \
		|| die "econf failed"
}

src_compile() {
        emake -j1 || die "emake failed"
}
