# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit depend.apache systemd

DESCRIPTION="PHP eselect module"
HOMEPAGE="https://gitweb.gentoo.org/proj/eselect-php.git/"
SRC_URI="https://dev.gentoo.org/~mjo/distfiles/${P}.tar.xz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~mips ~ppc ~ppc64 ~s390 ~sh ~sparc ~x86 ~amd64-fbsd ~x86-fbsd ~x86-freebsd ~amd64-linux ~ia64-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos"
IUSE="fpm apache2"

# The "DirectoryIndex" line in 70_mod_php.conf requires mod_dir.
RDEPEND="app-admin/eselect
	apache2? ( www-servers/apache[apache2_modules_dir] )"

want_apache

src_install() {
	default

	if use apache2 ; then
		insinto "${APACHE_MODULES_CONFDIR#${EPREFIX}}"
		doins "${FILESDIR}/70_mod_php.conf"
	fi

	if use fpm ; then
		newinitd "${FILESDIR}/php-fpm.init-r4" "php-fpm"
		systemd_dotmpfilesd "${FILESDIR}/php-fpm.conf"
		exeinto /usr/libexec
		doexe "${FILESDIR}/php-fpm-launcher"
	fi
}

pkg_postinst() {
	if use apache2 ; then
		elog
		elog "If you are upgrading, be warned that our mod_php configuration"
		elog "file has changed! You should now define -DPHP for the apache2"
		elog "daemon, and inspect the new 70_mod_php.conf which has been"
		elog "installed. Module loading involves eselect as of this version."
		elog
		elog "You must run eselect at least once to choose your apache2 target"
		elog "before the new configuration will work. Afterwards, and after you"
		elog "have reviewed your new configuration, you are advised to remove"
		elog "the obsolete 70_mod_php5.conf file."
		elog
	fi
}
