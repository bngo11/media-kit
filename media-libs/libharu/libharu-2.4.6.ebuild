# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit cmake

DESCRIPTION="libharu - free PDF library"
HOMEPAGE="http://www.libharu.org/ https://github.com/libharu/libharu"
SRC_URI="https://github.com/libharu/libharu/tarball/3467749fd1c0ab6ca6ed424d053b1ea53c1bf67c -> libharu-2.4.6-3467749.tar.gz"

LICENSE="ZLIB"
SLOT="0/${PV}"
KEYWORDS="*"

DEPEND="
	media-libs/libpng:=
	sys-libs/zlib:=
"
RDEPEND="${DEPEND}"

post_src_unpack() {
	mv ${WORKDIR}/libharu-libharu-* ${S} || die
}

src_configure() {
	local mycmakeargs=(
		-DLIBHPDF_EXAMPLES=NO # Doesn't work
		-DLIBHPDF_STATIC=NO
	)
	cmake_src_configure
}