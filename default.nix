{ lib
, stdenv
, fetchurl
, zstd
, protonCachyosVersions
}:

stdenv.mkDerivation {
  pname = "proton-cachyos";
  # Combining base and release for the nix version
  version = "${protonCachyosVersions.base}.${protonCachyosVersions.release}";

  src = fetchurl {
    # The URL needs the encoded colon %3A and the specific dash structure
    # Updated to: proton-cachyos-1:BASE.RELEASE-2-x86_64_v3... 
    # (Assuming the package release is usually '2' or '1')
    url = "https://mirror.cachyos.org/repo/x86_64_v3/cachyos-v3/proton-cachyos-1%3A${protonCachyosVersions.base}.${protonCachyosVersions.release}-2-x86_64_v3.pkg.tar.zst";
    inherit (protonCachyosVersions) hash;
  };

  nativeBuildInputs = [ zstd ];

  unpackPhase = ''
    # Use -I zstd for tar to handle the compression
    tar -I zstd -xf $src
  '';

  installPhase = ''
    mkdir -p $out/share/steam/compatibilitytools.d
    # CachyOS packages usually have a 'usr' folder inside the tarball
    mv usr/share/steam/compatibilitytools.d/proton-cachyos $out/share/steam/compatibilitytools.d/
  '';

  meta = with lib; {
    description = "CachyOS Proton build with additional patches and optimizations";
    homepage = "https://github.com/CachyOS/proton-cachyos";
    license = licenses.bsd3;
    platforms = [ "x86_64-linux" ];
    maintainers = with maintainers; [ kimjongbing ];
  };
}
