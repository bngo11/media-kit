# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="Library parsing the Corel cdr documents"
HOMEPAGE="https://wiki.documentfoundation.org/DLP/Libraries/libcdr"
SRC_URI="https://dev-www.libreoffice.org/src/libcdr/libcdr-0.1.7.tar.xz -> libcdr-0.1.7.tar.xz"
KEYWORDS="*"

LICENSE="MPL-2.0"
SLOT="0"
IUSE="doc test"

RESTRICT="!test? ( test )"

RDEPEND="
	dev-libs/icu:=
	dev-libs/librevenge
	media-libs/lcms:2
	sys-libs/zlib
"
DEPEND="${RDEPEND}
	dev-libs/boost
"
BDEPEND="
	sys-devel/libtool
	virtual/pkgconfig
	doc? ( app-doc/doxygen )
	test? ( dev-util/cppunit )
"

src_prepare() {
	default
	[[ -d m4 ]] || mkdir "m4"
}

src_configure() {
	local myeconfargs=(
		--disable-static
		$(use_with doc docs)
		$(use_enable test tests)
	)
	econf "${myeconfargs[@]}"
}

src_install() {
	default
	find "${D}" -name '*.la' -delete || die
}