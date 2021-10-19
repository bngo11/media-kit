# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="Fiwewire DV/HDV capture plugin for GStreamer"
KEYWORDS="*"
SLOT="1.0"
IUSE=""

RDEPEND="
>=media-libs/libiec61883-1.2.0-r1
>=sys-libs/libraw1394-2.1.0-r1
>=sys-libs/libavc1394-0.5.4-r1
>=media-libs/gst-plugins-good-${PV%.*}:1.0=
"

DEPEND="${RDEPEND}"