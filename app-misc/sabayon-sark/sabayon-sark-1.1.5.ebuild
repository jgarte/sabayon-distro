# Copyright 2004-2015 Sabayon
# Distributed under the terms of the GNU General Public License v2

EAPI=5

inherit eutils

DESCRIPTION="Sabayon Automated Repository Kit"
HOMEPAGE="http://www.sabayon.org"
SRC_URI="https://github.com/Sabayon/sabayon-sark/archive/v${PVR}.tar.gz -> ${P}.tar.gz"
RESTRICT="mirror"
SLOT="0"
LICENSE="GPL-2"
KEYWORDS="~amd64"
IUSE=""
S="${WORKDIR}/sabayon-sark-${PVR}"
DEPEND=""
RDEPEND="app-emulation/docker
	dev-lang/perl
	dev-python/shyaml
	dev-util/pkgs-checker
	app-misc/sabayon-devkit
	sys-process/tini"

src_install() {
	emake DESTDIR="${D}" \
		install || die
}
