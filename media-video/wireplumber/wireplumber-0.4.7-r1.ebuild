# Distributed under the terms of the GNU General Public License v2

EAPI=7

LUA_COMPAT=( lua5-{3,4} )

inherit lua-single meson systemd

SRC_URI="https://gitlab.freedesktop.org/pipewire/${PN}/-/archive/${PV}/${P}.tar.gz"
KEYWORDS="*"

DESCRIPTION="Replacement for pipewire-media-session"
HOMEPAGE="https://gitlab.freedesktop.org/pipewire/wireplumber"

LICENSE="MIT"
SLOT="0"
IUSE="test"

REQUIRED_USE="
	${LUA_REQUIRED_USE}
"

RESTRICT="!test? ( test )"

# introspection? ( dev-libs/gobject-introspection ) is valid but likely only used for doc building
BDEPEND="
	dev-libs/glib
	dev-util/gdbus-codegen
	dev-util/glib-utils
"

DEPEND="
	${LUA_DEPS}
	>=dev-libs/glib-2.62
	>=media-video/pipewire-0.3.43:=
	virtual/libc
	sys-auth/elogind
"

# Any dev-lua/* deps get declared like this inside RDEPEND:
#	$(lua_gen_cond_dep '
#		dev-lua/<NAME>[${LUA_USEDEP}]
#	')
RDEPEND="${DEPEND}
"

DOCS=( {NEWS,README}.rst )

PATCHES=(
	"${FILESDIR}"/${P}-default-nodes-handle-nodes-without-Routes.patch
)

src_configure() {
	local emesonargs=(
		-Ddoc=disabled # Ebuild not wired up yet (Sphinx, Doxygen?)
		-Dintrospection=disabled # Only used for Sphinx doc generation
		-Dsystem-lua=true # We always unbundle everything we can
		-Dsystem-lua-version=$(ver_cut 1-2 $(lua_get_version))
		-Delogind=enabled
		-Dsystemd=disabled
		-Dsystemd-system-service=false # Matches upstream
		-Dsystemd-user-service=false
		-Dsystemd-system-unit-dir=None
		-Dsystemd-user-unit-dir=None
		$(meson_use test tests)
	)

	meson_src_configure
}

pkg_postinst() {
	ewarn "Switch to WirePlumber will happen the next time gentoo-pipewire-launcher"
	ewarn "is started (a replacement for directly calling pipewire binary)."
	ewarn
	ewarn "Please ensure that ${EROOT}/etc/pipewire/pipewire.conf either does not exist"
	ewarn "or, if it does exist, that any reference to"
	ewarn "${EROOT}/usr/bin/pipewire-media-session is commented out (begins with a #)."
}
