# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="VP8/VP9 video encoder/decoder plugin for GStreamer"
KEYWORDS="*"
SLOT="1.0"
IUSE=""

RDEPEND="
>=media-libs/libvpx-1.3.0:=
>=media-libs/gst-plugins-good-${PV%.*}:1.0=
"

DEPEND="${RDEPEND}"