# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="A simple, cross-platform wrapper over TCP/IP sockets."
HOMEPAGE="https://libsdl.org/projects/SDL_mixer/"
SRC_URI="https://github.com/libsdl-org/SDL_net/tarball/904600c6133e0435d627ec1878bfdfeac414a899 -> SDL_net-2.4.0-904600c.tar.gz"

LICENSE="ZLIB"
SLOT="0"
KEYWORDS="*"
IUSE="static-libs"

RDEPEND="media-libs/libsdl2"
DEPEND=${RDEPEND}

post_src_unpack() {
	mv "${WORKDIR}"/libsdl-org-SDL_net-* "$S" || die
}

src_configure() {
	econf \
		--disable-sdltest \
		--disable-examples \
		$(use_enable static-libs static)
}

src_install() {
	emake DESTDIR="${D}" install
	dodoc {CHANGES,README}.txt
	find "${ED}" -name '*.la' -delete || die
}