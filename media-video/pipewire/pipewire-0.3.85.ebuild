# Distributed under the terms of the GNU General Public License v2

EAPI=7
PYTHON_COMPAT=( python3+ )

inherit meson python-any-r1 udev prefix


RESTRICT="mirror"

DESCRIPTION="Multimedia processing graphs"
HOMEPAGE="http://pipewire.org/"
SRC_URI="https://github.com/PipeWire/pipewire/tarball/7db1e7f643a454056327999b2d8e35d8097b5593 -> pipewire-0.3.85-7db1e7f.tar.gz"

LICENSE="MIT LGPL-2.1+ GPL-2"
SLOT="0"
KEYWORDS="*"

IUSE="bluetooth doc echo-cancel extra gstreamer jack-client jack-sdk lv2 +pipewire-alsa +sound-server ssl test v4l X zeroconf examples"

# Once replacing system JACK libraries is possible, it's likely that
# jack-client IUSE will need blocking to avoid users accidentally
# configuring their systems to send PW sink output to the emulated
# JACK's sink - doing so is likely to yield no audio, cause a CPU
# cycles consuming loop (and may even cause GUI crashes)!

REQUIRED_USE="
	jack-sdk? ( !jack-client )
	!sound-server? ( !pipewire-alsa )
"

RESTRICT="!test? ( test )"

BDEPEND="
	>=dev-util/meson-0.59
	virtual/pkgconfig
	${PYTHON_DEPS}
	$(python_gen_any_dep 'dev-python/docutils[${PYTHON_USEDEP}]')
	doc? (
		app-doc/doxygen
		media-gfx/graphviz
	)
"
RDEPEND="
	media-libs/alsa-lib
	sys-apps/dbus
	sys-libs/readline:=
	sys-libs/ncurses:=[unicode(+)]
	virtual/libintl
	virtual/libudev
	bluetooth? (
		media-libs/fdk-aac
		media-libs/libldac
		media-libs/libfreeaptx
		media-libs/sbc
		>=net-wireless/bluez-5.65:=
		virtual/libusb:1
	)
	echo-cancel? ( media-libs/webrtc-audio-processing:0 )
	extra? (
		>=media-libs/libsndfile-1.0.28
	)
	gstreamer? (
		>=dev-libs/glib-2.74.0:2
		>=media-libs/gstreamer-1.20.0:1.0
		media-libs/gst-plugins-base:1.0
	)
	jack-client? ( >=media-sound/jack2-1.9.17:2[dbus] )
	jack-sdk? (
		!media-sound/jack-audio-connection-kit
		!media-sound/jack2
	)
	lv2? ( media-libs/lilv )
	pipewire-alsa? (
		>=media-libs/alsa-lib-1.2.4
		!media-plugins/alsa-plugins[pulseaudio]
	)
	!pipewire-alsa? ( media-plugins/alsa-plugins[pulseaudio] )
	ssl? ( dev-libs/openssl:= )
	v4l? ( media-libs/libv4l )
	X? (
		media-libs/libcanberra
		x11-libs/libX11
	)
	zeroconf? ( net-dns/avahi )
"

DEPEND="${RDEPEND}"

# TODO: Consider use cases where pipewire is not used for driving audio
# Doing so with WirePlumber currently involves editing Lua scripts
PDEPEND=">=media-video/wireplumber-0.4.11"

DOCS=( {README,INSTALL}.md NEWS )

PATCHES=(
)

# limitsdfile related code taken from =sys-auth/realtime-base-0.1
# with changes as necessary.
limitsdfile=40-${PN}.conf

python_check_deps() {
	has_version -b "dev-python/docutils[${PYTHON_USEDEP}]"
}


post_src_unpack() {
	mv "${WORKDIR}/"PipeWire-pipewire* "${S}" || die
}

src_prepare() {
	default

	einfo "Generating ${limitsdfile}"
	cat > ${limitsdfile} <<- EOF || die
		# Start of ${limitsdfile} from ${P}

		@audio	-	memlock 256

		# End of ${limitsdfile} from ${P}
	EOF
}

src_configure() {
	local emesonargs=(
		-Ddocdir="${EPREFIX}"/usr/share/doc/${PF}

		$(meson_feature zeroconf avahi)
		$(meson_feature doc docs)
		$(meson_feature examples) # TODO: Figure out if this is still important now that media-session gone
		$(meson_feature doc man)
		$(meson_feature test tests)
		-Dinstalled_tests=disabled # Matches upstream; Gentoo never installs tests
		$(meson_feature gstreamer)
		$(meson_feature gstreamer gstreamer-device-provider)

		-Dsystemd=disabled
		-Dsystemd-system-service=disabled # Matches upstream
		-Dsystemd-user-service=disabled

		$(meson_feature pipewire-alsa) # Allows integrating ALSA apps into PW graph
		-Dspa-plugins=enabled
		-Dalsa=enabled # Allows using kernel ALSA for sound I/O (NOTE: media-session is gone so IUSE=alsa/spa_alsa/alsa-backend might be possible)
		-Daudiomixer=enabled # Matches upstream
		-Daudioconvert=enabled # Matches upstream
		$(meson_feature bluetooth bluez5)
		$(meson_feature bluetooth bluez5-backend-hsp-native)
		$(meson_feature bluetooth bluez5-backend-hfp-native)
		$(meson_feature bluetooth bluez5-backend-ofono)
		$(meson_feature bluetooth bluez5-backend-hsphfpd)
		$(meson_feature bluetooth bluez5-codec-aac)
		$(meson_feature bluetooth bluez5-codec-aptx)
		$(meson_feature bluetooth bluez5-codec-ldac)
		$(meson_feature bluetooth libusb) # At least for now only used by bluez5 native (quirk detection of adapters)
		$(meson_feature echo-cancel echo-cancel-webrtc) #807889
		-Dcontrol=enabled # Matches upstream
		-Daudiotestsrc=enabled # Matches upstream
		-Dffmpeg=disabled # Disabled by upstream and no major developments to spa/plugins/ffmpeg/ since May 2020
		-Dpipewire-jack=enabled # Allows integrating JACK apps into PW graph
		$(meson_feature jack-client jack) # Allows PW to act as a JACK client
		$(meson_use jack-sdk jack-devel)
		$(usex jack-sdk "-Dlibjack-path=${EPREFIX}/usr/$(get_libdir)" '')
		-Dsupport=enabled # Miscellaneous/common plugins, such as null sink
		-Devl=disabled # Matches upstream
		-Dtest=disabled # fakesink and fakesource plugins
		$(meson_feature lv2)
		$(meson_feature v4l v4l2)
		-Dlibcamera=disabled # libcamera is not in Portage tree
		$(meson_feature ssl raop)
		-Dvideoconvert=enabled # Matches upstream
		-Dvideotestsrc=enabled # Matches upstream
		-Dvolume=enabled # Matches upstream
		-Dvulkan=disabled # Uses pre-compiled Vulkan compute shader to provide a CGI video source (dev thing; disabled by upstream)
		$(meson_feature extra pw-cat)
		-Dudev=enabled
		-Dudevrulesdir="${EPREFIX}$(get_udevdir)/rules.d"
		-Dsdl2=disabled # Controls SDL2 dependent code (currently only examples when -Dinstalled_tests=enabled which we never install)
		$(meson_feature extra sndfile) # Enables libsndfile dependent code (currently only pw-cat)
		-Dsession-managers="[]" # All available session managers are now their own projects, so there's nothing to build

		# Just for bell sounds in X11 right now.
		$(meson_feature X x11)
		$(meson_feature X libcanberra)
	)

	meson_src_configure
}

src_install() {
	# Our custom DOCS do not exist in multilib source directory
	DOCS= meson_src_install
	einstalldocs

	insinto /etc/security/limits.d
	doins ${limitsdfile}

	if use pipewire-alsa; then
		dodir /etc/alsa/conf.d

		# Install pipewire conf loader hook
		insinto /usr/share/alsa/alsa.conf.d
		doins "${FILESDIR}"/99-pipewire-default-hook.conf
		eprefixify "${ED}"/usr/share/alsa/alsa.conf.d/99-pipewire-default-hook.conf

		# These will break if someone has /etc that is a symbolic link to a subfolder! See #724222
		# And the current dosym8 -r implementation is likely affected by the same issue, too.
		dosym ../../../usr/share/alsa/alsa.conf.d/50-pipewire.conf /etc/alsa/conf.d/50-pipewire.conf
		dosym ../../../usr/share/alsa/alsa.conf.d/99-pipewire-default-hook.conf /etc/alsa/conf.d/99-pipewire-default-hook.conf
	fi

	# Enable required wireplumber alsa and bluez monitors
	if use sound-server; then
		dodir /etc/wireplumber/main.lua.d
		echo "alsa_monitor.enabled = true" > "${ED}"/etc/wireplumber/main.lua.d/89-gentoo-sound-server-enable-alsa-monitor.lua || die

		dodir /etc/wireplumber/bluetooth.lua.d
		echo "bluez_monitor.enabled = true" > "${ED}"/etc/wireplumber/bluetooth.lua.d/89-gentoo-sound-server-enable-bluez-monitor.lua || die
	fi

	insinto /etc/xdg/autostart
	newins "${FILESDIR}"/pipewire.desktop pipewire.desktop

	exeinto /usr/libexec
	newexe "${FILESDIR}"/pipewire-launcher pipewire-launcher

	# Disable pipewire-pulse if sound-server is disabled.
	if ! use sound-server ; then
		sed -i -s '/pipewire -c pipewire-pulse.conf/s/^/#/' "${ED}"/usr/libexec/pipewire-launcher || die
	fi

	eprefixify "${ED}"/usr/libexec/pipewire-launcher
}
pkg_postinst() {
	elog "It is recommended to raise RLIMIT_MEMLOCK to 256 for users"
	elog "using PipeWire. Do it either manually or add yourself"
	elog "to the 'audio' group:"
	elog
	elog "  usermod -aG audio <youruser>"
	elog

	if ! use jack-sdk; then
		elog "JACK emulation is incomplete and not all programs will work. PipeWire's"
		elog "alternative libraries have been installed to a non-default location."
		elog "To use them, put pw-jack <application> before every JACK application."
		elog "When using pw-jack, do not run jackd/jackdbus. However, a virtual/jack"
		elog "provider is still needed to compile the JACK applications themselves."
		elog
	fi

	ewarn "PipeWire daemon startup has been moved to a launcher script!"
	ewarn "Make sure that ${EROOT}/etc/pipewire/pipewire.conf either does not exist or no"
	ewarn "longer is set to start a session manager or PulseAudio compatibility daemon (all"
	ewarn "lines similar to '{ path = /usr/bin/pipewire*' should be commented out)"
	ewarn
	ewarn "Those manually starting /usr/bin/pipewire via .xinitrc or similar _must_ from"
	ewarn "now on start ${EROOT}/usr/libexec/pipewire-launcher instead! It is highly"
	ewarn "advised that a D-Bus user session is set up before starting the script."
	ewarn
	if has_version 'media-sound/pulseaudio[daemon]' || has_version 'media-sound/pulseaudio-daemon'; then
		elog "This ebuild auto-enables PulseAudio replacement. Because of that, users"
		elog "are recommended to edit: ${EROOT}/etc/pulse/client.conf and disable"
		elog "autospawning of the original daemon by setting:"
		elog
		elog "  autospawn = no"
		elog
		elog "Please note that the semicolon (;) must _NOT_ be at the beginning of the line!"
		elog
		elog "Alternatively, if replacing PulseAudio daemon is not desired, edit"
		elog "${EROOT}/usr/libexec/pipewire-launcher by commenting out the relevant"
		elog "command:"
		elog
		elog "#${EROOT}/usr/bin/pipewire -c pipewire-pulse.conf &"
		elog
	fi
	elog "NOTE:"
	elog "Starting with PipeWire-0.3.30, this package is no longer installing its config"
	elog "into ${EROOT}/etc/pipewire by default. In case you need to change"
	elog "its config, please start by copying default config from ${EROOT}/usr/share/pipewire"
	elog "and just override the sections you want to change."
	elog

	elog "For latest tips and tricks, troubleshooting information and documentation"
	elog "in general, please refer to https://wiki.gentoo.org/wiki/PipeWire"
	elog

	#optfeature_header "The following can be installed for optional runtime features:"
	#optfeature "restricted realtime capabilities via D-Bus" sys-auth/rtkit

	if has_version 'net-misc/ofono' ; then
		ewarn "Native backend has become default. Please disable oFono via:"
		ewarn "rc-update delete ofono"
		ewarn
	fi
}