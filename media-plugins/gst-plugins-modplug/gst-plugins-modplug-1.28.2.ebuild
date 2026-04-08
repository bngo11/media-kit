# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="MOD audio decoder plugin for GStreamer"
KEYWORDS="*"
SLOT="1.0"
IUSE=""

RDEPEND="
>=media-libs/libmodplug-0.8.8.4-r1
>=media-libs/gst-plugins-bad-${PV%.*}:1.0=
"

DEPEND="${RDEPEND}"