{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  poetry-core,
  numpy,
  regex,
}:

buildPythonPackage rec {
  pname = "lingua-language-detector";
  version = "1.3.4";

  pyproject = true;

  src = fetchFromGitHub {
    owner = "pemistahl";
    repo = "lingua-py";
    rev = "v${version}";
    sha256 = "sha256-R/+A4a+mJlE56SiJ5TNs99TXSi+hwjqX3z6D5uLZVzM=";
  };

  nativeBuildInputs = [
    poetry-core
  ];

  propagatedBuildInputs = [
    numpy
    regex
  ];

  postPatch = ''
    # Allow newer python versions and dependencies
    substituteInPlace pyproject.toml \
      --replace-fail 'python = ">=3.8,<3.13,!=3.11.0"' 'python = ">=3.8"' \
      --replace-fail 'regex = "^2023.10.3"' 'regex = "*"'
    sed -i '/numpy = \[/,/\]/c numpy = "*"' pyproject.toml
  '';

  doCheck = false;

  meta = with lib; {
    description = "The most accurate language detector for Python, suitable for long and short text alike";
    homepage = "https://github.com/pemistahl/lingua-py";
    license = licenses.asl20;
  };
}
