{ stdenv, lib, fetchurl, withReadline ? true, readline }:

stdenv.mkDerivation rec {
  pname = "oil";
  version = "0.10.1";

  src = fetchurl {
    url = "https://www.oilshell.org/download/oil-${version}.tar.xz";
    sha256 = "sha256-jI+QQ+jE3Qzd0b9VishVwBzDlFHCVKv8cZ0BsHnkd0Q=";
  };

  postPatch = ''
    patchShebangs build
  '';

  preInstall = ''
    mkdir -p $out/bin
  '';

  strictDeps = true;
  buildInputs = lib.optional withReadline readline;
  configureFlags = lib.optional withReadline "--with-readline";

  # Stripping breaks the bundles by removing the zip file from the end.
  dontStrip = true;

  meta = {
    description = "A new unix shell";
    homepage = "https://www.oilshell.org/";

    license = with lib.licenses; [
      psfl # Includes a portion of the python interpreter and standard library
      asl20 # Licence for Oil itself
    ];

    platforms = lib.platforms.all;
    maintainers = with lib.maintainers; [ lheckemann alva ];
    changelog = "https://www.oilshell.org/release/${version}/changelog.html";
  };

  passthru = {
    shellPath = "/bin/osh";
  };
}
