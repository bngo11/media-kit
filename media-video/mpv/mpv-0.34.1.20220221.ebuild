# Distributed under the terms of the GNU General Public License v2

EAPI=6

PYTHON_COMPAT=( python3+ )
PYTHON_REQ_USE='threads(+)'

inherit bash-completion-r1 eapi7-ver flag-o-matic gnome2-utils pax-utils python-r1 toolchain-funcs waf-utils xdg-utils

DESCRIPTION="Media player based on MPlayer and mplayer2"
HOMEPAGE="https://mpv.io/ https://github.com/mpv-player/mpv"
SRC_URI="https://github.com/mpv-player/mpv/archive/37927b65f719aac817717c88c10b05ca7246248a.tar.gz -> mpv-0.34.1.20220221-37927b65f719aac817717c88c10b05ca7246248a.tar.gz https://waf.io/waf-2.0.20"

DOCS=( RELEASE_NOTES README.md DOCS/{client-api,interface}-changes.rst )

# See Copyright in sources and Gentoo bug 506946. Waf is BSD, libmpv is ISC.
LICENSE="LGPL-2.1+ GPL-2+ BSD ISC"
SLOT="0"
KEYWORDS="*"
IUSE="+alsa aqua archive bluray cdda +cli coreaudio cplugins cuda debug doc drm dvb
	dvd +egl gamepad gbm +iconv jack javascript jpeg lcms libass libcaca libmpv +lua
	luajit openal +opengl pipewire pulseaudio raspberry-pi rubberband sdl
	selinux test tools +uchardet vaapi vdpau vulkan wayland +X +xv zlib zimg"

REQUIRED_USE="
	|| ( cli libmpv )
	aqua? ( opengl )
	cuda? ( opengl )
	egl? ( || ( gbm X wayland ) )
	gamepad? ( sdl )
	gbm? ( drm egl opengl )
	lcms? ( opengl )
	luajit? ( lua )
	opengl? ( || ( aqua egl X raspberry-pi !cli ) )
	raspberry-pi? ( opengl )
	test? ( opengl )
	tools? ( cli )
	uchardet? ( iconv )
	vaapi? ( || ( gbm X wayland ) )
	vdpau? ( X )
	vulkan? ( || ( X wayland ) )
	wayland? ( egl )
	X? ( egl? ( opengl ) )
	xv? ( X )
	${PYTHON_REQUIRED_USE}
"

RESTRICT="!test? ( test )"

COMMON_DEPEND="
	!!app-shells/mpv-bash-completion
	>=media-video/ffmpeg-4.0:0=[encode,threads,vaapi?,vdpau?]
	alsa? ( >=media-libs/alsa-lib-1.0.18 )
	archive? ( >=app-arch/libarchive-3.4.0:= )
	bluray? ( >=media-libs/libbluray-0.3.0:= )
	cdda? ( dev-libs/libcdio-paranoia
			dev-libs/libcdio:= )
	drm? ( x11-libs/libdrm )
	dvd? (
		>=media-libs/libdvdnav-4.2.0:=
		>=media-libs/libdvdread-4.1.0:=
	)
	egl? ( media-libs/mesa[egl,gbm(-)?,wayland(-)?] )
	gamepad? ( media-libs/libsdl2 )
	iconv? (
		virtual/libiconv
		uchardet? ( app-i18n/uchardet )
	)
	jack? ( virtual/jack )
	javascript? ( >=dev-lang/mujs-1.0.0 )
	jpeg? ( virtual/jpeg:0 )
	lcms? ( >=media-libs/lcms-2.6:2 )
	libass? (
		>=media-libs/libass-0.12.1:=[fontconfig,harfbuzz(+)]
		virtual/ttf-fonts
	)
	libcaca? ( >=media-libs/libcaca-0.99_beta18 )
	lua? (
		!luajit? ( <dev-lang/lua-5.3:= )
		luajit? ( dev-lang/luajit:2 )
	)
	openal? ( >=media-libs/openal-1.13 )
	pipewire? ( >=media-video/pipewire-0.3.6 )
	pulseaudio? ( media-sound/pulseaudio )
	raspberry-pi? ( >=media-libs/raspberrypi-userland-0_pre20160305-r1 )
	rubberband? ( >=media-libs/rubberband-1.8.0 )
	sdl? ( media-libs/libsdl2[sound,threads,video] )
	vaapi? ( x11-libs/libva:=[drm?,X?,wayland?] )
	vdpau? ( x11-libs/libvdpau )
	vulkan? (
		media-libs/libplacebo:=[vulkan]
		media-libs/shaderc
	)
	wayland? (
		>=dev-libs/wayland-1.6.0
		>=dev-libs/wayland-protocols-1.14
		>=x11-libs/libxkbcommon-0.3.0
	)
	X? (
		x11-libs/libX11
		x11-libs/libXScrnSaver
		x11-libs/libXext
		x11-libs/libXinerama
		x11-libs/libXrandr
		opengl? (
			x11-libs/libXdamage
			virtual/opengl
		)
		xv? ( x11-libs/libXv )
	)
	zlib? ( sys-libs/zlib )
	zimg? ( >=media-libs/zimg-2.9.2 )
"
DEPEND="${COMMON_DEPEND}
	${PYTHON_DEPS}
	virtual/pkgconfig
	dev-python/docutils
	cuda? ( >=media-libs/nv-codec-headers-8.2.15.7 )
	doc? ( dev-python/rst2pdf )
	dvb? ( virtual/linuxtv-dvb-headers )
	test? ( >=dev-util/cmocka-1.0.0 )
"
RDEPEND="${COMMON_DEPEND}
	cuda? ( x11-drivers/nvidia-drivers[X] )
	selinux? ( sec-policy/selinux-mplayer )
	tools? ( ${PYTHON_DEPS} )
"
src_unpack() {
	unpack ${A}
	mv "${WORKDIR}"/mpv-* "${S}" || die
}

src_prepare() {
	cp "${DISTDIR}"/waf-2.0.20 "${S}"/waf || die
	chmod +x "${S}"/waf || die
	default
}

src_configure() {
	python_setup
	tc-export CC PKG_CONFIG AR

	if use raspberry-pi; then
		append-cflags -I"${SYSROOT%/}${EPREFIX}/opt/vc/include"
		append-ldflags -L"${SYSROOT%/}${EPREFIX}/opt/vc/lib"
	fi

	local mywafargs=(
		--confdir="${EPREFIX}/etc/${PN}"

		$(usex cli '' '--disable-cplayer')
		$(use_enable libmpv libmpv-shared)

		#--disable-libmpv-static
		#--disable-static-build
		# See deep down below for build-date.
		#--disable-optimize # Don't add '-O2' to CFLAGS.
		$(usex debug '' '--disable-debug-build')

		$(use_enable doc html-build)
		$(use_enable doc pdf-build)
		--enable-manpage-build
		$(use_enable cplugins)
		$(use_enable test)

		$(use_enable iconv)
		$(use_enable lua)
		$(usex luajit '--lua=luajit' '')
		$(use_enable javascript)
		$(use_enable zlib)
		$(use_enable bluray libbluray)
		$(use_enable dvd dvdnav)
		$(use_enable cdda)
		$(use_enable uchardet)
		$(use_enable rubberband)
		$(use_enable lcms lcms2)
		#--disable-vapoursynth # Only available in overlays.
		$(use_enable archive libarchive)

		--enable-libavdevice

		# Audio outputs:
		$(use_enable sdl sdl2) # Listed under audio, but also includes video.
		#--disable-rsound # Only available in overlays.
		#--disable-sndio # Only available in overlays.
		$(use_enable pipewire pipewire)
		$(use_enable pulseaudio pulse)
		$(use_enable jack)
		$(use_enable openal)
		--disable-opensles
		$(use_enable alsa)
		$(use_enable coreaudio)

		# Video outputs:
		$(use_enable aqua cocoa)
		$(use_enable drm)
		$(usex cuda "$(use_enable drm cuda-hwaccel)" '--disable-cuda-hwaccel')
		$(use_enable gbm)
		$(use_enable wayland wayland-scanner)
		$(use_enable wayland wayland-protocols)
		$(use_enable wayland)
		$(use_enable X x11)
		$(use_enable xv)
		$(usex opengl "$(use_enable aqua gl-cocoa)" '--disable-gl-cocoa')
		$(usex opengl "$(use_enable X gl-x11)" '--disable-gl-x11')
		$(usex egl "$(use_enable X egl-x11)" '--disable-egl-x11')
		$(usex egl "$(use_enable gbm egl-drm)" '--disable-egl-drm')
		$(usex opengl "$(use_enable wayland gl-wayland)" '--disable-gl-wayland')
		$(use_enable vdpau)
		$(usex vdpau "$(use_enable opengl vdpau-gl-x11)" '--disable-vdpau-gl-x11')
		$(use_enable vaapi) # See below for vaapi-glx, vaapi-x-egl.
		$(usex vaapi "$(use_enable X vaapi-x11)" '--disable-vaapi-x11')
		$(usex vaapi "$(use_enable wayland vaapi-wayland)" '--disable-vaapi-wayland')
		$(usex vaapi "$(use_enable gbm vaapi-drm)" '--disable-vaapi-drm')
		$(use_enable libcaca caca)
		$(use_enable jpeg)
		$(use_enable vulkan shaderc)
		$(use_enable vulkan libplacebo)
		$(use_enable raspberry-pi rpi)
		$(usex libmpv "$(use_enable opengl plain-gl)" '--disable-plain-gl')
		$(usex opengl '' '--disable-gl')
		$(use_enable vulkan)
		$(use_enable gamepad sdl2-gamepad)

		# HWaccels:
		# Automagic Video Toolbox HW acceleration. See Gentoo bug 577332.
		$(use_enable cuda cuda-hwaccel)
		$(use_enable cuda cuda-interop)

		# TV features:
		$(use_enable dvb dvbin)

		# Miscellaneous features:
		$(use_enable zimg)
	)

	if use vaapi && use X; then
		mywafargs+=(
			$(use_enable egl vaapi-x-egl)
		)
	fi

	# Not for us
	mywafargs+=(
		--disable-android
		--disable-egl-android
		--disable-uwp
		--disable-audiounit
		--disable-macos-media-player
		--disable-wasapi
		--disable-ios-gl
		--disable-macos-touchbar
		--disable-macos-cocoa-cb
		--disable-tvos
		--disable-egl-angle-win32
		--disable-swift
	)

	mywafargs+=(
		--bashdir="$(get_bashcompdir)"
		--zshdir="${EPREFIX}"/usr/share/zsh/site-functions
)

	# Create reproducible non-live builds.
	mywafargs+=(--disable-build-date)

	waf-utils_src_configure "${mywafargs[@]}"
}

src_install() {
	waf-utils_src_install

	if use lua; then
		insinto /usr/share/${PN}
		doins -r TOOLS/lua
	fi

	if use cli && use luajit; then
		pax-mark -m "${ED}"usr/bin/${PN}
	fi

	if use tools; then
		dobin TOOLS/{mpv_identify.sh,umpv}
		newbin TOOLS/idet.sh mpv_idet.sh
		python_replicate_script "${ED}"usr/bin/umpv
	fi
}

pkg_postinst() {
	local rv softvol_0_18_1=0 osc_0_21_0=0 txtsubs_0_24_0=0 opengl_0_25_0=0

	for rv in ${REPLACING_VERSIONS}; do
		ver_test ${rv} -lt 0.18.1 && softvol_0_18_1=1
		ver_test ${rv} -lt 0.21.0 && osc_0_21_0=1
		ver_test ${rv} -lt 0.24.0 && txtsubs_0_24_0=1
		ver_test ${rv} -lt 0.25.0 && ! use opengl && opengl_0_25_0=1
	done

	if [[ ${softvol_0_18_1} -eq 1 ]]; then
		elog "Since version 0.18.1 the software volume control is always enabled."
		elog "This means that volume controls don't change the system volume,"
		elog "e.g. per-application volume with PulseAudio."
		elog "If you want to restore the previous behaviour, please refer to"
		elog
		elog "https://wiki.gentoo.org/wiki/Mpv#Volume_in_0.18.1"
		elog
	fi

	if [[ ${osc_0_21_0} -eq 1 ]]; then
		elog "In version 0.21.0 the default OSC layout was changed."
		elog "If you want to restore the previous layout, please refer to"
		elog
		elog "https://wiki.gentoo.org/wiki/Mpv#OSC_in_0.21.0"
		elog
	fi

	if [[ ${txtsubs_0_24_0} -eq 1 ]]; then
		elog "Since version 0.24.0 subtitles with .txt extension aren't autoloaded."
		elog "If you want to restore the previous behaviour, please refer to"
		elog
		elog "https://wiki.gentoo.org/wiki/Mpv#Subtitles_with_.txt_extension_in_0.24.0"
		elog
	fi

	if [[ ${opengl_0_25_0} -eq 1 ]]; then
		elog "Since version 0.25.0 the 'opengl' USE flag is mapped to"
		elog "the 'opengl' video output and no longer explicitly requires"
		elog "X11 or Mac OS Aqua. Consider enabling the 'opengl' USE flag."
	fi

	elog "If you want URL support, please install net-misc/youtube-dl."

	gnome2_icon_cache_update
	xdg_desktop_database_update
}

pkg_postrm() {
	gnome2_icon_cache_update
	xdg_desktop_database_update
}

src_test() {
	cd "${S}"/build/test || die
	local test
	for test in *; do
		if [[ -x ${test} ]]; then
			./"${test}" || die "Test suite failed"
		fi
	done
}