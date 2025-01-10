# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="Kate overlay codec suppport plugin for GStreamer"
KEYWORDS="*"
SLOT="1.0"
IUSE=""

RDEPEND="
>=media-libs/libkate-0.1.7
>=media-libs/libtiger-0.3.2
>=media-libs/gst-plugins-bad-${PV%.*}:1.0=
"

DEPEND="${RDEPEND}"