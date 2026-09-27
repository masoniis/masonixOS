{
  config,
  pkgs-unstable,
  lib,
  ...
}:
{
  config = lib.mkIf config.language.csharp.enable {
    # unstable because stable darwin builds of dotnet aren't cached (would build from source).
    # sdk 10 matches the runtime csharp-ls is wrapped with, so no extra closure
    home.packages = [ pkgs-unstable.dotnet-sdk_10 ];
  };
}
