{
  lib,
  buildPythonPackage,
  fetchPypi,
  tqdm,
  more-itertools,
  numpy,
  openai-whisper,
  setuptools,
  torchaudio,
}:

buildPythonPackage rec {
  pname = "stable-ts";
  version = "2.19.1";

  pyproject = true;

  src = fetchPypi {
    pname = "stable_ts";
    inherit version;
    sha256 = "sha256-Dsrx7ZPgKYOVaWGNLamle4g60E2yHwaAFG4GUMqvT1I=";
  };

  nativeBuildInputs = [
    setuptools
  ];

  propagatedBuildInputs = [
    tqdm
    more-itertools
    numpy
    openai-whisper
    torchaudio
  ];

  doCheck = false; # Tests might require data or be complex

  meta = with lib; {
    description = "Stable Whisper: Accurate time-stamps for Whisper transcription";
    homepage = "https://github.com/jm12138/stable-ts";
    license = licenses.mit;
  };
}
