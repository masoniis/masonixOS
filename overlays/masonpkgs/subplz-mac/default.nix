{ pkgs, subplz-deps }:

let
  mlx-whisper = pkgs.python3Packages.callPackage ./mlx-whisper.nix { };
  silero-vad = pkgs.python3Packages.callPackage ./silero-vad.nix { };
in
pkgs.python3Packages.callPackage ./subplz-mac.nix {
  inherit (subplz-deps) stable-ts lingua-language-detector alass;
  inherit mlx-whisper silero-vad;
  inherit (pkgs.python3Packages) torchcodec srt genanki;
}
