# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="Wavpack audio encoder/decoder plugin for GStreamer"
KEYWORDS="*"
SLOT="1.0"
IUSE=""

RDEPEND="
>=media-sound/wavpack-4.60.1-r1
>=media-libs/gst-plugins-good-${PV%.*}:1.0=
"

DEPEND="${RDEPEND}"