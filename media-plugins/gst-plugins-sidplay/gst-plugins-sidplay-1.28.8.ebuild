# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="Sid decoder plugin for GStreamer"
KEYWORDS="*"
SLOT="1.0"
IUSE=""

RDEPEND="
>=media-libs/libsidplay-1.36.59-r1:1
>=media-libs/gst-plugins-ugly-${PV%.*}:1.0=
"

DEPEND="${RDEPEND}"