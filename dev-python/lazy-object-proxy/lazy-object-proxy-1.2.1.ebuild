# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

PYTHON_COMPAT=( python2_7 python3_{3,4,5} pypy )

inherit distutils-r1

DESCRIPTION="A fast and thorough lazy object proxy"
HOMEPAGE="
	https://github.com/ionelmc/python-lazy-object-proxy
	http://pypi.python.org/pypi/lazy-object-proxy
	https://python-lazy-object-proxy.readthedocs.org/"
SRC_URI="mirror://pypi/${P:0:1}/${PN}/${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~ia64 ~ppc ~ppc64 ~sparc ~x86 ~amd64-linux ~x86-linux"
IUSE="test"

RDEPEND=""
DEPEND="${REDEPEND}
	dev-python/setuptools[${PYTHON_USEDEP}]
	test? (
		dev-python/pytest[${PYTHON_USEDEP}]
	)"

python_prepare_all() {
	# No need to benchmark
	sed \
		-e '/benchmark/s:test_:_&:g' \
		-e '/pytest.mark.benchmark/d' \
		-i tests/test_lazy_object_proxy.py || die
	distutils-r1_python_prepare_all
}

python_test() {
	py.test -v -v --ignore=src || die "Fails for ${EPYTHON}"
}
