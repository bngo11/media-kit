# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3+ )

inherit flag-o-matic meson python-any-r1 xdg-utils

DESCRIPTION="An OpenType text shaping engine"
HOMEPAGE="https://www.freedesktop.org/wiki/Software/HarfBuzz"

SRC_URI="https://github.com/${PN}/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"
KEYWORDS="next"

LICENSE="Old-MIT ISC icu"
SLOT="0/0.9.18" # 0.9.18 introduced the harfbuzz-icu split; bug #472416

IUSE="+cairo debug doc +glib +graphite icu +introspection test +truetype"
RESTRICT="!test? ( test )"
REQUIRED_USE="introspection? ( glib )"

RDEPEND="
	cairo? ( x11-libs/cairo:= )
	glib? ( >=dev-libs/glib-2.38:2 )
	graphite? ( >=media-gfx/graphite2-1.2.1:= )
	icu? ( >=dev-libs/icu-51.2-r1:= )
	introspection? ( >=dev-libs/gobject-introspection-1.34:= )
	truetype? ( >=media-libs/freetype-2.5.0.1:2= )
"
DEPEND="${RDEPEND}
	>=dev-libs/gobject-introspection-common-1.34
"
BDEPEND="
	${PYTHON_DEPS}
	virtual/pkgconfig
	doc? ( dev-util/gtk-doc )
"

pkg_setup() {
	python-any-r1_pkg_setup
	if ! use debug ; then
		append-cppflags -DHB_NDEBUG
	fi
}

src_prepare() {
	default

	xdg_environment_reset

	sed -i \
		-e 's:tests/macos.tests::' \
		test/shaping/data/in-house/Makefile.sources \
		|| die # bug 726120

	# bug 618772
	append-cxxflags -std=c++14

	# bug 762415
	local pyscript
	for pyscript in $(find -type f -name "*.py") ; do
		python_fix_shebang -q "${pyscript}"
	done
}

src_configure() {
	# harfbuzz-gobject only used for instrospection, bug #535852
	local emesonargs=(
		-Dcoretext="disabled"
		$(meson_feature cairo)
		$(meson_feature doc docs)
		$(meson_feature introspection)
		$(meson_feature glib)
		$(meson_feature graphite)
		$(meson_feature icu)
		$(meson_feature introspection gobject)
		$(meson_feature test tests)
		$(meson_feature truetype freetype)
	)

	meson_src_configure
}
