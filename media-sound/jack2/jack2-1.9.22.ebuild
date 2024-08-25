# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3+ )
PYTHON_REQ_USE="threads(+)"
inherit python-single-r1 waf-utils


MY_PV="${PV/_rc/-RC}"
MY_P="${PN}-${MY_PV}"

DESCRIPTION="Jackdmp jack implemention for multi-processor machine"
HOMEPAGE="https://jackaudio.org/"
SRC_URI="https://github.com/jackaudio/jack2/archive/v${MY_PV}/v${MY_PV}.tar.gz -> ${P}.tar.gz
		 https://dev.gentoo.org/~ionen/distfiles/${P}-python3.12.patch.xz"

LICENSE="GPL-2"
SLOT="2"
KEYWORDS="*"
IUSE="alsa +classic dbus doc ieee1394 libsamplerate metadata opus pam"

REQUIRED_USE="
	${PYTHON_REQUIRED_USE}
	|| ( classic dbus )"

BDEPEND="
	virtual/pkgconfig
	doc? ( app-doc/doxygen )
"
DEPEND="${PYTHON_DEPS}
	media-libs/libsamplerate
	alsa? ( media-libs/alsa-lib )
	dbus? (
		dev-libs/expat
		sys-apps/dbus
	)
	ieee1394? ( media-libs/libffado:= )
	metadata? ( sys-libs/db:* )
	opus? ( media-libs/opus[custom-modes] )"
RDEPEND="${DEPEND}
	dbus? (
		$(python_gen_cond_dep '
			dev-python/dbus-python[${PYTHON_USEDEP}]
		')
	)
	pam? ( sys-auth/realtime-base )
	!media-sound/jack-audio-connection-kit:0"

DOCS=( AUTHORS.rst ChangeLog.rst README.rst README_NETJACK2 )

PATCHES=(
	"${WORKDIR}/${P}-python3.12.patch"
)

S="${WORKDIR}/${MY_P}"

src_prepare() {
	default
	python_fix_shebang waf
}

src_configure() {
	local mywafconfargs=(
		--htmldir=/usr/share/doc/${PF}/html
		$(usex dbus --dbus "")
		$(usex classic --classic "")
		--alsa=$(usex alsa yes no)
		--celt=no
		--db=$(usex metadata yes no)
		--doxygen=$(usex doc yes no)
		--firewire=$(usex ieee1394 yes no)
		--iio=no
		--opus=$(usex opus yes no)
		--portaudio=no
		--samplerate=$(usex libsamplerate yes no)
		--winmme=no
	)

	waf-utils_src_configure ${mywafconfargs[@]}
}
