# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6
SLREV=4
inherit gnome2-utils

DESCRIPTION="SVG and PNG icon theme from the Tango project"
HOMEPAGE="http://tango.freedesktop.org"
SRC_URI="http://tango.freedesktop.org/releases/${P}.tar.gz
	branding? ( mirror://sabayon/x11-themes/fdo-icons-sabayon${SLREV}.tar.gz )"

LICENSE="public-domain"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE="branding minimal png"

RDEPEND="!hppa? ( !minimal? ( x11-themes/adwaita-icon-theme ) )
	>=x11-themes/hicolor-icon-theme-0.12"
DEPEND="${RDEPEND}
	dev-util/intltool
	virtual/pkgconfig
	>=gnome-base/librsvg-2.34
	virtual/imagemagick-tools[png?]
	sys-devel/gettext
	>=x11-misc/icon-naming-utils-0.8.90"

RESTRICT="binchecks strip"

DOCS="AUTHORS ChangeLog README"

src_prepare() {
	sed -i -e '/svgconvert_prog/s:rsvg:&-convert:' configure || die #413183

	# https://bugs.gentoo.org/472766
	shopt -s nullglob
	cards=$(echo -n /dev/dri/card* | sed 's/ /:/g')
	if test -n "${cards}"; then
		addpredict "${cards}"
	fi
	shopt -u nullglob
	default
}

src_configure() {
	econf \
		$(use_enable png png-creation) \
		$(use_enable png icon-framing)
}

src_install() {
	addwrite /root/.gnome2
	default

	if use branding; then
		# replace tango icon start-here.{png,svg} with Sabayon ones
		for dir in "${D}"/usr/share/icons/Tango/*/places; do
			base_dir=$(dirname "${dir}")
			icon_dir=$(basename "${base_dir}")
			sabayon_svg_file="${WORKDIR}"/fdo-icons-sabayon/scalable/places/start-here.svg
			if [ "${icon_dir}" = "scalable" ]; then
				cp "${sabayon_svg_file}" "${dir}/start-here.svg" || die
			else
				convert  -background none -resize \
					"${icon_dir}" "${sabayon_svg_file}" \
					"${dir}/start-here.png" || die
			fi
		done
	fi
}

pkg_preinst() {	gnome2_icon_savelist; }
pkg_postinst() { gnome2_icon_cache_update; }
pkg_postrm() { gnome2_icon_cache_update; }
