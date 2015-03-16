# Copyright 1999-2008 Gentoo Foundation
# Copyright 2010-2015 Andres Kahk
# ( If you make changes, please add a copyright notice above, but
# never remove an existing notice. )
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-plugins/mythweather/mythweather-0.21_p16468.ebuild,v 1.1 2008/03/09 20:45:09 cardoe Exp $

EAPI=4
inherit mythtv-plugins

DESCRIPTION="Weather forecast module for MythTV."
IUSE=""
KEYWORDS="~amd64 ~ppc ~x86"

DEPEND="dev-perl/DateManip
	dev-perl/ImageSize
	dev-perl/SOAP-Lite
	dev-perl/XML-Simple
	dev-perl/XML-Parser
	dev-perl/XML-SAX
	dev-perl/DateTime-Format-ISO8601
	dev-perl/XML-XPath
	dev-perl/JSON
	"

setup_pro() {
	return 0
}

src_install() {
        mythtv-plugins_src_install
}
