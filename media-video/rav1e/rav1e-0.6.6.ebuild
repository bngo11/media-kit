# Distributed under the terms of the GNU General Public License v2

EAPI=7

CRATES="
addr2line-0.21.0
adler-1.0.2
aho-corasick-1.1.2
anes-0.1.6
anyhow-1.0.76
aom-sys-0.3.2
arbitrary-0.4.7
arg_enum_proc_macro-0.3.4
arrayvec-0.7.4
assert_cmd-2.0.8
atty-0.2.14
autocfg-1.1.0
av-metrics-0.9.0
av1-grain-0.2.2
backtrace-0.3.69
bindgen-0.61.0
bitflags-1.3.2
bitflags-2.4.1
bitstream-io-1.10.0
bstr-1.8.0
built-0.5.2
bumpalo-3.14.0
bytemuck-1.14.0
byteorder-1.5.0
cargo-lock-8.0.3
cast-0.3.0
cc-1.0.83
cexpr-0.6.0
cfg-expr-0.15.5
cfg-if-1.0.0
ciborium-0.2.1
ciborium-io-0.2.1
ciborium-ll-0.2.1
clang-sys-1.6.1
clap-3.2.25
clap-4.0.32
clap_complete-4.0.7
clap_derive-4.0.21
clap_lex-0.2.4
clap_lex-0.3.0
cmake-0.1.50
color_quant-1.1.0
console-0.15.7
crc32fast-1.3.2
criterion-0.4.0
criterion-plot-0.5.0
crossbeam-0.8.3
crossbeam-channel-0.5.10
crossbeam-deque-0.8.4
crossbeam-epoch-0.9.17
crossbeam-queue-0.3.10
crossbeam-utils-0.8.18
dav1d-sys-0.7.3
diff-0.1.13
difflib-0.4.0
doc-comment-0.3.3
either-1.9.0
encode_unicode-0.3.6
env_logger-0.8.4
equivalent-1.0.1
errno-0.3.8
fdeflate-0.3.1
fern-0.6.2
flate2-1.0.28
float-cmp-0.9.0
form_urlencoded-1.2.1
getrandom-0.2.11
gimli-0.28.1
git2-0.15.0
glob-0.3.1
half-1.8.2
hashbrown-0.12.3
hashbrown-0.14.3
heck-0.4.1
hermit-abi-0.1.19
hermit-abi-0.3.3
home-0.5.9
idna-0.5.0
image-0.24.7
indexmap-1.9.3
indexmap-2.1.0
interpolate_name-0.2.4
io-lifetimes-1.0.11
is-terminal-0.4.9
itertools-0.8.2
itertools-0.10.5
itoa-1.0.10
jobserver-0.1.27
js-sys-0.3.66
lab-0.11.0
lazy_static-1.4.0
lazycell-1.3.0
libc-0.2.151
libfuzzer-sys-0.3.5
libgit2-sys-0.14.2+1.5.1
libloading-0.7.4
libz-sys-1.1.12
linux-raw-sys-0.3.8
linux-raw-sys-0.4.12
log-0.4.20
maybe-rayon-0.1.1
memchr-2.6.4
minimal-lexical-0.2.1
miniz_oxide-0.7.1
nasm-rs-0.2.5
new_debug_unreachable-1.0.4
nom-7.1.3
noop_proc_macro-0.3.0
normalize-line-endings-0.3.0
num-bigint-0.4.4
num-derive-0.3.3
num-derive-0.4.1
num-integer-0.1.45
num-rational-0.4.1
num-traits-0.2.17
object-0.32.2
once_cell-1.19.0
oorandom-11.1.3
os_str_bytes-6.6.1
paste-1.0.14
peeking_take_while-0.1.2
percent-encoding-2.3.1
pkg-config-0.3.28
plotters-0.3.5
plotters-backend-0.3.5
plotters-svg-0.3.5
png-0.17.10
ppv-lite86-0.2.17
predicates-2.1.5
predicates-core-1.0.5
predicates-tree-1.0.7
pretty_assertions-1.4.0
proc-macro-error-1.0.4
proc-macro-error-attr-1.0.4
proc-macro2-1.0.71
quickcheck-1.0.3
quickcheck_macros-1.0.0
quote-1.0.33
rand-0.8.5
rand_chacha-0.3.1
rand_core-0.6.4
rayon-1.8.0
rayon-core-1.12.0
regex-1.10.2
regex-automata-0.4.3
regex-syntax-0.8.2
rust_hawktracer-0.7.0
rust_hawktracer_normal_macro-0.4.1
rust_hawktracer_proc_macro-0.4.1
rust_hawktracer_sys-0.4.2
rustc-demangle-0.1.23
rustc-hash-1.1.0
rustc_version-0.4.0
rustix-0.37.27
rustix-0.38.28
ryu-1.0.16
same-file-1.0.6
scan_fmt-0.2.6
semver-1.0.20
serde-1.0.193
serde-big-array-0.4.1
serde_derive-1.0.193
serde_json-1.0.108
serde_spanned-0.6.5
shlex-1.2.0
signal-hook-0.3.17
signal-hook-registry-1.4.1
simd-adler32-0.3.7
simd_helpers-0.1.0
smallvec-1.11.2
syn-1.0.109
syn-2.0.42
system-deps-6.2.0
target-lexicon-0.12.12
termcolor-1.4.0
terminal_size-0.2.6
termtree-0.4.1
textwrap-0.16.0
thiserror-1.0.51
thiserror-impl-1.0.51
tinytemplate-1.2.1
tinyvec-1.6.0
tinyvec_macros-0.1.1
toml-0.5.11
toml-0.8.8
toml_datetime-0.6.5
toml_edit-0.21.0
unicode-bidi-0.3.14
unicode-ident-1.0.12
unicode-normalization-0.1.22
unicode-width-0.1.11
url-2.5.0
v_frame-0.3.6
vcpkg-0.2.15
version-compare-0.1.1
version_check-0.9.4
wait-timeout-0.2.0
walkdir-2.4.0
wasi-0.11.0+wasi-snapshot-preview1
wasm-bindgen-0.2.89
wasm-bindgen-backend-0.2.89
wasm-bindgen-macro-0.2.89
wasm-bindgen-macro-support-0.2.89
wasm-bindgen-shared-0.2.89
web-sys-0.3.66
which-4.4.2
winapi-0.3.9
winapi-i686-pc-windows-gnu-0.4.0
winapi-util-0.1.6
winapi-x86_64-pc-windows-gnu-0.4.0
windows-sys-0.45.0
windows-sys-0.48.0
windows-sys-0.52.0
windows-targets-0.42.2
windows-targets-0.48.5
windows-targets-0.52.0
windows_aarch64_gnullvm-0.42.2
windows_aarch64_gnullvm-0.48.5
windows_aarch64_gnullvm-0.52.0
windows_aarch64_msvc-0.42.2
windows_aarch64_msvc-0.48.5
windows_aarch64_msvc-0.52.0
windows_i686_gnu-0.42.2
windows_i686_gnu-0.48.5
windows_i686_gnu-0.52.0
windows_i686_msvc-0.42.2
windows_i686_msvc-0.48.5
windows_i686_msvc-0.52.0
windows_x86_64_gnu-0.42.2
windows_x86_64_gnu-0.48.5
windows_x86_64_gnu-0.52.0
windows_x86_64_gnullvm-0.42.2
windows_x86_64_gnullvm-0.48.5
windows_x86_64_gnullvm-0.52.0
windows_x86_64_msvc-0.42.2
windows_x86_64_msvc-0.48.5
windows_x86_64_msvc-0.52.0
winnow-0.4.1
winnow-0.5.30
y4m-0.8.0
yansi-0.5.1

"

inherit cargo

SRC_URI="
	https://api.github.com/repos/xiph/rav1e/tarball/v0.6.6 -> rav1e-0.6.6.tar.gz
	$(cargo_crate_uris ${CRATES})
"
KEYWORDS="*"

DESCRIPTION="The fastest and safest AV1 encoder"
HOMEPAGE="https://github.com//"
RESTRICT=""
LICENSE="BSD-2 Apache-2.0 MIT Unlicense"
SLOT="0"

IUSE="+capi"

ASM_DEP=">=dev-lang/nasm-2.15"
BDEPEND="
	amd64? ( ${ASM_DEP} )
	capi? ( dev-util/cargo-c )
"

src_unpack() {
	default
	cargo_src_unpack
	rm -rf ${S}
	mv ${WORKDIR}/--* ${S} || die
}

src_compile() {
	export CARGO_HOME="${ECARGO_HOME}"
	local args=$(usex debug "" --release)

	cargo build ${args} \
		|| die "cargo build failed"

	if use capi; then
		cargo cbuild ${args} --target-dir="capi" \
			--prefix="/usr" --libdir="/usr/$(get_libdir)" \
			|| die "cargo cbuild failed"
	fi
}

src_install() {
	export CARGO_HOME="${ECARGO_HOME}"
	local args=$(usex debug --debug "")

	if use capi; then
		cargo cinstall $args --target-dir="capi" \
			--prefix="/usr" --libdir="/usr/$(get_libdir)" --destdir="${ED%/}" \
			|| die "cargo cinstall failed"
	fi

	cargo_src_install
}