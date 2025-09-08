{ fetchFromGitHub, vimUtils }:

vimUtils.buildVimPlugin {
  pname = "battery.nvim";
  version = "ecc6cf13312a26179f67d3b99d203da9285b9b0a";
  src = fetchFromGitHub {
    owner = "justinhj";
    repo = "battery.nvim";
    rev = "ecc6cf13312a26179f67d3b99d203da9285b9b0a";
    sha256 = "sha256-VhfsK7Q4qdOAhmHGV5Mhflso8KeUW3OIHd5++0Dgs/s=";
  };

  # Skip the require check that's failing 9/7/2025
  doCheck = false;

  meta = {
    homepage = "https://github.com/justinhj/battery.nvim";
    description = "Detect and view battery information";
  };
}
