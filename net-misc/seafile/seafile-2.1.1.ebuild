# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# Created by Martin Kupec

EAPI=4

inherit eutils python autotools

DESCRIPTION="Cloud file syncing software"
HOMEPAGE="http://www.seafile.com"
SRC_URI="https://github.com/haiwen/${PN}/archive/v${PV}.tar.gz -> ${PN}-${PV}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86"
IUSE="gui gtk console server client python"

DEPEND="client? ( !net-misc/seafile-client )
	>=dev-lang/python-2.5[sqlite]
	( =net-libs/ccnet-${PV}[python,client] )
	dev-python/simplejson
	dev-python/mako
	dev-python/webpy
	dev-python/Djblets
	dev-python/chardet
	www-servers/gunicorn
	>=net-libs/libevhtp-1.1.6
	sys-devel/gettext
	dev-util/pkgconfig"

RDEPEND=""

pkg_setup() {
	python_set_active_version 2
	python_pkg_setup
}

src_prepare() {
	./autogen.sh || die "src_prepare failed"
}

src_configure() {
	econf \
		$(use_enable gui) \
		$(use_enable gtk) \
		$(use_enable server) \
		$(use_enable python) \
		$(use_enable console) \ 
}

src_compile() {
	# dev-lang/vala does not provide a valac symlink
	mkdir ${S}/tmpbin
	ln -s $(echo $(whereis valac-) | grep -oE "[^[[:space:]]*$") ${S}/tmpbin/valac
	PATH="${S}/tmpbin/:$PATH" emake -j1 || die "emake failed"
}
