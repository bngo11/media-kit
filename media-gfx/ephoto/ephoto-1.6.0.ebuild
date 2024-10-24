# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit meson xdg-utils

DESCRIPTION="Enlightenment image viewer written with EFL"
HOMEPAGE="https://www.enlightenment.org/about-ephoto"
SRC_URI="https://download.enlightenment.org/rel/apps/ephoto/ephoto-1.6.0.tar.xz"

LICENSE="BSD-2"
SLOT="0"
KEYWORDS="*"
IUSE="nls"

RDEPEND="dev-libs/efl[eet,X]"
DEPEND="${RDEPEND}"
BDEPEND="virtual/pkgconfig
	nls? ( sys-devel/gettext )"

src_configure() {
	local emesonargs=(
		$(meson_use nls)
	)

	meson_src_configure
}

pkg_postinst() {
	xdg_icon_cache_update
}

pkg_postrm() {
	xdg_icon_cache_update
}