# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="MPEG-DASH plugin for GStreamer"
KEYWORDS="*"
SLOT="1.0"
IUSE=""

RDEPEND="
>=dev-libs/libxml2-2.9.1-r4
>=media-libs/gst-plugins-bad-${PV%.*}:1.0=
"

DEPEND="${RDEPEND}"