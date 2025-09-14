# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="ASS/SSA rendering with effects support plugin for GStreamer"
KEYWORDS="*"
SLOT="1.0"
IUSE=""

RDEPEND="
>=media-libs/libass-0.10.2:=
>=media-libs/gst-plugins-bad-${PV%.*}:1.0=
"

DEPEND="${RDEPEND}"