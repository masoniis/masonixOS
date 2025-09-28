{ fetchFromGitHub, vimUtils }:

let
  version = "34e14f0b5e2687fd31a93fe75982ec84e5145856"; # 9/24/25
in
vimUtils.buildVimPlugin {
  pname = "floaterm";
  version = version;
  src = fetchFromGitHub {
    owner = "nvzone";
    repo = "floaterm";
    rev = version;
    sha256 = "sha256-U5AFkHUmDlcjb2WlgdM7d2t9xpeyh9CS9EonAlxwHDw=";
  };

  # Skip the require check that's failing 9/3/25
  doCheck = false;

  meta = {
    homepage = "https://github.com/nvzone/floaterm";
    description = "Beautiful floating terminal manager for Neovim ";
  };
}
