# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: Exp $

inherit eutils

DESCRIPTION="Beryl window manager for AIGLX and XGL (meta)"
HOMEPAGE="http://beryl-project.org"
SRC_URI=""

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86 ~amd64 ~ppc ~ppc64"
IUSE="kde gnome"

RDEPEND="
	~x11-plugins/beryl-plugins-${PV}
	~x11-wm/emerald-${PV}
	kde?	( ~x11-wm/aquamarine-${PV} )
	gnome?	( ~x11-wm/heliodor-${PV} )
	~x11-misc/beryl-settings-${PV}
	~x11-misc/beryl-settings-simple-${PV}
	~x11-misc/beryl-manager-${PV}
	>=x11-libs/cairo-1.2
	"
	
pkg_setup() {
	if has_version ">=x11-libs/cairo-1.2.2" && ! built_with_use x11-libs/cairo X pdf; then
		einfo "Please re-emerge >=x11-libs/cairo-1.2.2 with the X and pdf USE flag set"
		die "Please emerge >=x11-libs/cairo-1.2.2 with the X and pdf flag set"
	fi
}
