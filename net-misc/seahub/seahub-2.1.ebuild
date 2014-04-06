# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# Created by Martin Kupec

EAPI=4

inherit eutils python autotools

DESCRIPTION="Cloud file syncing software"
HOMEPAGE="http://www.seafile.com"
SRC_URI="https://github.com/haiwen/${PN}/archive/${PV}.tar.gz -> ${PN}-${PV}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86"
IUSE="fastcgi"

DEPEND="
	net-misc/seafile[server]
	dev-python/six
	fastcgi? ( dev-python/flup )
	"

RDEPEND=""

src_install() {
	SEAFILE_PATH="/opt/seafile/seafile-server"
	insinto ${SEAFILE_PATH}
	doins -r ${WORKDIR}/${PN}-${PV}

	elog "Seahub has been installed to ${SEAFILE_PATH}/${PN}-${PV}"
	elog "Follow the instructions from the seafile-wiki to create the configuration files:"
	elog "https://github.com/haiwen/seafile/wiki/Build-and-deploy-seafile-server-from-source#Create_Configurations_with_the_seafileadmin_script"
}
