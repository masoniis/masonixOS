{
  stdenv,
  lib,
  fetchurl,
}:

let
  version = "0.4.3";

  sources = {
    "x86_64-linux" = {
      url = "https://github.com/entireio/cli/releases/download/v${version}/entire_linux_amd64.tar.gz";
      hash = "sha256-u13eERmBMz7L6+W28/TdWEjRn5vepoCI1j/tBM7lZmE=";
    };
    "aarch64-linux" = {
      url = "https://github.com/entireio/cli/releases/download/v${version}/entire_linux_arm64.tar.gz";
      hash = "sha256-mG2uqoSWlOiZnWiZPtzlDqWityIC6ynfuvJcOi//YN0=";
    };
    "x86_64-darwin" = {
      url = "https://github.com/entireio/cli/releases/download/v${version}/entire_darwin_amd64.tar.gz";
      hash = "sha256-maC4lip/botIu5WL21STh5C8cYQpwsv0A4VEH8nhLT4=";
    };
    "aarch64-darwin" = {
      url = "https://github.com/entireio/cli/releases/download/v${version}/entire_darwin_arm64.tar.gz";
      hash = "sha256-jydsyxke9Z9cqB35dD7iVR1iqvjFUU5wFS1SBPCaOKM=";
    };
  };

  platform = stdenv.hostPlatform.system;
  source = sources.${platform} or (throw "Unsupported system: ${platform}");

in
stdenv.mkDerivation {
  pname = "entire";
  inherit version;

  src = fetchurl {
    inherit (source) url hash;
  };

  # source is a tar.gz, so it will be unpacked automatically.
  sourceRoot = ".";

  installPhase = ''
    runHook preInstall
    install -m755 -D entire $out/bin/entire
    runHook postInstall
  '';

  meta = with lib; {
    description = "Entire CLI";
    homepage = "https://entire.io";
    license = licenses.mit;
    maintainers = [ ];
    platforms = platforms.linux ++ platforms.darwin;
  };
}

