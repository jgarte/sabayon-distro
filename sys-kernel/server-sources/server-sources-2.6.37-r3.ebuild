# Copyright 2004-2010 Sabayon Linux
# Distributed under the terms of the GNU General Public License v2

K_WANT_GENPATCHES=""
K_GENPATCHES_VER=""
K_SABPATCHES_VER="7"
K_KERNEL_PATCH_VER="6"
K_SABKERNEL_NAME="server"
K_SABKERNEL_URI_CONFIG="yes"
K_ONLY_SOURCES="1"
inherit sabayon-kernel
KEYWORDS="~amd64 ~x86"
DESCRIPTION="Official Sabayon Linux Server kernel sources"
RESTRICT="mirror"
IUSE="sources_standalone"

DEPEND="${DEPEND}
	sources_standalone? ( !=sys-kernel/linux-server-${PVR} )
	!sources_standalone? ( =sys-kernel/linux-server-${PVR} )"
