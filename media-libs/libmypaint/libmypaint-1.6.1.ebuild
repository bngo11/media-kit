# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{7,8,9} )

inherit python-any-r1 toolchain-funcs


DESCRIPTION="Library for making brushstrokes"
HOMEPAGE="https://github.com/mypaint/libmypaint"
SRC_URI="https://api.github.com/repos/mypaint/libmypaint/tarball/refs/tags/v1.6.1 -> libmypaint-1.6.1-2768251dacce3939136c839aeca413f4aa4241d0.tar.gz"

LICENSE="ISC"
# See https://github.com/mypaint/libmypaint/releases/tag/v1.6.1
# https://github.com/mypaint/libmypaint/compare/v1.6.0...v1.6.1
SLOT="0/0.0.0"
KEYWORDS="*"
IUSE="gegl introspection nls openmp"

BDEPEND="
	${PYTHON_DEPS}
	nls? ( dev-util/intltool )
"
DEPEND="
	dev-libs/glib:2
	dev-libs/json-c:=
	gegl? (
		media-libs/babl
		>=media-libs/gegl-0.4.14:0.4[introspection?]
	)
	introspection? ( >=dev-libs/gobject-introspection-1.32 )
	openmp? ( >sys-devel/gcc-5:*[openmp] )
	nls? ( sys-devel/gettext )
"
RDEPEND="
	${DEPEND}
	!<media-gfx/mypaint-1.2.1
"
post_src_unpack() {
	mv "${WORKDIR}/"mypaint-libmypaint* "${S}" || die
}

src_prepare() {
    default
    ./autogen.sh || die
}

src_configure() {
	tc-ld-disable-gold # bug 589266

	econf \
		--disable-debug \
		--disable-docs \
		$(use_enable gegl) \
		--disable-gperftools \
		$(use_enable nls i18n) \
		$(use_enable introspection) \
		$(use_enable openmp) \
		--disable-profiling
}

src_install() {
	default
	find "${ED}" -name '*.la' -type f -delete || die
}