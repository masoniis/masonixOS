{
  lib,
  buildPythonPackage,
  fetchPypi,
  hatchling,
  torch,
  torchaudio,
  numpy,
  onnxruntime,
  scipy,
  pyyaml,
}:

buildPythonPackage rec {
  pname = "silero-vad";
  version = "6.2.1";
  pyproject = true;

  src = fetchPypi {
    pname = "silero_vad";
    inherit version;
    hash = "sha256-sjBisOOfrRexJm/CPB57QpAhnb6CzghRCInjL2gfSzs=";
  };

  nativeBuildInputs = [ hatchling ];

  propagatedBuildInputs = [
    torch
    torchaudio
    numpy
    onnxruntime
    scipy
    pyyaml
  ];

  doCheck = false;

  meta = with lib; {
    description = "Silero VAD: pre-trained enterprise-grade Voice Activity Detector";
    homepage = "https://github.com/snakers4/silero-vad";
    license = licenses.mit;
  };
}
