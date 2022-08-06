# Distributed under the terms of the GNU General Public License v2

EAPI=7

# 1. Please regularly check (even at the point of bumping) Fedora's packaging
# for needed backports at https://src.fedoraproject.org/rpms/wireplumber/tree/rawhide
#
# 2. Keep an eye on git master (for both PipeWire and WirePlumber) as things
# continue to move quickly. It's not uncommon for fixes to be made shortly
# after releases.

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
	sys-devel/gettext
"

DEPEND="
	${LUA_DEPS}
	>=dev-libs/glib-2.62
	>=media-video/pipewire-0.3.53-r1:=
	virtual/libintl
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
	"${FILESDIR}"/${PN}-0.4.10-config-disable-sound-server-parts.patch # defer enabling sound server parts to media-video/pipewire
	"${FILESDIR}"/${P}-alsa-lua-crash.patch
	"${FILESDIR}"/${P}-dbus-reconnect-crash.patch
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

src_install() {
	meson_src_install

	# We copy the default config, so that Gentoo tools can pick up on any
	# updates and /etc does not end up with stale overrides.
	# If a reflinking CoW filesystem is used (e.g. Btrfs), then the files
	# will not actually get stored twice until modified.
	insinto /etc
	doins -r "${ED}"/usr/share/wireplumber
}

pkg_postinst() {
	ewarn "Switch to WirePlumber will happen the next time gentoo-pipewire-launcher"
	ewarn "is started (a replacement for directly calling pipewire binary)."
	ewarn
	ewarn "Please ensure that ${EROOT}/etc/pipewire/pipewire.conf either does not exist"
	ewarn "or, if it does exist, that any reference to"
	ewarn "${EROOT}/usr/bin/pipewire-media-session is commented out (begins with a #)."
}
