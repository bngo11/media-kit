# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit meson

DESCRIPTION="Development and debugging tools for GStreamer"
HOMEPAGE="https://gstreamer.freedesktop.org/"
SRC_URI="https://gstreamer.freedesktop.org/src/gst-devtools/gst-devtools-1.26.7.tar.xz -> gst-devtools-1.26.7.tar.xz"

LICENSE="LGPL-2+"
SLOT="1.0"
KEYWORDS="*"
IUSE="+introspection nls tests"
REQUIRED_USE=""
RESTRICT="network-sandbox"

RDEPEND="
	>=dev-libs/glib-2.40.0:2
	>=media-libs/gstreamer-${PV}:${SLOT}
	introspection? ( >=dev-libs/gobject-introspection-1.31.1:= )
"

DEPEND="${RDEPEND}
	sys-devel/bison
	sys-devel/flex
	virtual/pkgconfig
	nls? ( sys-devel/gettext )
"

src_configure() {
	if [[ ${CHOST} == *-interix* ]] ; then
		export ac_cv_lib_dl_dladdr=no
		export ac_cv_func_poll=no
	fi
	if [[ ${CHOST} == powerpc-apple-darwin* ]] ; then
		# GCC groks this, but then refers to an implementation (___multi3,
		# ___udivti3) that don't exist (at least I can't find it), so force
		# this one to be off, such that we use 2x64bit emulation code.
		export gst_cv_uint128_t=no
	fi

	# Set 'libexecdir' to ABI-specific location for the library spawns
	# helpers from there.
	# Disable static archives and examples to speed up build time
	# Disable debug, as it only affects -g passing (debugging symbols), this must done through make.conf in gentoo
	local emesonargs=(
		$(meson_feature nls)
		$(meson_feature tests)
		$(meson_feature introspection)
	)

	meson_src_configure
}