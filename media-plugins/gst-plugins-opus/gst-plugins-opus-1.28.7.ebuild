# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="Opus audio parser plugin for GStreamer"
KEYWORDS="*"
SLOT="1.0"
IUSE=""

RDEPEND="
>=media-libs/opus-1.1:=
>=media-libs/gst-plugins-base-${PV%.*}:1.0=[ogg]
"

DEPEND="${RDEPEND}"