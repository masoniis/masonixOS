{
  lib,
  buildPythonApplication,
  fetchFromGitHub,
  beautifulsoup4,
  biopython,
  ebooklib,
  faster-whisper,
  ffmpeg-python,
  rapidfuzz,
  numpy,
  regex,
  wcwidth,
  natsort,
  tqdm,
  pysbd,
  stable-ts,
  ctranslate2,
  stanza,
  pyyaml,
  lingua-language-detector,
  loguru,
  pycountry,
  watchdog,
  requests,
  setuptools,
  setuptools-scm,
  makeWrapper,
  ffmpeg,
  alass,
  mlx-whisper,
  silero-vad,
  torchcodec,
  srt,
  genanki,
}:

buildPythonApplication {
  pname = "subplz-mac";
  version = "2.0.0";

  src = fetchFromGitHub {
    owner = "helica1";
    repo = "subplz-mac";
    rev = "main";
    sha256 = "sha256-mLsBbTRSBXDn4EyNnskmp9rmVetbTit3qUTnsUK05uY=";
  };

  pyproject = true;

  propagatedBuildInputs = [
    beautifulsoup4
    biopython
    ebooklib
    faster-whisper
    ffmpeg-python
    rapidfuzz
    numpy
    regex
    wcwidth
    natsort
    tqdm
    pysbd
    stable-ts
    ctranslate2
    stanza
    pyyaml
    lingua-language-detector
    loguru
    pycountry
    watchdog
    requests
    mlx-whisper
    silero-vad
    torchcodec
    srt
    genanki
  ];

  nativeBuildInputs = [
    setuptools
    setuptools-scm
    makeWrapper
  ];

  postPatch = ''
    # remove strict versioning only in the dependencies section
    sed -E -i '/dependencies = \[/,/\]/ s/(~=|==|>=|<=|>)[[:space:]]*[0-9.]*//g' pyproject.toml

    # Patch ats/main.py to explicitly capture stdout and stderr for ffmpeg extraction
    substituteInPlace ats/main.py \
      --replace-fail 'run(quiet=True, input="")' 'run(capture_stdout=True, capture_stderr=True, input="")'

    # Use external python script for complex patching (device logic, MLX support, etc)
    python3 ${./patch_mac.py}
  '';

  postInstall = ''
    wrapProgram $out/bin/subplz \
      --prefix PATH : ${
        lib.makeBinPath [
          ffmpeg
          alass
        ]
      }
  '';

  doCheck = false;

  meta = with lib; {
    description = "Apple Silicon optimized fork of SubPlz";
    homepage = "https://github.com/helica1/subplz-mac";
    license = licenses.mit;
    mainProgram = "subplz";
  };
}
