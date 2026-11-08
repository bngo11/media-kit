# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="AMR-WB audio encoder plugin for GStreamer"
KEYWORDS="*"
SLOT="1.0"
IUSE=""

RDEPEND="
>=media-libs/vo-amrwbenc-0.1.2-r1
>=media-libs/gst-plugins-bad-${PV%.*}:1.0=
"

DEPEND="${RDEPEND}"