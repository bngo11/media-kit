# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="CD Audio Source (cdda) plugin for GStreamer"
KEYWORDS="*"
SLOT="1.0"
IUSE=""

RDEPEND="
>=media-sound/cdparanoia-3.10.2-r6
>=media-libs/gst-plugins-base-${PV%.*}:1.0=
"

DEPEND="${RDEPEND}"