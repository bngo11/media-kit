# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="V4L2 source/sink plugin for GStreamer"
KEYWORDS="*"
SLOT="1.0"
IUSE="udev"

RDEPEND="
>=media-libs/libv4l-0.9.5
>=media-libs/gst-plugins-base-${PV}:${SLOT}
udev? ( >=virtual/libgudev-208:= )
virtual/os-headers
>=media-libs/gst-plugins-good-${PV%.*}:1.0=
"

DEPEND="${RDEPEND}"