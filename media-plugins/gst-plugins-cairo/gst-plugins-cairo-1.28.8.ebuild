# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="Video overlay plugin based on cairo for GStreamer"
KEYWORDS="*"
SLOT="1.0"
IUSE=""

RDEPEND="
>=x11-libs/cairo-1.10[glib]
>=media-libs/gst-plugins-good-${PV%.*}:1.0=
"

DEPEND="${RDEPEND}"