# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="Video sink plugin for GStreamer that renders to a GtkWidget"
KEYWORDS="*"
SLOT="1.0"
IUSE="+egl gles2 +opengl wayland +X"

RDEPEND="
>=media-libs/gst-plugins-base-${PV}:${SLOT}[egl=,gles2=,opengl=,wayland=,X=]
>=x11-libs/gtk+-3.24:3
gles2? ( >=x11-libs/gtk+-3.24:3[X?,wayland?] )
opengl? ( >=x11-libs/gtk+-3.24:3[X?,wayland?] )
>=media-libs/gst-plugins-good-${PV%.*}:1.0=
!<media-libs/gst-plugins-bad-1.13.1:1.0
"

DEPEND="${RDEPEND}"