# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit autotools xdg

SRC_URI="https://github.com/strukturag/libheif/releases/download/v1.12.0/libheif-1.12.0.tar.gz -> libheif-1.12.0.tar.gz"
KEYWORDS="*"

DESCRIPTION="ISO/IEC 23008-12:2017 HEIF file format decoder and encoder"
HOMEPAGE="https://github.com/strukturag/libheif"

LICENSE="GPL-3"
SLOT="0/1.12"
IUSE="+aom gdk-pixbuf go rav1e test +threads x265"
REQUIRED_USE="test? ( go )"
RESTRICT="!test? ( test )"

BDEPEND="test? ( dev-lang/go )"
DEPEND="
	media-libs/dav1d:=
	media-libs/libde265:=
	media-libs/libpng:0=
	sys-libs/zlib:=
	virtual/jpeg:0=
	aom? ( >=media-libs/libaom-2.0.0:= )
	gdk-pixbuf? ( x11-libs/gdk-pixbuf )
	go? ( dev-lang/go )
	rav1e? ( media-video/rav1e:= )
	x265? ( media-libs/x265:= )"
RDEPEND="${DEPEND}"

src_prepare() {
	default
	sed -i -e 's:-Werror::' configure.ac || die
	eautoreconf
}

src_configure() {
	export GO111MODULE=auto
	local econf_args=(
		--enable-libde265
		--disable-static
		$(use go || echo --disable-go)
		$(use_enable aom)
		$(use_enable gdk-pixbuf)
		$(use_enable rav1e)
		$(use_enable threads multithreading)
		$(use_enable x265)
	)
	ECONF_SOURCE="${S}" econf "${econf_args[@]}"
}

src_test() {
	default
	emake -C go test
}

src_install() {
	default
	einstalldocs
	find "${ED}" -name '*.la' -delete || die
}