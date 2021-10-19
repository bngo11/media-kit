# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="AMRNB encoder/decoder and AMRWB decoder plugin for GStreamer"
KEYWORDS="*"
SLOT="1.0"
IUSE=""

RDEPEND="
>=media-libs/opencore-amr-0.1.3-r1
>=media-libs/gst-plugins-ugly-${PV%.*}:1.0=
"

DEPEND="${RDEPEND}"