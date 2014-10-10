# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# Created by Martin Kupec

EAPI=5

inherit python

DESCRIPTION="Cloud file syncing software - seahub webapp and server utilities"
HOMEPAGE="http://www.seafile.com"
SRC_URI="https://bitbucket.org/haiwen/seafile/downloads/seafile-server_${PV}_x86-64.tar.gz -> ${PN}-${PV}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86 ~amd64"

DEPEND="
	<dev-lang/python-3[sqlite]
	dev-python/setuptools
	virtual/python-imaging
	=net-misc/seafile-${PV}[server,fuse]"

RDEPEND=""

pkg_setup() {
	python_set_active_version 2
	python_pkg_setup
}

src_prepare() {
	# remove included libs and python bytecode
	# Note: This does NOT remove lib64 because it only includes required python packages!
	rm -r "${S}/seafile/lib"
	find -iname "*.pyo" -delete

	# prepare bin folder for symlinks in pkg_postinst step
	# this is only to avoid "already stripped" warnings while installing
	cd "${S}/seafile/bin/"
	for x in *; do
		rm "${x}"
		touch "${x}"
	done
	cd -
	
	# remove windows upgrade scripts
	rm -r "${S}/upgrade/win32"
}

src_install() {
	cp -R "${S}/" "${D}/"
	
	#rm -r "${D}/${P}/seafile/bin/*"
	#ln -s "/usr/bin/ccnet-init" "${D}/${P}/seafile/bin/ccnet-init"
	#ln -s "/usr/bin/ccnet-server" "${D}/${P}/seafile/bin/ccnet-server"
	#ln -s "/usr/bin/fileserver" "${D}/${P}/seafile/bin/fileserver"
	
	# create file structure
	mkdir -p "${D}/opt/seafile"
	mv "${D}/${P}" "${D}/opt/seafile/seafile-server" || die "Install failed!"
}

pkg_postinst() {
	cd "/opt/seafile/seafile-server/seafile/bin/"
	for x in *; do
		rm "${x}"
		ln -s "/usr/bin/${x}"
	done
	cd -

	python_mod_optimize /opt/seafile/seafile-server/
}

pkg_postrm() {
	python_mod_cleanup /opt/seafile/seafile-server/
}
