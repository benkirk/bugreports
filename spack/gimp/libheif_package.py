# Copyright 2013-2022 Lawrence Livermore National Security, LLC and other
# Spack Project Developers. See the top-level COPYRIGHT file for details.
#
# SPDX-License-Identifier: (Apache-2.0 OR MIT)

from spack.package import *


class Libheif(CMakePackage):
    """libheif is an HEIF and AVIF file format decoder and encoder."""

    homepage = "https://github.com/strukturag/libheif"
    url = "https://github.com/strukturag/libheif/archive/refs/tags/v1.12.0.tar.gz"

    version("1.14.0", sha256="9901cb0743caa80c316fabcf785c39466f41dda5c42152f2b7992be43db8d047")
    version("1.13.0", sha256="50def171af4bc8991211d6027f3cee4200a86bbe60fddb537799205bf216ddca")
    version("1.12.0", sha256="086145b0d990182a033b0011caadb1b642da84f39ab83aa66d005610650b3c65")

    variant("libde265", default=False,  description="Build with libde265 for HEIF image decoding")
    variant("libx265",  default=False,  description="Build with libx265 for HEIF image encoding")

    depends_on("cmake@3.13:", type="build")
    depends_on("gettext")
    depends_on("libde265", when="+libde265")
    depends_on("libx265", when="+libx265")
