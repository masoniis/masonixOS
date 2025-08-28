{ fetchFromGitHub, vimUtils }:

vimUtils.buildVimPlugin {
  pname = "neotree-nesting-config-nvim";
  version = "089adb6d3e478771f4485be96128796fb01a20c4";
  src = fetchFromGitHub {
    owner = "saifulapm";
    repo = "neotree-file-nesting-config";
    rev = "089adb6d3e478771f4485be96128796fb01a20c4";
    sha256 = "sha256-VCwujwpiRR8+MLcLgTWsQe+y0+BYL9HRZD+OzafNGGA=";
  };

  meta = {
    description = "Nesting rule table for neotree.";
    homepage = "https://github.com/saifulapm/neotree-file-nesting-config";
  };
}
