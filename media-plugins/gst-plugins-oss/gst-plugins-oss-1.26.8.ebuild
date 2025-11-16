# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="OSS (Open Sound System) support plugin for GStreamer"
KEYWORDS="*"
SLOT="1.0"
IUSE=""

RDEPEND="
virtual/os-headers
>=media-libs/gst-plugins-good-${PV%.*}:1.0=
"

DEPEND="${RDEPEND}"