# Copyright 1999-2019 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI="6"

AVAHI_MODULE="${AVAHI_MODULE:-${PN/avahi-}}"
MY_P=${P/-${AVAHI_MODULE}}
MY_PN=${PN/-${AVAHI_MODULE}}

WANT_AUTOMAKE=1.11

inherit autotools eutils flag-o-matic systemd user

DESCRIPTION="System which facilitates service discovery on a local network (gtk pkg)"
HOMEPAGE="http://avahi.org/"
SRC_URI="https://github.com/lathiat/avahi/archive/v${PV}.tar.gz -> ${MY_P}.tar.gz"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~hppa ~ia64 ~mips ~ppc ~ppc64 ~s390 ~sh ~sparc ~x86 ~amd64-fbsd ~x86-fbsd ~x86-linux"
IUSE="dbus gdbm nls"

S="${WORKDIR}/${MY_P}"

COMMON_DEPEND="
	~net-dns/avahi-base-${PV}[dbus=,gdbm=,nls=]
	x11-libs/gtk+:2
"

DEPEND="${COMMON_DEPEND}"
RDEPEND="${COMMON_DEPEND}"

src_prepare() {
	default

	# Prevent .pyc files in DESTDIR
	>py-compile

	eautoreconf
}

src_configure() {
	# those steps should be done once-per-ebuild rather than per-ABI
	use sh && replace-flags -O? -O0

	local myconf=( --disable-static )

	myconf+=( --disable-qt5 )

	econf \
		--localstatedir="${EPREFIX}/var" \
		--with-distro=gentoo \
		--disable-python-dbus \
		--disable-manpages \
		--disable-xmltoman \
		--disable-mono \
		--disable-monodoc \
		--enable-glib \
		--enable-gobject \
		$(use_enable dbus) \
		--disable-python \
		$(use_enable nls) \
		--disable-introspection \
		--disable-qt3 \
		--disable-qt4 \
		--enable-gtk \
		--disable-gtk3 \
		$(use_enable gdbm) \
		--with-systemdsystemunitdir="$(systemd_get_systemunitdir)" \
		"${myconf[@]}"
}

src_compile() {
	for target in avahi-common avahi-client avahi-glib avahi-ui; do
		emake -C "${target}" || die
	done
	emake avahi-ui.pc || die
}

src_install() {
	mkdir -p "${D}/usr/bin" || die

	emake -C avahi-ui DESTDIR="${D}" install || die
	dodir /usr/$(get_libdir)/pkgconfig
	insinto /usr/$(get_libdir)/pkgconfig
	doins avahi-ui.pc

	# Workaround for avahi-ui.h collision between avahi-gtk and avahi-gtk3
	root_avahi_ui="${ROOT}usr/include/avahi-ui/avahi-ui.h"
	if [ -e "${root_avahi_ui}" ]; then
		rm -f "${D}usr/include/avahi-ui/avahi-ui.h"
	fi

	# provided by avahi-gtk3
	rm "${D}"usr/bin/bshell || die
	rm "${D}"usr/bin/bssh || die
	rm "${D}"usr/bin/bvnc || die
	rm "${D}"usr/share/applications/bssh.desktop || die
	rm "${D}"usr/share/applications/bvnc.desktop || die

	prune_libtool_files --all
}
