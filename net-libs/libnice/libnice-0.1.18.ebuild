# Distributed under the terms of the GNU General Public License v2

EAPI=7
inherit xdg meson

DESCRIPTION="An implementation of the Interactive Connectivity Establishment standard (ICE)"
HOMEPAGE="https://nice.freedesktop.org/wiki/"
SRC_URI="https://nice.freedesktop.org/releases/${P}.tar.gz"

LICENSE="|| ( MPL-1.1 LGPL-2.1 )"
SLOT="0"
KEYWORDS="*"
IUSE="+gnutls gstreamer +introspection libressl +upnp"

RDEPEND="
	>=dev-libs/glib-2.48:2
	introspection? ( >=dev-libs/gobject-introspection-1.30.0:= )
	gnutls? ( >=net-libs/gnutls-2.12.0:0= )
	!gnutls? (
		libressl? ( dev-libs/libressl:0= )
		!libressl? ( dev-libs/openssl:0= ) )
	upnp? ( >=net-libs/gupnp-igd-0.2.4:= )
"
DEPEND="${RDEPEND}
	dev-util/glib-utils
	>=dev-util/gtk-doc-am-1.10
	>=virtual/pkgconfig-0-r1
"

src_configure() {
	# gstreamer plugin split off into media-plugins/gst-plugins-libnice
	local emesonargs=(
		-Dcrypto-library=$(usex gnutls gnutls openssl)
		$(meson_feature gstreamer)
		$(meson_feature introspection)
		$(meson_feature upnp gupnp)
	)

	meson_src_configure
}

src_install() {
	meson_src_install

	einstalldocs
	find "${ED}" -name '*.la' -delete || die
}

