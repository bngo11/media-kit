# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit go-module

EGO_SUM=(
	"github.com/davecgh/go-spew v1.1.0"
	"github.com/davecgh/go-spew v1.1.0/go.mod"
	"github.com/go-ini/ini v1.67.0"
	"github.com/go-ini/ini v1.67.0/go.mod"
	"github.com/mattn/go-colorable v0.1.13"
	"github.com/mattn/go-colorable v0.1.13/go.mod"
	"github.com/mattn/go-isatty v0.0.16"
	"github.com/mattn/go-isatty v0.0.16/go.mod"
	"github.com/pmezard/go-difflib v1.0.0"
	"github.com/pmezard/go-difflib v1.0.0/go.mod"
	"github.com/stretchr/objx v0.1.0/go.mod"
	"github.com/stretchr/testify v1.7.1"
	"github.com/stretchr/testify v1.7.1/go.mod"
	"golang.org/x/net v0.17.0"
	"golang.org/x/net v0.17.0/go.mod"
	"golang.org/x/sys v0.0.0-20220811171246-fbc7d0a398ab/go.mod"
	"golang.org/x/sys v0.13.0"
	"golang.org/x/sys v0.13.0/go.mod"
	"gopkg.in/check.v1 v0.0.0-20161208181325-20d25e280405/go.mod"
	"gopkg.in/yaml.v3 v3.0.0-20200313102051-9f266ea9e77c"
	"gopkg.in/yaml.v3 v3.0.0-20200313102051-9f266ea9e77c/go.mod"
)

go-module_set_globals

DESCRIPTION="Commandline tool to customize Spotify client."
HOMEPAGE="https://github.com/khanhas/spicetify-cli"
SRC_URI="https://github.com/spicetify/spicetify-cli/tarball/8124d48db83490feb82ae4964b0a244b66de0cad -> spicetify-cli-2.25.0-8124d48.tar.gz
https://direct.funtoo.org/dd/89/6b/dd896b03fd54b641a3d793825c38467f29eaef4e1ff3fbd1cd289ba30c97e37b7b098650416dbe71723a4427a9708976ec43f9fda3e9a11d95ad3926c4d3479a -> spicetify-cli-2.25.0-funtoo-go-bundle-ba161f37e7b5cc8e9ff6659cb0d00b5a94fc3bcc242798252ad04a75f863670fe39ce9281237ded065e3cc5ebbe2b0c746da6a692e2a77e5b28a08972265c811.tar.gz"

LICENSE="Apache-2.0 BSD GPL-3 MIT"
SLOT="0"
KEYWORDS="*"
IUSE="hook"
S="${WORKDIR}/spicetify-spicetify-cli-8124d48"

INSTALLDIR="/opt/${PN}"

PATCHES=(
	"${FILESDIR}/${PN}-recognize_funtoo_install_path.patch"
)

src_compile() {
	go build \
        -ldflags="-s -w -X main.version=${PV}" \
        -mod=mod . || die "compile failed"
}

src_install() {
	insinto "${INSTALLDIR}"
	doins -r {CustomApps,Extensions,Themes,jsHelper,spicetify-cli}
	fperms +x "${INSTALLDIR}/spicetify-cli"
	dosym /opt/spicetify-cli/spicetify-cli /usr/bin/spicetify

	if use hook; then
		insinto "/etc/portage/env/media-sound"
		newins "${FILESDIR}"/spotify-hook spotify
	fi
}