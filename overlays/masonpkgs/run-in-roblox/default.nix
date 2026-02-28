{ pkgs }:

pkgs.rustPlatform.buildRustPackage rec {
  pname = "run-in-roblox";
  version = "0.3.0";

  src = pkgs.fetchFromGitHub {
    owner = "rojo-rbx";
    repo = "run-in-roblox";
    rev = "v${version}";
    sha256 = "sha256-cMqmAg2ac8xxDIDt0m/mxLkn7VT6rlIUSeogx+zQd/s=";
  };

  # use the absolute-relative path syntax
  cargoLock = {
    lockFile = ./Cargo.lock;
  };

  nativeBuildInputs = [ pkgs.pkg-config ];
  buildInputs = [ pkgs.openssl ];

  # only build the main binary
  cargoBuildFlags = [
    "--bin"
    "run-in-roblox"
  ];

  # copy the file and make it writable
  postPatch = ''
    rm -f Cargo.lock
    cp ${./Cargo.lock} Cargo.lock
    chmod +w Cargo.lock
  '';

  doCheck = false;
}
