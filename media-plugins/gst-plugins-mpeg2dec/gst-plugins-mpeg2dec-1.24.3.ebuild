# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="MPEG2 decoder plugin for GStreamer"
KEYWORDS="*"
SLOT="1.0"
IUSE=""

RDEPEND="
>=media-libs/libmpeg2-0.5.1-r2
>=media-libs/gst-plugins-ugly-${PV%.*}:1.0=
"

DEPEND="${RDEPEND}"