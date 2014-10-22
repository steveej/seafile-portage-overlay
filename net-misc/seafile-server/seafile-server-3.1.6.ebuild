# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# Created by Martin Kupec

EAPI=5

PYTHON_COMPAT=( python{2_6,2_7} )
PYTHON_REQ_USE="sqlite(+)"

inherit python-single-r1

DESCRIPTION="Cloud file syncing software - seahub webapp and server utilities"
HOMEPAGE="http://www.seafile.com"
SRC_URI="https://bitbucket.org/haiwen/seafile/downloads/seafile-server_${PV}_x86-64.tar.gz -> ${PN}-${PV}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86 ~amd64"

RDEPEND="
	${PYTHON_DEPS}
	dev-python/setuptools
	virtual/python-imaging
	=net-misc/seafile-${PV}[server,fuse]"
DEPEND="${RDEPEND}"

REQUIRED_USE="${PYTHON_REQUIRED_USE}"

src_prepare() {
	# remove included libs and python bytecode
	# Note: This does NOT remove lib64 because it only includes required python packages!
	rm -r "${S}/seafile/lib"
	find -iname "*.py[co]" -delete

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

	python_optimize "${D}"

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

	elog "seafile-server has been installed to /opt/seafile"
	elog "To configure seafile please run:"
	elog "cd /opt/seafile/seafile-server && ./setup-seafile[-mysql].sh"
	elog "For more information consult the official installation guide:"
	elog "http://manual.seafile.com/deploy/README.html"

	ewarn "Since this ebuild is rather new: Please make sure to backup /opt/seafile before upgrading this package!"
}
