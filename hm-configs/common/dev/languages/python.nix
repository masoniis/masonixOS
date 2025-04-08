{
  config,
  pkgs,
  lib,
  ...
}:
{
  config = lib.mkIf config.language.python.enable {
    home.packages = with pkgs; [
      uv
      (python3.withPackages (
        ps: with ps; [
          black # formatter
          isort # import sorter
          pyright # lang server for type checking
          python-lsp-server # other lang server
          matplotlib
          numpy
          bandit
        ]
      ))
    ];

    programs.poetry = {
      enable = true;
    };
  };
}
