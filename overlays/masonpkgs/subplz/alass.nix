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
    rev = "v${version}";
    sha256 = "sha256-fi4kpJEaD9v6wWl6fRfMP5myL8c9mNyxxtS/0IhWzM8=";
  };

  cargoHash = "sha256-U1rwktvRSr34V0lNQrrxg8fdchVpeSbyPClnZHRUpQs=";

  cargoBuildFlags = [ "--bins" ];

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
