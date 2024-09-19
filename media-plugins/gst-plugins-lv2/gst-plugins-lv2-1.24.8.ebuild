# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="Lv2 elements for Gstreamer"
KEYWORDS="*"
SLOT="1.0"
IUSE=""

RDEPEND="
>=media-libs/lv2-1.14.0-r1
>=media-libs/lilv-0.24.2-r2
>=media-libs/gst-plugins-bad-${PV%.*}:1.0=
"

DEPEND="${RDEPEND}"