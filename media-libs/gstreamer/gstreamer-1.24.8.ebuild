# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit bash-completion-r1 pax-utils meson

DESCRIPTION="Open source multimedia framework"
HOMEPAGE="https://gstreamer.freedesktop.org/"
SRC_URI="https://gstreamer.freedesktop.org/src/gstreamer/gstreamer-1.24.8.tar.xz -> gstreamer-1.24.8.tar.xz"

LICENSE="LGPL-2+"
SLOT="1.0"
KEYWORDS="*"
IUSE="+caps +introspection nls +orc tests unwind"

RDEPEND="
	>=dev-libs/glib-2.40.0:2
	caps? ( sys-libs/libcap )
	introspection? ( >=dev-libs/gobject-introspection-1.31.1:= )
	unwind? (
		>=sys-libs/libunwind-1.2_rc1
		dev-libs/elfutils
	)
	!<media-libs/gst-plugins-bad-1.13.1:1.0
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
		-Dbenchmarks=disabled
		-Dexamples=disabled
		-Dcheck=enabled
		$(meson_feature unwind libunwind)
		$(meson_feature unwind libdw)
		$(meson_feature nls)
		$(meson_feature tests)
		$(meson_feature introspection)
		-Dbash-completion=enabled
		-Dpackage-name="GStreamer ebuild for Gentoo"
		-Dpackage-origin="https://packages.gentoo.org/package/media-libs/gstreamer"
	)

	if use caps ; then
		emesonargs+=( -Dptp-helper-permissions=capabilities )
	else
		emesonargs+=(
			-Dptp-helper-permissions=setuid-root
			-Dptp-helper-setuid-user=nobody
			-Dptp-helper-setuid-group=nobody
		)
	fi

	meson_src_configure
}