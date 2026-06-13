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
}:

buildPythonApplication {
  pname = "subplz";
  version = "2.0.0";

  src = fetchFromGitHub {
    owner = "kanjieater";
    repo = "SubPlz";
    rev = "master"; # Using master for now as requested
    sha256 = "sha256-jeHM7iQY8Cbat2Y/HcD8Og4IvGi1f4JjyhvLQAbmgxA=";
  };

  pyproject = true;

  # SubPlz bundles its own 'ats' and 'subplz' packages in the root.
  # Setuptools should find them.

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
    requests # for anki if needed
  ];

  nativeBuildInputs = [
    setuptools
    setuptools-scm
    makeWrapper
  ];

  postPatch = ''
    # remove strict versioning only in the dependencies section
    sed -E -i '/dependencies = \[/,/\]/ s/(~=|==|>=|<=|>)[[:space:]]*[0-9.]*//g' pyproject.toml

    # patch ats/main.py to explicitly capture stdout and stderr for ffmpeg extraction
    # this is critical for Mac support to avoid TypeError: a bytes-like object is required, not 'NoneType'
    substituteInPlace ats/main.py \
      --replace-fail 'run(quiet=True, input="")' 'run(capture_stdout=True, capture_stderr=True, input="")'
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
    description = "Generate accurate subtitles from audio, align existing subs to videos";
    homepage = "https://github.com/kanjieater/SubPlz";
    license = licenses.mit;
    mainProgram = "subplz";
  };
}
