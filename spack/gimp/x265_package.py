# Copyright 2013-2022 Lawrence Livermore National Security, LLC and other
# Spack Project Developers. See the top-level COPYRIGHT file for details.
#
# SPDX-License-Identifier: (Apache-2.0 OR MIT)

from spack.package import *


class X265(CMakePackage):
    """x265 is an open source HEVC encoder."""

    homepage = "https://x265.readthedocs.io/en/master/"
    url = "http://ftp.videolan.org/pub/videolan/x265/x265_3.2.1.tar.gz"

    maintainers = ["benkirk"]

    version("3.2.1", sha256="fb9badcf92364fd3567f8b5aa0e5e952aeea7a39a2b864387cec31e3b58cbbcc")
    version("3.2", sha256="364d79bcd56116a9e070fdeb1d9d2aaef1a786b4970163fb56ff0991a183133b")
    version("3.1.1", sha256="827900c7cc0a0105b8a96460fab7cd22b97afa7b2835b5cb979c44bddaa3c8d0")
    version("3.0", sha256="c5b9fc260cabbc4a81561a448f4ce9cad7218272b4011feabc3a6b751b2f0662")
    version("2.9", sha256="ebae687c84a39f54b995417c52a2fdde65a4e2e7ebac5730d251471304b91024")

    depends_on("cmake@2.8.11:", type="build")
    depends_on("nasm")
