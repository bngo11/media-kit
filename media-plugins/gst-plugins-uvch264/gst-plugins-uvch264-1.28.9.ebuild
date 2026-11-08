# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="UVC compliant H264 encoding cameras plugin for GStreamer"
KEYWORDS="*"
SLOT="1.0"
IUSE=""

RDEPEND="
virtual/libgudev:=
virtual/libusb:1
>=media-libs/gst-plugins-bad-${PV%.*}:1.0=
"

DEPEND="${RDEPEND}"