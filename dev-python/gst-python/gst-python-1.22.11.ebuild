# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3+ )

inherit ltprune python-r1 xdg-utils meson

DESCRIPTION="A Python Interface to GStreamer"
HOMEPAGE="https://gstreamer.freedesktop.org/"
SRC_URI="https://gstreamer.freedesktop.org/src/gst-python/gst-python-1.22.11.tar.xz -> gst-python-1.22.11.tar.xz"

LICENSE="LGPL-2+"
SLOT="1.0"
KEYWORDS="*"
REQUIRED_USE="${PYTHON_REQUIRED_USE}"

RDEPEND="${PYTHON_DEPS}
	>=dev-python/pygobject-3.8:3[${PYTHON_USEDEP}]
	>=media-libs/gstreamer-${PV}:1.0[introspection]
	>=media-libs/gst-plugins-base-${PV}:1.0[introspection]
"
DEPEND="${RDEPEND}
	virtual/pkgconfig
"

src_prepare() {
	default
	xdg_environment_reset
	python_copy_sources
}
