# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="HTTP client source/sink plugin for GStreamer"
KEYWORDS="*"
SLOT="1.0"
IUSE=""

RDEPEND="
>=net-libs/libsoup-2.48:2.4
>=media-libs/gst-plugins-good-${PV%.*}:1.0=
"

DEPEND="${RDEPEND}"