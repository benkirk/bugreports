#[ -d ./spack ] || git clone -c feature.manyFiles=true --branch releases/latest git@github.com:benkirk/spack.git
[ -d ./spack ] || git clone -c feature.manyFiles=true --branch add_gimp git@github.com:benkirk/spack.git

. ./config_env.sh || exit 1

spack config add "config:install_tree:padded_length: 0"

for arg in repos mirrors concretizer packages config modules compilers; do
    spack config blame ${arg} && echo && echo # show our current configuration, with what comes from where
done

spack debug report

spack maintainers gimp


spack add libde265 x265
spack concretize --fresh
spack install --no-cache --no-check-signature & spack install --no-cache --no-check-signature & spack install --no-cache --no-check-signature & spack install --no-cache --no-check-signature
wait
spack install --verbose --no-cache --deprecated --no-check-signature || exit 1
exit 0

# spack add meson ninja pkgconfig cmake libelf python
# spack concretize --fresh
# spack install --no-cache --no-check-signature & spack install --no-cache --no-check-signature & spack install --no-cache --no-check-signature & spack install --no-cache --no-check-signature || exit 1
# wait

# spack add glib exiv2 libmypaint@1.4.0~gegl+introspection vala
# spack concretize --fresh
# #spack install --no-check-signature || exit 1
# spack install --no-cache --no-check-signature & spack install --no-cache --no-check-signature & spack install --no-cache --no-check-signature & spack install --no-cache --no-check-signature || exit 1
# wait

# spack add gexiv2
# spack concretize --fresh
# # populate our source cache mirror
# spack mirror create --directory /glade/scratch/${USER}/spack_caches/source --all
# spack install --verbose --no-cache --deprecated --no-check-signature || exit 1
# #exit 0

spack add gimp ^gnutls@3.6.8 ^nettle@3.4.1 ^libproxy~python
spack concretize --fresh
# populate our source cache mirror
spack mirror create --directory /glade/scratch/${USER}/spack_caches/source --all
spack install --deprecated --no-check-signature & spack install --deprecated --no-check-signature & spack install --deprecated --no-check-signature & spack install --deprecated --no-check-signature
wait
spack install --verbose --deprecated --no-check-signature || exit 1
