# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit toolchain-funcs

DESCRIPTION="A QR code shared library used by OpenCV."
HOMEPAGE="https://github.com/dlbeer/quirc"

LICENSE="AS-IS"
SLOT="0"
KEYWORDS="*"
IUSE=""

DEPEND=""
RDEPEND="${DEPEND}"

SRC_URI="https://github.com/dlbeer/quirc/archive/refs/tags/v1.2.tar.gz -> quirc-1.2.tar.gz"

PATCHES=( "${FILESDIR}/quirc-remove-demo.patch" )

src_compile() {
	export CFLAGS="-fPIC $CFLAGS"
	export PREFIX=/usr
	emake || die
}

src_install() {
	mkdir -p "${D}"/usr/{include,lib,bin}
	emake DESTDIR="${D}" install || die
}