{
  lib,
  fetchFromGitHub,
  rustPlatform,
  ffmpeg,
}:

rustPlatform.buildRustPackage rec {
  pname = "alass";
  version = "2.0.0";

  src = fetchFromGitHub {
    owner = "kaegi";
    repo = "alass";
    rev = "c438ff6344b24319e6804ed42cceb606d63961ea";
    sha256 = "sha256-q1IV9TtmznpR7RO75iN0p16nmTja5ADWqFj58EOPWvU=";
  };

  cargoHash = "sha256-d/gYGjNBcl8GmbwlvuK6odjBActuwiozuVf5BUowjYg=";

  cargoBuildFlags = [ "--bins" ];

  cargoPatches = [
    ./alass-cargo-lock.patch
  ];

  postPatch = ''
    rm -rf alass-cli/examples
  '';

  nativeBuildInputs = [ ];
  buildInputs = [ ];

  meta = with lib; {
    description = "Automatic Language-Agnostic Subtitle Synchronization";
    homepage = "https://github.com/kaegi/alass";
    license = licenses.gpl3Plus;
    platforms = platforms.all;
  };
}
