# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit autotools java-pkg-opt-2 flag-o-matic

DESCRIPTION="Blu-ray playback libraries"
HOMEPAGE="https://www.videolan.org/developers/libbluray.html"
SRC_URI="https://code.videolan.org/videolan/libbluray/-/archive/1.3.1/libbluray-1.3.1.tar.gz -> libbluray-1.3.1.tar.gz"
KEYWORDS="*"

LICENSE="LGPL-2.1"
SLOT="0/2"
IUSE="aacs bdplus +fontconfig java static-libs +truetype utils +xml"

RDEPEND="
	dev-libs/libudfread
	aacs? ( >=media-libs/libaacs-0.6.0 )
	bdplus? ( media-libs/libbdplus )
	fontconfig? ( >=media-libs/fontconfig-2.10.92 )
	java? ( >=virtual/jre-1.8:* )
	truetype? ( >=media-libs/freetype-2.5.0.1:2 )
	xml? ( >=dev-libs/libxml2-2.9.1-r4 )
"
DEPEND="
	${RDEPEND}
	java? ( >=virtual/jdk-1.8:* )
"
BDEPEND="
	virtual/pkgconfig
	java? (
		dev-java/ant-core
		>=virtual/jdk-1.8:*
	)
"

PATCHES=(
	"${FILESDIR}"/${PN}-jars.patch
)

DOCS=( ChangeLog README.md )

src_prepare() {
	default
	eautoreconf
}

src_configure() {
	use java || unset JDK_HOME # Bug #621992.

	ECONF_SOURCE="${S}" econf \
		--disable-optimizations \
		$(use_enable utils examples) \
		$(use_enable java bdjava-jar) \
		$(use_with fontconfig) \
		$(use_with truetype freetype) \
		$(use_enable static-libs static) \
		$(use_with xml libxml2)
}

src_install() {
	emake DESTDIR="${D}" install

	use utils &&
		find .libs/ -type f -executable ! -name "${PN}.*" \
			 $(use java || echo '! -name bdj_test') -exec dobin {} +

	use java &&
		java-pkg_regjar "${ED}"/usr/share/${PN}/lib/*.jar

	einstalldocs
	find "${ED}" -name '*.la' -delete || die
}