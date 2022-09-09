# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="GStreamer plugin for ICE (RFC 5245) support"
HOMEPAGE="https://nice.freedesktop.org/wiki/"
SRC_URI="https://nice.freedesktop.org/releases/${MY_P}.tar.gz"

LICENSE="|| ( MPL-1.1 LGPL-2.1 )"
SLOT="1.0"
KEYWORDS="*"
IUSE=""

RDEPEND="
	>=net-libs/libnice-${PV}:0=[gstreamer]
	media-libs/gstreamer:${SLOT}
	media-libs/gst-plugins-base-${PV%.*}:${SLOT}
"

DEPEND="${RDEPEND}
	>=virtual/pkgconfig-0-r1
"