# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3+ )
inherit python-single-r1 xdg cmake

DESCRIPTION="Free (libre) font editor for Windows, Mac OS X and GNU+Linux"
HOMEPAGE="https://fontforge.org/"
SRC_URI="https://github.com/fontforge/fontforge/tarball/a1dad3e81da03d5d5f3c4c1c1b9b5ca5ebcfcecf -> fontforge-20230101-a1dad3e.tar.gz"

LICENSE="BSD GPL-3+"
SLOT="0"
KEYWORDS="*"
IUSE="doc truetype-debugger gif gtk jpeg png +python readline test tiff svg woff2 X"
RESTRICT="!test? ( test )"

REQUIRED_USE="python? ( ${PYTHON_REQUIRED_USE} )"

RDEPEND="
	>=dev-libs/glib-2.67:2
	dev-libs/libltdl:0
	dev-libs/libxml2:2=
	>=media-libs/freetype-2.3.7:2=
	gif? ( media-libs/giflib:0= )
	jpeg? ( virtual/jpeg:0 )
	png? ( media-libs/libpng:0= )
	tiff? ( media-libs/tiff:0= )
	truetype-debugger? ( >=media-libs/freetype-2.3.8:2[fontforge,-bindist(-)] )
	gtk? ( >=x11-libs/gtk+-3.10:3 )
	!gtk? (
		X? (
			>=x11-libs/cairo-1.6:0=
			>=x11-libs/pango-1.10:0=[X]
			x11-libs/libX11:0=
			x11-libs/libXi:0=
		)
	)
	python? ( ${PYTHON_DEPS} )
	readline? ( sys-libs/readline:0= )
	woff2? ( media-libs/woff2:0= )
"
DEPEND="${RDEPEND}
	!gtk? ( X? ( x11-base/xorg-proto ) )
"
BDEPEND="
	sys-devel/gettext
	doc? ( >=dev-python/sphinx-2 )
	python? ( ${PYTHON_DEPS} )
	test? ( ${RDEPEND} )
"

PATCHES=(
	"${FILESDIR}"/fontforge-doc-no-warn-error.patch
	"${FILESDIR}"/${PN}-20230101-workaround-broken-translations.patch
	"${FILESDIR}"/${PN}-20230101-fix-splinefont-shell-command-injection.patch
)

post_src_unpack() {
	if [ ! -d "${S}" ]; then
		mv fontforge-fontforge* "${S}" || die
	fi
}

src_prepare() {
	# warning -> error
	sed -i "s:-q -n -W -b \(html -d doctrees.* sphinx-docs$\):-q -n -b \1:" doc/CMakeLists.txt
	default
	cmake_src_prepare
}

src_configure() {
	local mycmakeargs=(
		-DENABLE_DOCS=$(usex doc ON OFF)
		-DENABLE_LIBGIF=$(usex gif ON OFF)
		-DENABLE_LIBJPEG=$(usex jpeg ON OFF)
		-DENABLE_LIBPNG=$(usex png ON OFF)
		-DENABLE_LIBREADLINE=$(usex readline ON OFF)
		-DENABLE_LIBSPIRO=OFF # No package in Gentoo
		-DENABLE_LIBTIFF=$(usex tiff ON OFF)
		-DENABLE_MAINTAINER_TOOLS=OFF
		-DENABLE_PYTHON_EXTENSION=$(usex python ON OFF)
		-DENABLE_PYTHON_SCRIPTING=$(usex python ON OFF)
		-DENABLE_TILE_PATH=ON
		-DENABLE_WOFF2=$(usex woff2 ON OFF)
	)

	if use gtk || use X; then
		mycmakeargs+=(
			-DENABLE_GUI=ON
			# Prefer GTK over X11 if both USE flage are enabled
			-DENABLE_X11=$(usex gtk OFF ON)
		)
	else
		mycmakeargs+=( -DENABLE_GUI=OFF )
	fi

	if use python; then
		python_setup
		mycmakeargs+=( -DPython3_EXECUTABLE="${PYTHON}" )
	fi

	if use truetype-debugger ; then
		local ft2="${ESYSROOT}/usr/include/freetype2"
		local ft2i="${ft2}/internal4fontforge"
		mycmakeargs+=(
			-DENABLE_FREETYPE_DEBUGGER="${ft2}"
			-DFreeTypeSource_INCLUDE_DIRS="${ft2};${ft2i}/include;${ft2i}/include/freetype;${ft2i}/src/truetype"
		)
	fi

	cmake_src_configure
}

src_install() {
	cmake_src_install
	docompress -x /usr/share/doc/${PF}/html
	einstalldocs
	find "${ED}" -name '*.la' -type f -delete || die
}