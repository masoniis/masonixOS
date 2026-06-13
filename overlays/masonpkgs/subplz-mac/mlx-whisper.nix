{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  mlx,
  numba,
  numpy,
  torch,
  tqdm,
  more-itertools,
  tiktoken,
  huggingface-hub,
  scipy,
  setuptools,
}:

buildPythonPackage rec {
  pname = "mlx-whisper";
  version = "0.4.3";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "ml-explore";
    repo = "mlx-examples";
    rev = "796f5b53cab69a3d48a44233ce21aae889e94a08";
    sha256 = "sha256-Po8P1nLeaq+HyviBiZzrRLJPftPdRneFiVrtiFSS/EM=";
  };

  sourceRoot = "${src.name}/whisper";

  nativeBuildInputs = [ setuptools ];

  propagatedBuildInputs = [
    mlx
    numba
    numpy
    torch
    tqdm
    more-itertools
    tiktoken
    huggingface-hub
    scipy
  ];

  doCheck = false;

  meta = with lib; {
    description = "Whisper for Apple Silicon via MLX";
    homepage = "https://github.com/ml-explore/mlx-examples/tree/main/whisper";
    license = licenses.mit;
  };
}
