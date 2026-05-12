# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="H.265 decoder plugin for GStreamer"
KEYWORDS="*"
SLOT="1.0"
IUSE=""

RDEPEND="
>=media-libs/libde265-0.9
>=media-libs/gst-plugins-bad-${PV%.*}:1.0=
"

DEPEND="${RDEPEND}"