# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="JPEG image encoder/decoder plugin for GStreamer"
KEYWORDS="*"
SLOT="1.0"
IUSE=""

RDEPEND="
>=virtual/jpeg-0-r2:0
>=media-libs/gst-plugins-good-${PV%.*}:1.0=
"

DEPEND="${RDEPEND}"