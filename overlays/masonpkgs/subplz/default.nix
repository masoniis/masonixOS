{ pkgs }:

let
  stable-ts = pkgs.python3Packages.callPackage ./stable-ts.nix { };
  lingua-language-detector = pkgs.python3Packages.callPackage ./lingua-language-detector.nix { };
  alass = pkgs.callPackage ./alass.nix { };
in
pkgs.python3Packages.callPackage ./subplz.nix {
  inherit stable-ts lingua-language-detector alass;
}
