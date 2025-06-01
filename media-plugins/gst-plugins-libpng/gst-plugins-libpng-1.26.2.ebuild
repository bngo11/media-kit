# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="PNG image encoder/decoder plugin for GStreamer"
KEYWORDS="*"
SLOT="1.0"
IUSE=""

RDEPEND="
>=media-libs/libpng-1.6.10:0=
>=media-libs/gst-plugins-good-${PV%.*}:1.0=
"

DEPEND="${RDEPEND}"