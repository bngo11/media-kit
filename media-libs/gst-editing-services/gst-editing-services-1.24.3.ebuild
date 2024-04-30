# Distributed under the terms of the GNU General Public License v2

EAPI=7
PYTHON_COMPAT=( python2+ python3+ )
GNOME3_LA_PUNT="yes"

inherit bash-completion-r1 gnome3 python-r1 meson

DESCRIPTION="SDK for making video editors and more"
HOMEPAGE="http://wiki.pitivi.org/wiki/GES"
SRC_URI="https://gstreamer.freedesktop.org/src/gst-editing-services/gst-editing-services-1.24.3.tar.xz -> gst-editing-services-1.24.3.tar.xz"

LICENSE="LGPL-2+"
SLOT="1.0"
KEYWORDS="*"

IUSE="+introspection"
REQUIRED_USE="${PYTHON_REQUIRED_USE}"

RDEPEND="
	${PYTHON_DEPS}
	>=dev-libs/glib-2.40.0:2
	dev-libs/libxml2:2
	dev-python/pygobject:3[${PYTHON_USEDEP}]
	>=media-libs/gstreamer-${PV}:1.0[introspection?]
	>=media-libs/gst-plugins-base-${PV}:1.0[introspection?]
	introspection? ( >=dev-libs/gobject-introspection-0.9.6:= )
"
DEPEND="${RDEPEND}
	!<=media-libs/gstreamer-editing-services-1.16.3
	>=dev-util/gtk-doc-am-1.3
	virtual/pkgconfig
"
# XXX: tests do pass but need g-e-s to be installed due to missing
# AM_TEST_ENVIRONMENT setup.
RESTRICT="test"

src_configure() {
	# gtk is only used for examples
	local emesonargs=(
		$(meson_feature introspection)
		-Dexamples=disabled
		-Dbash-completion=enabled
	)

	meson_src_configure
}

src_compile() {
	# Prevent sandbox violations, bug #538888
	# https://bugzilla.gnome.org/show_bug.cgi?id=744135
	# https://bugzilla.gnome.org/show_bug.cgi?id=744134
	addpredict /dev
	meson_src_compile
}