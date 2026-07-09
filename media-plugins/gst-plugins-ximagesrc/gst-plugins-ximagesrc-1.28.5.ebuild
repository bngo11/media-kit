# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="X11 video capture stream plugin for GStreamer"
KEYWORDS="*"
SLOT="1.0"
IUSE=""

RDEPEND="
>=media-libs/gst-plugins-base-${PV}:${SLOT}
>=x11-libs/libX11-1.6.2
>=x11-libs/libXdamage-1.1.4-r1
>=x11-libs/libXext-1.3.2
>=x11-libs/libXfixes-5.0.1
x11-base/xorg-proto
>=media-libs/gst-plugins-good-${PV%.*}:1.0=
"

DEPEND="${RDEPEND}"