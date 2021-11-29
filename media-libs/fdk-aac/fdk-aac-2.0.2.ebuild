# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit multilib-minimal

KEYWORDS="*"
SRC_URI="mirror://sourceforge/opencore-amr/${P}.tar.gz"

DESCRIPTION="Fraunhofer AAC codec library"
HOMEPAGE="https://sourceforge.net/projects/opencore-amr/"
LICENSE="FraunhoferFDK"
# subslot == N where N is libfdk-aac.so.N
SLOT="0/2"

IUSE="examples"

PATCHES=( "${FILESDIR}"/${P}-always_inline.patch )

src_prepare() {
	default
	[[ ${PV} == *9999* ]] && eautoreconf
}

multilib_src_configure() {
	local myeconfargs=(
		--disable-static
		$(use_enable examples example)
	)
	ECONF_SOURCE=${S} econf "${myeconfargs[@]}"
}

multilib_src_install_all() {
	einstalldocs

	if use examples; then
		mv "${ED}/usr/bin/"{,fdk-}aac-enc || die
	fi

	# package provides .pc files
	find "${ED}" -name '*.la' -delete || die
}

pkg_postinst() {
	use examples && einfo "aac-enc was renamed to fdk-aac-enc to prevent file collision with other packages"
}
