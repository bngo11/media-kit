# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="Microsoft Multi Media Server source plugin for GStreamer"
KEYWORDS="*"
SLOT="1.0"
IUSE=""

RDEPEND="
>=media-libs/libmms-0.6.2-r1
>=media-libs/gst-plugins-bad-${PV%.*}:1.0=
"

DEPEND="${RDEPEND}"