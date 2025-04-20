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
	"gopkg.in/check.v1 v0.0.0-20161208181325-20d25e280405/go.mod"
	"gopkg.in/yaml.v3 v3.0.0-20200313102051-9f266ea9e77c"
	"gopkg.in/yaml.v3 v3.0.0-20200313102051-9f266ea9e77c/go.mod"
)

go-module_set_globals

DESCRIPTION="Commandline tool to customize Spotify client."
HOMEPAGE="https://github.com/khanhas/spicetify-cli"
SRC_URI="https://github.com/spicetify/spicetify-cli/tarball/0a9a7ff37379d572ef1082d4d94eb221c4ba7ba2 -> spicetify-cli-2.39.7-0a9a7ff.tar.gz
https://direct.funtoo.org/36/00/f9/3600f995bbb72cd887a9bfa996551b4cb6259ce6b4d75c6e027311aac9abf531a59ac05b0f2104c8c97007d2c75a2420aac9916425af31279b0274256ebb5899 -> spicetify-cli-2.39.7-funtoo-go-bundle-c7ae9806c2e1ed4068207ae3efec8d23fb0591b18eacd11f6ed1b43f4588b3309293cf04ce4a5225a18cb04b10568a24af6532e32493bb3bcd68bf95a4fccd7c.tar.gz"

LICENSE="Apache-2.0 BSD GPL-3 MIT"
SLOT="0"
KEYWORDS="*"
IUSE="hook"
S="${WORKDIR}/spicetify-cli-0a9a7ff"

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