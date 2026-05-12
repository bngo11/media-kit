# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="HTTP live streaming plugin for GStreamer"
KEYWORDS="*"
SLOT="1.0"
IUSE=""

RDEPEND="
dev-libs/nettle:0=
>=media-libs/gst-plugins-bad-${PV%.*}:1.0=
"

DEPEND="${RDEPEND}"