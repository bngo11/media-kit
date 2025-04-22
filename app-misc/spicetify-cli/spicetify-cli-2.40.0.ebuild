# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit go-module

EGO_SUM=(
	"github.com/davecgh/go-spew v1.1.0"
	"github.com/davecgh/go-spew v1.1.0/go.mod"
	"github.com/go-ini/ini v1.67.0"
	"github.com/go-ini/ini v1.67.0/go.mod"
	"github.com/mattn/go-colorable v0.1.14"
	"github.com/mattn/go-colorable v0.1.14/go.mod"
	"github.com/mattn/go-isatty v0.0.20"
	"github.com/mattn/go-isatty v0.0.20/go.mod"
	"github.com/pmezard/go-difflib v1.0.0"
	"github.com/pmezard/go-difflib v1.0.0/go.mod"
	"github.com/stretchr/objx v0.1.0/go.mod"
	"github.com/stretchr/testify v1.7.1"
	"github.com/stretchr/testify v1.7.1/go.mod"
	"golang.org/x/net v0.39.0"
	"golang.org/x/net v0.39.0/go.mod"
	"golang.org/x/sys v0.6.0/go.mod"
	"golang.org/x/sys v0.32.0"
	"golang.org/x/sys v0.32.0/go.mod"
	"golang.org/x/text v0.24.0"
	"golang.org/x/text v0.24.0/go.mod"
	"gopkg.in/check.v1 v0.0.0-20161208181325-20d25e280405/go.mod"
	"gopkg.in/yaml.v3 v3.0.0-20200313102051-9f266ea9e77c"
	"gopkg.in/yaml.v3 v3.0.0-20200313102051-9f266ea9e77c/go.mod"
)

go-module_set_globals

DESCRIPTION="Commandline tool to customize Spotify client."
HOMEPAGE="https://github.com/khanhas/spicetify-cli"
SRC_URI="https://github.com/spicetify/spicetify-cli/tarball/52e085916fdae953b87e8d62201c69b99f34e386 -> spicetify-cli-2.40.0-52e0859.tar.gz
https://direct.funtoo.org/56/ab/74/56ab7478eb657ee9d127284bf6769adf81ca1ff645ffb91a40917237cec3a8cb7c0cbc70c179c1d3ef18f53fc15ec83c6e7e3e86cd642060446bcdb5741edd7c -> spicetify-cli-2.40.0-funtoo-go-bundle-7c97c7d07e281378ba08be42082b014b8f990b645a74a88fdb7ad8bc8182b9734b14f4aab5378daabbde0df2f5c8bf418dd5c7f21b17050d4cc85ff22cb09410.tar.gz"

LICENSE="Apache-2.0 BSD GPL-3 MIT"
SLOT="0"
KEYWORDS="*"
IUSE="hook"
S="${WORKDIR}/spicetify-cli-52e0859"

INSTALLDIR="/opt/${PN}"

src_compile() {
	go build \
        -ldflags="-s -w -X main.version=${PV}" \
        -mod=mod . || die "compile failed"
}

src_install() {
	insinto "${INSTALLDIR}"
	doins -r {CustomApps,Extensions,Themes,jsHelper,cli}
	fperms +x "${INSTALLDIR}/cli"
	dosym /opt/spicetify-cli/cli /usr/bin/spicetify

	if use hook; then
		insinto "/etc/portage/env/media-sound"
		newins "${FILESDIR}"/spotify-hook spotify
	fi
}