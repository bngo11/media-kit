# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit cmake gnome3-utils

DESCRIPTION="Library for encoding and decoding .avif files"
HOMEPAGE="https://github.com/AOMediaCodec/libavif"
SRC_URI="https://github.com/AOMediaCodec/libavif/archive/v0.9.3.tar.gz -> libavif-0.9.3.tar.gz"

LICENSE="BSD-2"
SLOT="0"
KEYWORDS="*"
IUSE="+aom dav1d examples extras gdk-pixbuf rav1e"

REQUIRED_USE="|| ( aom dav1d )"

DEPEND="
	media-libs/libpng
	sys-libs/zlib
	virtual/jpeg
	aom? ( >=media-libs/libaom-2.0.0:= )
	dav1d? ( media-libs/dav1d )
	gdk-pixbuf? ( x11-libs/gdk-pixbuf:2 )
	rav1e? ( media-video/rav1e[capi] )"

RDEPEND="${DEPEND}"
BDEPEND="virtual/pkgconfig"

src_unpack() {
	default
	pushd "${WORKDIR}"
	mv AOMediaCodec-libavif-* libavif-0.9.3
	popd
}

src_configure() {
	local mycmakeargs=(
		-DBUILD_SHARED_LIBS=ON
		-DAVIF_CODEC_AOM=$(usex aom ON OFF)
		-DAVIF_CODEC_DAV1D=$(usex dav1d ON OFF)
		-DAVIF_CODEC_LIBGAV1=OFF

		# Use system libraries.
		-DAVIF_LOCAL_ZLIBPNG=OFF
		-DAVIF_LOCAL_JPEG=OFF

		-DAVIF_BUILD_GDK_PIXBUF=$(usex gdk-pixbuf ON OFF)
		-DAVIF_ENABLE_WERROR=OFF
		-DAVIF_CODEC_RAV1E=$(usex rav1e ON OFF)
		# Dropping svt support since it's archived now and won't be receiving updates
		-DAVIF_CODEC_SVT=OFF
		-DAVIF_BUILD_EXAMPLES=$(usex examples ON OFF)
		-DAVIF_BUILD_APPS=$(usex extras ON OFF)
		-DAVIF_BUILD_TESTS=$(usex extras ON OFF)
	)

	cmake_src_configure
}

pkg_preinst() {
	if use gdk-pixbuf ; then
		gnome3_gdk_pixbuf_savelist
	fi
}

pkg_postinst() {
	if ! use aom && ! use rav1e ; then
		ewarn "No AV1 encoder is set,"
		ewarn "libavif will work in read-only mode."
		ewarn "Enable aom, rav1e or svt-av1 flag if you want to save .AVIF files."
	fi

	if use gdk-pixbuf ; then
		# causes segfault if set, see bug 375615
		unset __GL_NO_DSO_FINALIZER
		gnome3_gdk_pixbuf_update
	fi
}

pkg_postrm() {
	if use gdk-pixbuf ; then
		# causes segfault if set, see bug 375615
		unset __GL_NO_DSO_FINALIZER
		gnome3_gdk_pixbuf_update
	fi
}