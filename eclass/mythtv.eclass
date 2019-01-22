# Copyright 1999-2006 Gentoo Foundation
# Copyright 2010-2015 Andres Kahk
# ( If you make changes, please add a copyright notice above, but
# never remove an existing notice. )
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/eclass/mythtv.eclass,v 1.13 2008/04/01 04:05:02 cardoe Exp $
#
# @ECLASS: mythtv.eclass
# @MAINTAINER: Doug Goldstein <cardoe@gentoo.org>
# @BLURB: Downloads the MythTV source packages and any patches from the fixes branch
#

inherit eutils versionator git-r3

# Release version
MY_PV="${PVR}"

# what product do we want
case "${PN}" in
	mythtv) MY_PN="mythtv"
	EGIT_REPO_URI="https://github.com/MythTV/mythtv.git"
	;;
	mythtv-themes) MY_PN="myththemes"
	EGIT_REPO_URI="https://github.com/MythTV/myththemes.git"
	;;
	mythweb) MY_PN="myththemes"
	EGIT_REPO_URI="https://github.com/MythTV/mythweb.git"
	;;
	*) MY_PN="mythplugins"
	#EGIT_PROJECT="mythtv.git"
	EGIT_REPO_URI="https://github.com/MythTV/mythtv.git"
	;;
esac

# _pre is from GIT trunk while _p and _beta are from SVN ${MY_PV}-fixes
# TODO: probably ought to do something smart if the regex doesn't match anything
[[ "${PV}" =~ (_beta|_pre|_p|_alpha)([0-9]+) ]] || {
	eerror "Invalid version requested (_alpha|_beta|_pre|_p) only"
	exit 1
}

REV_PREFIX="${BASH_REMATCH[1]}" # _beta, _pre, or _p
MYTHTV_REV="${BASH_REMATCH[2]}" # revision number

#case $REV_PREFIX in
#	_pre|_alpha) MYTHTV_REPO="trunk/${MY_PN}";;
#	_p|_beta) VER_COMP=( $(get_version_components ${MY_PV}) )
#	          FIXES_VER="${VER_COMP[0]}-${VER_COMP[1]}"
#	          MYTHTV_REPO="branches/release-${FIXES_VER}-fixes/${MY_PN}";;
#esac

HOMEPAGE="http://www.mythtv.org"
LICENSE="GPL-2"
SRC_URI=""
