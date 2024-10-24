# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit autotools multilib-minimal

DESCRIPTION="Library for reading UDF from raw devices and image files"
HOMEPAGE="https://code.videolan.org/videolan/libudfread/"
SRC_URI="https://code.videolan.org/videolan/libudfread/-/archive/1.1.2/libudfread-1.1.2.tar.gz -> libudfread-1.1.2.tar.gz"
KEYWORDS="*"

LICENSE="LGPL-2.1+"
SLOT="0"
IUSE="static-libs"

src_prepare() {
	default
	eautoreconf
}

multilib_src_configure() {
	ECONF_SOURCE="${S}" econf
}

multilib_src_install_all() {
	find "${D}" -name '*.la' -delete || die
	if ! use static-libs ; then
		find "${D}" -name '*.a' -delete || die
	fi
}