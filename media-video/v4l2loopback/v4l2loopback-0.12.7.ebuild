# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit linux-mod-r1 toolchain-funcs

KEYWORDS="amd64 x86"
SRC_URI="https://github.com/umlaeute/v4l2loopback/tarball/1ecf810f0d687b647caa3050ae30cf51b5902afd -> v4l2loopback-0.12.7-1ecf810.tar.gz"

DESCRIPTION="v4l2 loopback device whose output is its own input"
HOMEPAGE="https://github.com/umlaeute/v4l2loopback"

LICENSE="GPL-2"
SLOT="0"
IUSE="examples"
S="${WORKDIR}/umlaeute-v4l2loopback-1ecf810"
CONFIG_CHECK="VIDEO_DEV"

pkg_setup() {
	linux-mod-r1_pkg_setup
	export KERNELRELEASE=${KV_FULL}
}

src_prepare() {
	default
	sed -i -e 's/gcc /$(CC) /' examples/Makefile || die
}

src_compile() {
	local modlist=(
		v4l2loopback=video:
	)

	linux-mod-r1_src_compile
	if use examples; then
		emake CC="$(tc-getCC)" -C examples
	fi
}

src_install() {
	linux-mod-r1_src_install
	dosbin utils/v4l2loopback-ctl
	dodoc doc/kernel_debugging.txt
	dodoc doc/docs.txt
	if use examples; then
		dosbin examples/yuv4mpeg_to_v4l2
		docinto examples
		dodoc examples/{*.sh,*.c,Makefile}
	fi
}