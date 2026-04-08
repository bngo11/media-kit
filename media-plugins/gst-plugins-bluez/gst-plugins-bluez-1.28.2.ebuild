# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="AVDTP source/sink and A2DP sink plugin for GStreamer"
KEYWORDS="*"
SLOT="1.0"
IUSE=""

RDEPEND="
>=net-wireless/bluez-5
>=media-libs/gst-plugins-bad-${PV%.*}:1.0=
dev-util/gdbus-codegen
"

DEPEND="${RDEPEND}"